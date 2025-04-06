import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PatientService {
  final supabase = Supabase.instance.client;

  Future<String?> fetchUserName() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      debugPrint("❌ No user logged in");
      return null;
    }

    final response = await Supabase.instance.client
        .from('users')
        .select('name')
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) {
      debugPrint("❌ No user data found");
      return null;
    }

    debugPrint("✅ User name fetched: ${response['name']}");
    return response['name'] as String?;
  }
}
