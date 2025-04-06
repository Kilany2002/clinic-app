import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    try {
      final response = await supabase.from('doctors').select(
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
      debugPrint("❌ Error fetching doctors: $error");
      return [];
    }
  }
}
