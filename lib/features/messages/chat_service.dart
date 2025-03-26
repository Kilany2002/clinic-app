import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchMessages(String otherUserId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    final response = await _supabase
        .from('messages')
        .select()
        .or('sender_id.eq.${user.id},receiver_id.eq.${user.id}')
        .or('sender_id.eq.$otherUserId,receiver_id.eq.$otherUserId')
        .order('created_at', ascending: true);

    return response;
  }

  Future<void> sendMessage(String receiverId, String messageText) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.from('messages').insert({
      'sender_id': user.id,
      'receiver_id': receiverId,
      'message_text': messageText,
    });
  }

  StreamSubscription<List<Map<String, dynamic>>> subscribeToMessages(
    String otherUserId,
    Function(List<Map<String, dynamic>>) onNewMessage,
  ) {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    // Use the query builder to filter messages
    final stream = _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('sender_id', user.id) // Filter by sender_id
        .eq('receiver_id', otherUserId); // Filter by receiver_id

    if (stream == null) {
      throw Exception('Failed to create stream. Ensure Realtime is enabled for the messages table.');
    }

    return stream.listen(onNewMessage);
  }
}

extension on SupabaseStreamBuilder {
  eq(String s, String otherUserId) {}
}