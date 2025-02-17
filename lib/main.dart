<<<<<<< HEAD
import 'package:clinicc/core/widgets/bottom_nav_bar.dart';
=======
import 'package:clinicc/core/constants/size_config.dart';
import 'package:clinicc/home.dart';
>>>>>>> 868f683495eee2c79b0778d19e061747cb4dd49c
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clinic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
<<<<<<< HEAD
      home: BottomNavBar(),
=======
      builder: (context, child) {
        SizeConfig.init(context); // ✅ التهيئة هنا داخل الـ builder
        return child!;
      },
      home: MyHomePage(),
>>>>>>> 868f683495eee2c79b0778d19e061747cb4dd49c
    );
  }
}
