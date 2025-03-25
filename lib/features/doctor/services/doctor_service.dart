import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> fetchDoctorData() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final response = await _supabase
        .from('doctors')
        .select('name, destinations')
        .eq('user_id', user.id)
        .maybeSingle();

    return response;
  }

  Future<List<Map<String, dynamic>>> fetchPatientsForDate(DateTime date) async {
    final response = await _supabase
        .from('patients')
        .select('name, order_number, visit_type, age')
        .eq('date', date.toIso8601String());

    return List<Map<String, dynamic>>.from(response);
  }
}
