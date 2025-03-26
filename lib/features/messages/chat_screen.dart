import 'dart:async'; 
import 'package:clinicc/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:clinicc/features/messages/message_bubble.dart';
import 'package:clinicc/features/messages/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const ChatScreen({super.key, required this.userId, required this.userName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  final ChatService _chatService = ChatService();
  StreamSubscription<List<Map<String, dynamic>>>? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _subscribeToMessages();
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    final fetchedMessages = await _chatService.fetchMessages(widget.userId);
    setState(() {
      messages = fetchedMessages;
    });
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    await _chatService.sendMessage(widget.userId, messageText);
    _messageController.clear();
    _fetchMessages();
  }

  void _subscribeToMessages() {
    try {
      _messageSubscription = _chatService.subscribeToMessages(
        widget.userId,
        (newMessages) {
          setState(() {
            messages = newMessages;
          });
        },
      );
    } catch (e) {
      print('Error subscribing to messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName,
            style: const TextStyle(
                color: AppColors.black, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.color1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return MessageBubble(
                  text: message['message_text'],
                  isMe: message['sender_id'] ==
                      Supabase.instance.client.auth.currentUser?.id,
                  isRead: message['is_read'],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
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
