import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/widgets/bottom_nav_bar.dart';
import 'package:clinicc/firebase_options.dart';
import 'package:clinicc/pages/chat_screen.dart';
import 'package:clinicc/pages/doctor_form_view.dart';
import 'package:clinicc/pages/login_screen.dart';
import 'package:clinicc/pages/register_screen.dart';
import 'package:clinicc/pages/role_screen.dart';
import 'package:clinicc/features/doctor/screens/doctor_nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    await Supabase.initialize(
      url: 'https://sdkymhkkztylxhmnrbym.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNka3ltaGtrenR5bHhobW5yYnltIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA3NDI3NjYsImV4cCI6MjA1NjMxODc2Nn0.6aEWg5JO4pyBKBDtbE5E6phfKbTyBrLZaZvy3Xjha4c',
    );
    print('Supabase initialized successfully');
  } catch (e) {
    print('Error initializing Supabase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clinic',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        BottomNavBar.id: (context) => BottomNavBar(),
        RoleSelectionScreen.id: (context) => RoleSelectionScreen(),
        DoctorFormScreen.id: (context) => DoctorFormScreen(),
        NavBarScreen.id: (context) => NavBarScreen(),
      },
      initialRoute: 'DoctorFormScreen',
    );
  }
}
