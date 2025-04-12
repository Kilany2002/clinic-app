import 'package:clinicc/core/functions/local_storage.dart';
import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/features/notifications/messaging_config.dart';
import 'package:clinicc/features/patient/presentation/views/bottom_nav_bar.dart';
import 'package:clinicc/firebase_options.dart';
import 'package:clinicc/features/doctor/screens/doctor_form_view.dart';
import 'package:clinicc/pages/login_screen.dart';
import 'package:clinicc/pages/register_screen.dart';
import 'package:clinicc/pages/role_screen.dart';
import 'package:clinicc/features/doctor/screens/doctor_nav_bar.dart';
import 'package:clinicc/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLocalStorage.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: 'https://sdkymhkkztylxhmnrbym.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNka3ltaGtrenR5bHhobW5yYnltIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA3NDI3NjYsImV4cCI6MjA1NjMxODc2Nn0.6aEWg5JO4pyBKBDtbE5E6phfKbTyBrLZaZvy3Xjha4c',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,

      title: 'Clinic',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales, // تحديد اللغات المدعومة
      routes: {
        '/': (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        BottomNavBar.id: (context) => BottomNavBar(),
        RoleSelectionScreen.id: (context) => RoleSelectionScreen(),
        DoctorFormScreen.id: (context) => DoctorFormScreen(),
        NavBarScreen.id: (context) => NavBarScreen(),
      },
      initialRoute: '/',
    );
  }
}
