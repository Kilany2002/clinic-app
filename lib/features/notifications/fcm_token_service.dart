// fcm_token_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMTokenService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<String?> getValidToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token == null) return null;
      
      // Basic validation (FCM tokens have specific format)
      if (token.length < 50 || !token.contains(':')) {
        return null;
      }
      return token;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  static bool isValidToken(String? token) {
    if (token == null) return false;
    return token.length >= 50 && token.contains(':');
  }
}