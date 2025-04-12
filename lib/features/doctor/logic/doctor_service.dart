import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> fetchCurrentDoctorData() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      return await _supabase
          .from('doctors')
          .select('name, destinations')
          .eq('user_id', user.id)
          .maybeSingle();
    } catch (error) {
      debugPrint('❌ Error fetching current doctor data: $error');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllDoctors() async {
    try {
      final response = await _supabase.from('doctors').select(
          'id, user_id, name, experience, description, price, image_url');

      return response.map((doctor) {
        return {
          "id": doctor["id"],
          "user_id": doctor["user_id"],
          "name": doctor["name"] ?? "Unknown",
          "experience": int.tryParse(doctor["experience"].toString()) ?? 0,
          "description": doctor["description"] ?? "",
          "price": double.tryParse(doctor["price"].toString()) ?? 0.0,
          "image_url": doctor["image_url"],
        };
      }).toList();
    } catch (error) {
      debugPrint("❌ Error fetching doctors list: $error");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchPatientsForDate(DateTime date) async {
    try {
      final response = await _supabase
          .from('patients')
          .select('name, order_number, visit_type, age')
          .eq('date', date.toIso8601String());

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('❌ Error fetching patients for date: $error');
      return [];
    }
  }
}
