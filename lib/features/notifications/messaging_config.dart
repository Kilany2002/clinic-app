import 'dart:developer';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MessagingConfig {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('custom_sound'),
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> initFirebaseMessaging() async {
    await createNotificationChannel();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Set foreground presentation options for iOS
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log("Notification clicked: ${response.payload}");
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          if (data is Map<String, dynamic>) {
            _handleNotificationAction(data);
          }
        }
      },
    );

    // Handle permission status
    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        log('User granted full notification permission');
        break;
      case AuthorizationStatus.provisional:
        log('User granted provisional notification permission');
        break;
      case AuthorizationStatus.denied:
        log('User denied notification permission');
        break;
      case AuthorizationStatus.notDetermined:
        log('User hasn\'t decided on notification permission');
        break;
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("Foreground message received: ${message.messageId}");
      await _showForegroundNotification(message);
      _showInAppNotification(message);
    });

    // Handle when app is opened from terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        log('App opened from terminated state with notification');
        _handleNotificationAction(message.data);
      }
    });

    // Handle when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('App opened from background with notification');
      _handleNotificationAction(message.data);
    });
  }

  static Future<void> _showForegroundNotification(RemoteMessage message) async {
    try {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null) {
        await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription:
                  'This channel is used for important notifications.',
              icon: android?.smallIcon ?? '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              sound: const RawResourceAndroidNotificationSound('custom_sound'),
              color: Colors.blue,
              styleInformation:
                  BigTextStyleInformation(notification.body ?? ''),
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              badgeNumber: 1,
              threadIdentifier: 'high_importance_channel',
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    } catch (err) {
      log('Error showing foreground notification: $err');
    }
  }

  static void _showInAppNotification(RemoteMessage message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(message.notification?.title ?? 'New Notification'),
        content: Text(message.notification?.body ?? 'You have a new message'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleNotificationAction(message.data);
            },
            child: const Text('View'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  static void _handleNotificationAction(Map<String, dynamic> data) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    log('Handling notification action with data: $data');

    if (data.containsKey('type')) {
      switch (data['type']) {
        case 'new_booking':
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("New booking from ${data['patient_name']}"),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pushNamed('/doctor-appointments');
          break;
        case 'booking_confirmation':
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Confirmed with Dr. ${data['doctor_name']}"),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pushNamed('/my-appointments');
          break;
        default:
          log('Unknown notification type: ${data['type']}');
      }
    }
  }

  @pragma('vm:entry-point')
  static Future<void> messageHandler(RemoteMessage message) async {
    log('Background message received: ${message.notification?.body}');
    log('Message data: ${message.data}');

    // Handle background notification
    await _showBackgroundNotification(message);
  }

  static Future<void> _showBackgroundNotification(RemoteMessage message) async {
    try {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription:
                  'This channel is used for important notifications.',
              icon: '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              sound: 'custom_sound.caf',
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    } catch (err) {
      log('Error showing background notification: $err');
    }
  }
}
