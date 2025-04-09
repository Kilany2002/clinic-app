import 'dart:async';
import 'dart:io';
import 'package:clinicc/features/notifications/push_notification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchMessages(String otherUserId,
      {int limit = 50, int offset = 0}) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    final response = await _supabase
        .from('messages')
        .select()
        .or('sender_id.eq.${user.id},receiver_id.eq.${user.id}')
        .or('sender_id.eq.$otherUserId,receiver_id.eq.$otherUserId')
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return response.reversed.toList();
  }

  Future<void> sendMessage(String receiverId, String messageText,
      {File? attachment}) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final Map<String, dynamic> messageData = {
      'sender_id': user.id,
      'receiver_id': receiverId,
      'message_text': messageText,
      'is_read': false,
    };

    if (attachment != null) {
      final fileExt = attachment.path.split('.').last;
      final fileName =
          '${user.id}-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = 'messages/$fileName';

      await _supabase.storage
          .from('message.attachments')
          .upload(filePath, attachment);

      final fileUrl =
          _supabase.storage.from('message.attachments').getPublicUrl(filePath);

      messageData['attachment_url'] = fileUrl;
      messageData['attachment_type'] = _getAttachmentType(fileExt);
    }

    await _supabase.from('messages').insert(messageData);

    // 🔔 Get receiver's FCM token and sender's name
    final receiverProfile = await _supabase
        .from('users')
        .select('fcm_token, name')
        .eq('id', receiverId)
        .single();

    final senderProfile =
        await _supabase.from('users').select('name').eq('id', user.id).single();

    final fcmToken = receiverProfile['fcm_token'];
    final receiverName = receiverProfile['name'];
    final senderName = senderProfile['name'];

    if (fcmToken != null && fcmToken.toString().isNotEmpty) {
      await sendNotification(
        token: fcmToken,
        title: 'Clinic App - $senderName',
        body: messageText,
        data: {
          'screen': 'chat',
          'senderId': user.id,
          'senderName': senderName,
        },
      );
    }
  }

  Future<void> markMessagesAsRead(List<String> messageIds) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase
        .from('messages')
        .update({'is_read': true})
        .inFilter('id', messageIds)
        .eq('receiver_id', user.id);
  }

  Future<void> sendTypingStatus(String receiverId, bool isTyping) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.from('typing_status').upsert({
      'user_id': user.id,
      'receiver_id': receiverId,
      'is_typing': isTyping,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Stream<Map<String, dynamic>?> subscribeToTypingStatus(String otherUserId) {
    return _supabase
        .from('typing_status')
        .stream(primaryKey: ['user_id', 'receiver_id'])
        .execute()
        .map((data) => data.isNotEmpty ? data.first : null);
  }

  Stream<List<Map<String, dynamic>>> subscribeToMessages(String otherUserId) {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    return _supabase.from('messages').stream(primaryKey: ['id']).execute();
  }

  String _getAttachmentType(String fileExt) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    final videoExtensions = ['mp4', 'mov', 'avi', 'mkv'];

    if (imageExtensions.contains(fileExt.toLowerCase())) return 'image';
    if (videoExtensions.contains(fileExt.toLowerCase())) return 'video';
    return 'file';
  }
}
