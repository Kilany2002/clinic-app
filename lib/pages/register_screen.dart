import 'package:clinicc/core/constants/functions/show_snack_bar.dart';
import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/pages/login_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});
  static String id = 'RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? email;
  String? password;
  String? name;
  String? phoneNumber;
  String? role;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    role = ModalRoute.of(context)?.settings.arguments as String?;
    if (role == null) {
      return Scaffold(
        body: Center(
          child: Text('Role not provided. Please go back and select a role.'),
        ),
      );
    }

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: AppColors.color1, 
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Let's Start with\nSign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/sgin_up.jpg', width: 100), 
                            SizedBox(height: 20),
                            TextFormField(
                              onChanged: (data) => name = data,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person, color: AppColors.color1),
                                hintText: "Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              onChanged: (data) => phoneNumber = data,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone, color: AppColors.color1),
                                hintText: "Phone Number",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              onChanged: (data) => email = data,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email, color: AppColors.color1),
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              obscureText: true,
                              onChanged: (data) => password = data,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock, color: AppColors.color1),
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    isLoading = true;
                                    setState(() {});

                                    try {
                                      await registerUser(role!);
                                      Navigator.pushNamed(context, LoginScreen.id, arguments: role);
                                    } on Exception catch (e) {
                                      showSnackBar(context, 'Registration failed: $e');
                                    }

                                    isLoading = false;
                                    setState(() {});
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.color1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text("Sign Up",
                                    style: TextStyle(fontSize: 18, color: Colors.white)),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                InkWell(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    LoginScreen.id,
                                    arguments: role,
                                  ),
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                        color: AppColors.color1,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> registerUser(String role) async {
  try {
    print('Attempting to register user with email: $email and role: $role');
    final response = await Supabase.instance.client.auth.signUp(
      email: email!,
      password: password!,
    );

    if (response.user == null) {
      print('Registration failed: User is null');
      showSnackBar(context, "User registration failed.");
      return;
    }

    print('User registered successfully: ${response.user!.id}');

    // 🔔 Get the FCM token
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print('FCM Token: $fcmToken');

    // Save user info including FCM token in Supabase table
    await Supabase.instance.client.from('users').insert({
      'id': response.user!.id,
      'email': email,
      'role': role,
      'name': name,
      'fcm_token': fcmToken,
      'created_at': DateTime.now().toIso8601String(),
    });

    print('User data saved to Supabase');
    showSnackBar(context, "User registered successfully!");
  } on Exception catch (e) {
    print('Error during registration: $e');
    showSnackBar(context, 'Registration failed: $e');
  }
}
}
