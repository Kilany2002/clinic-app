import 'package:clinicc/features/patient/data/model/doctor_category_list.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorService {
  final supabase = Supabase.instance.client;

  Future<List<Doctor>> fetchAllDoctors() async {
    try {
      final response = await supabase.from('doctors').select();

      return (response as List)
          .map((doctor) => Doctor.fromJson(doctor))
          .toList();
    } catch (error) {
      debugPrint("❌ Error fetching doctors: $error");
      return [];
    }
  }

  Future<List<Doctor>> fetchDoctorsByCategory(int categoryId) async {
    try {
      final response = await supabase
          .from('doctors')
          .select()
          .eq('category_id', categoryId)
          .eq('is_available', true);

      return (response as List)
          .map((doctor) => Doctor.fromJson(doctor))
          .toList();
    } catch (error) {
      debugPrint("❌ Error fetching doctors by category: $error");
      return [];
    }
  }

  Future<List<Doctor>> fetchPopularDoctors(int categoryId) async {
    try {
      final response = await supabase
          .from('doctors')
          .select()
          .eq('is_popular', true)
          .eq('is_available', true).eq('category_id', categoryId);

      return (response as List)
          .map((doctor) => Doctor.fromJson(doctor))
          .toList();
    } catch (error) {
      debugPrint("❌ Error fetching popular doctors: $error");
      return [];
    }
  }
}