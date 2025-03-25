import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/widgets/custom_app_bar.dart';
import 'package:clinicc/features/messages/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> conversations = [];
  List<Map<String, dynamic>> filteredConversations = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchConversations() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final response = await _supabase
        .from('messages')
        .select()
        .or('sender_id.eq.${user.id},receiver_id.eq.${user.id}')
        .order('created_at', ascending: false);

    final Map<String, Map<String, dynamic>> groupedConversations = {};
    for (final message in response) {
      final otherUserId = message['sender_id'] == user.id
          ? message['receiver_id']
          : message['sender_id'];

      if (!groupedConversations.containsKey(otherUserId)) {
        final otherUserName = await fetchUserName(otherUserId);
        groupedConversations[otherUserId] = {
          ...message,
          'other_user_name': otherUserName,
        };
      }
    }

    setState(() {
      conversations = groupedConversations.values.toList();
      filteredConversations = conversations; // Initialize filtered list
    });
  }

  Future<String> fetchUserName(String userId) async {
    final response =
        await _supabase.from('users').select('name').eq('id', userId).single();

    return response['name'] ?? 'Unknown User';
  }

  String formatMessageTime(String timestamp) {
    final DateTime messageTime = DateTime.parse(timestamp).toLocal();
    final DateTime now = DateTime.now().toLocal();
    if (messageTime.year == now.year &&
        messageTime.month == now.month &&
        messageTime.day == now.day) {
      return '${messageTime.hour}:${messageTime.minute.toString().padLeft(2, '0')}';
    }

    final Duration difference = now.difference(messageTime);
    if (difference.inDays < 7) {
      return _getDayOfWeek(messageTime.weekday);
    }

    return '${messageTime.day}/${messageTime.month}/${messageTime.year}';
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  void _filterConversations(String query) {
    setState(() {
      filteredConversations = conversations
          .where((conversation) => conversation['other_user_name']
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Conversations',
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: _filterConversations,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredConversations.length,
              itemBuilder: (context, index) {
                final conversation = filteredConversations[index];
                final otherUserId =
                    conversation['sender_id'] == _supabase.auth.currentUser?.id
                        ? conversation['receiver_id']
                        : conversation['sender_id'];
                final otherUserName = conversation['other_user_name'];

                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: AppColors.greyColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.color1,
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.person, size: 30),
                    ),
                    title: Text(
                      otherUserName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        conversation['message_text'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    trailing: Text(
                      formatMessageTime(conversation['created_at']),
                      style: const TextStyle(
                        fontSize: 14, // Increase trailing text size
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            userId: otherUserId,
                            userName: otherUserName,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
