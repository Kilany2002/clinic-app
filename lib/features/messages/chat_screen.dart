import 'dart:async';
import 'dart:io';
import 'package:clinicc/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:clinicc/features/messages/message_bubble.dart';
import 'package:clinicc/features/messages/chat_service.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;
    static String id = 'chat';


  const ChatScreen({super.key, required this.userId, required this.userName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  final FocusNode _focusNode = FocusNode();
  final Map<String, Map<String, dynamic>> _messageCache = {};

  List<Map<String, dynamic>> messages = [];
  bool _isTyping = false;
  bool _otherUserTyping = false;
  bool _isLoading = false;
  bool _hasMoreMessages = true;
  int _messageOffset = 0;
  final int _messageLimit = 20;

  StreamSubscription<List<Map<String, dynamic>>>? _messageSubscription;
  StreamSubscription<Map<String, dynamic>?>? _typingSubscription;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _subscribeToMessages();
    _subscribeToTypingStatus();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _sendTypingStatus(true);
      }
    });

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _typingSubscription?.cancel();
    _typingTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    if (_isLoading || !_hasMoreMessages) return;

    setState(() => _isLoading = true);

    final newMessages = await _chatService.fetchMessages(
      widget.userId,
      limit: _messageLimit,
      offset: _messageOffset,
    );

    // Add new messages to cache
    for (final message in newMessages) {
      _messageCache[message['id']] = message;
    }

    setState(() {
      if (newMessages.isEmpty) {
        _hasMoreMessages = false;
      } else {
        messages = _getSortedMessages();
        _messageOffset += newMessages.length;
        if (_scrollController.position.pixels == 0) {
          _markMessagesAsRead();
        }
      }
      _isLoading = false;
    });

    if (_messageOffset == _messageLimit && _scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == 0 && _hasMoreMessages) {
      _loadMessages();
    }
  }

  void _subscribeToMessages() {
    _messageSubscription =
        _chatService.subscribeToMessages(widget.userId).listen((newMessages) {
      // Update cache with new messages
      for (final message in newMessages) {
        _messageCache[message['id']] = message;
      }

      setState(() {
        messages = _getSortedMessages();
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });

      if (_scrollController.hasClients &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100) {
        _markMessagesAsRead();
      }
    });
  }

  List<Map<String, dynamic>> _getSortedMessages() {
    return _messageCache.values.toList()
      ..sort((a, b) => DateTime.parse(a['created_at'])
          .compareTo(DateTime.parse(b['created_at'])));
  }

  void _subscribeToTypingStatus() {
    _typingSubscription =
        _chatService.subscribeToTypingStatus(widget.userId).listen((status) {
      setState(() {
        _otherUserTyping = status?['is_typing'] == true;
      });
    });
  }

  Future<void> _markMessagesAsRead() async {
    final unreadMessages = messages
        .where((m) =>
            !m['is_read'] &&
            m['receiver_id'] == Supabase.instance.client.auth.currentUser?.id)
        .map((m) => m['id'] as String)
        .toList();

    if (unreadMessages.isNotEmpty) {
      await _chatService.markMessagesAsRead(unreadMessages);
      setState(() {
        for (var message in messages) {
          if (unreadMessages.contains(message['id'])) {
            message['is_read'] = true;
            _messageCache[message['id']] = message;
          }
        }
      });
    }
  }

  void _sendTypingStatus(bool isTyping) {
    _typingTimer?.cancel();

    if (isTyping) {
      _chatService.sendTypingStatus(widget.userId, true);
      _typingTimer = Timer(const Duration(seconds: 3), () {
        _chatService.sendTypingStatus(widget.userId, false);
      });
    } else {
      _chatService.sendTypingStatus(widget.userId, false);
    }
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    await _chatService.sendMessage(widget.userId, messageText);
    _messageController.clear();
    _sendTypingStatus(false);
  }

  Future<void> _pickAndSendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      await _chatService.sendMessage(
        widget.userId,
        'Sent an image',
        attachment: file,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.userName),
            if (_otherUserTyping)
              const Text(
                'typing...',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
          ],
        ),
        backgroundColor: AppColors.color1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: false,
              itemCount: messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final message = messages[index];
                return MessageBubble(
                  text: message['message_text'],
                  isMe: message['sender_id'] ==
                      Supabase.instance.client.auth.currentUser?.id,
                  isRead: message['is_read'],
                  attachmentUrl: message['attachment_url'],
                  attachmentType: message['attachment_type'],
                  timestamp: DateTime.parse(message['created_at']),
                );
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    '${widget.userName.split(' ')[0]} is typing...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _pickAndSendImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        _sendTypingStatus(true);
                      } else {
                        _sendTypingStatus(false);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
