import 'package:clinicc/core/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PatientService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<int> getLastOrderNumberForDate(DateTime date) async {
    final response = await _supabase
        .from('patients')
        .select('order_number')
        .eq('date', date.toIso8601String())
        .order('order_number', ascending: false)
        .limit(1);
    if (response.isEmpty) {
      return 0;
    }

    return response[0]['order_number'] as int;
  }

  static Future<bool> addPatient({
    required String name,
    required int age,
    required String visitType,
    required DateTime date,
    required BuildContext context,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      ErrorHandler.showError(context, "No authenticated user");
      return false;
    }

    try {
      final doctorResponse = await _supabase
          .from('doctors')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (doctorResponse == null) {
        ErrorHandler.showError(context,
            "Doctor profile not found. Please create a doctor profile first.");
        return false;
      }

      // Get the last order number for the selected date
      final lastOrderNumber = await getLastOrderNumberForDate(date);
      final orderNumber =
          lastOrderNumber + 1; // Increment by 1 (this is an int)

      // Debugging: Print the data being inserted
      print({
        'name': name,
        'age': age,
        'order_number': orderNumber,
        'visit_type': visitType,
        'doctor_id': doctorResponse['id'],
        'date': date.toIso8601String(),
      });

      // Insert the patient into the database
      final response = await _supabase.from('patients').insert({
        'name': name, // String
        'age': age, // int
        'order_number': orderNumber, // int
        'visit_type': visitType, // String
        'doctor_id': doctorResponse['id'], // UUID or String
        'date': date.toIso8601String(), // String (ISO 8601 format)
      });

      // Use null-aware operator to check for errors
      if (response?.error != null) {
        ErrorHandler.showError(context, "Error: ${response!.error!.message}");
        return false;
      }

      // Success
      ErrorHandler.showSuccess(context, "Patient added successfully");
      return true;
    } catch (e) {
      ErrorHandler.showError(context, "An error occurred: $e");
      return false;
    }
  }
}
