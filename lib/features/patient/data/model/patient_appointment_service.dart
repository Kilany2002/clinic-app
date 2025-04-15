import 'package:clinicc/core/utils/error_handler.dart';
import 'package:clinicc/features/notifications/push_notification_service.dart';
import 'package:clinicc/features/patient/data/model/doctor_category_list.dart';
import 'package:clinicc/features/patient/data/model/history_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PatientAppointmentService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<int> getLastOrderNumberForDate(
      DateTime date, String doctorId) async {
    final response = await _supabase
        .from('patients')
        .select('order_number')
        .eq('date', date.toIso8601String())
        .eq('doctor_id', doctorId)
        .order('order_number', ascending: false)
        .limit(1);

    if (response.isEmpty) {
      return 0;
    }
    return response[0]['order_number'] as int;
  }

  static Future<bool> addToHistory({
    required String doctorId,
    required String doctorName,
    required String doctorImageUrl,
    required DateTime date,
    required BuildContext context,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      ErrorHandler.showError(context, "Please login to book appointments");
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

  static Future<bool> bookAppointment({
    required String name,
    required int age,
    required String visitType,
    required DateTime date,
    required String doctorId,
    required bool isPaid,
    required BuildContext context,
    required Doctor doctor,
    required String? patientFCMToken, // Make nullable

    required String? doctorFCMToken,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      ErrorHandler.showError(context, "Please login to book appointments");
      return false;
    }

    try {
      // Book appointment (existing code)
      final lastOrderNumber = await getLastOrderNumberForDate(date, doctorId);
      final orderNumber = lastOrderNumber + 1;

      await _supabase.from('patients').insert({
        'name': name,
        'age': age,
        'order_number': orderNumber,
        'visit_type': visitType,
        'doctor_id': doctorId,
        'date': date.toIso8601String(),
        'isPaid': isPaid,
        'patient_user_id': user.id,
      });

      await HistoryService.addHistoryRecord(
        doctorId: doctor.id,
        doctorName: doctor.name,
        doctorImageUrl: doctor.imageUrl,
        date: date,
        context: context,
      );
      // Send notifications only if tokens exist
      if (patientFCMToken != null || doctorFCMToken != null) {
        await _sendBookingNotifications(
          patientName: name,
          doctor: doctor,
          date: date,
          patientFCMToken: patientFCMToken,
          doctorFCMToken: doctorFCMToken,
        );
      }

      ErrorHandler.showSuccess(context, "Appointment booked successfully!");
      return true;
    } catch (e) {
      ErrorHandler.showError(context, "Failed to book appointment: $e");
      return false;
    }
  }

  static Future<void> _sendBookingNotifications({
    required String patientName,
    required Doctor doctor,
    required DateTime date,
    required String? patientFCMToken,
    required String? doctorFCMToken,
  }) async {
    final formattedDate = "${date.day}/${date.month}/${date.year}";

    // Notification for doctor if token exists
    if (doctorFCMToken != null) {
      try {
        await sendNotification(
          token: doctorFCMToken,
          title: "New Appointment Booking",
          body: "$patientName booked an appointment on $formattedDate",
          data: {
            'screen': 'appointments',
            'type': 'new_booking',
            'patient_name': patientName,
            'date': formattedDate,
          },
        );
      } catch (e) {
        debugPrint("Failed to send doctor notification: $e");
      }
    }

    // Notification for patient if token exists
    if (patientFCMToken != null) {
      try {
        await sendNotification(
          token: patientFCMToken,
          title: "New Appointment Booking",
          body: "$patientName booked an appointment on $formattedDate",
          data: {
            'screen': 'appointments',
            'type': 'new_booking',
            'patient_name': patientName,
            'date': formattedDate,
          },
        );
      } catch (e) {
        debugPrint("Failed to send patient notification: $e");
      }
    }
  }

  static Future<List<Map<String, dynamic>>> getBookingHistory() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      return [];
    }

    final response = await _supabase
        .from('history')
        .select()
        .eq('user_id', user.id)
        .order('date', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
