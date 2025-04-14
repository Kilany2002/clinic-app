import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PatientService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> fetchUserDetails() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      debugPrint("❌ No user logged in");
      return null;
    }

    try {
      final response = await supabase
          .from('users')
          .select('name, phone_number, email') 
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) {
        debugPrint("❌ No user data found");
        return null;
      }

      debugPrint("✅ User details fetched: $response");
      return {
        'name': response['name'] as String?,
        'phoneNumber': response['phone_number'] as String?,
        'email': response['email'] as String?,
      };
    } catch (e) {
      debugPrint("❌ Error fetching user details: $e");
      return null;
    }
  }

  // Keep the old method for backward compatibility
  Future<String?> fetchUserName() async {
    final details = await fetchUserDetails();
    return details?['name'];
  }
}
