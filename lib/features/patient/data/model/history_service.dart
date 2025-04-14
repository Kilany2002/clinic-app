import 'package:clinicc/core/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> getBookingHistory() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    try {
      final response = await _supabase
          .from('history')
          .select('''
            id,
            doctor_id,
            doctor_name,
            doctor_image_url,
            date,
            created_at
          ''')
          .eq('user_id', user.id)
          .order('date', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      ErrorHandler.logError("Failed to fetch booking history: $e");
      return [];
    }
  }

  /// Get a specific history item by ID
  static Future<Map<String, dynamic>?> getHistoryById(String historyId) async {
    try {
      final response = await _supabase
          .from('history')
          .select()
          .eq('id', historyId)
          .single();

      return response as Map<String, dynamic>?;
    } catch (e) {
      ErrorHandler.logError("Failed to fetch history item: $e");
      return null;
    }
  }

  static Future<bool> addHistoryRecord({
    required String doctorId,
    required String doctorName,
    required String doctorImageUrl,
    required DateTime date,
    required BuildContext context,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      ErrorHandler.showError(context, "User not authenticated");
      return false;
    }

    try {
      await _supabase.from('history').insert({
        'doctor_id': doctorId,
        'doctor_name': doctorName,
        'doctor_image_url': doctorImageUrl,
        'date': date.toIso8601String(),
        'user_id': user.id,
      });
      return true;
    } catch (e) {
      ErrorHandler.showError(context, "Failed to add to history: $e");
      return false;
    }
  }

  /// Delete a history record
  static Future<bool> deleteHistoryRecord(String historyId, BuildContext context) async {
    try {
      await _supabase.from('history').delete().eq('id', historyId);
      return true;
    } catch (e) {
      ErrorHandler.showError(context, "Failed to delete history record: $e");
      return false;
    }
  }
}