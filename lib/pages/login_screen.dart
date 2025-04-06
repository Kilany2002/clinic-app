import 'package:clinicc/core/constants/functions/show_snack_bar.dart';
import 'package:clinicc/core/functions/routing.dart';
import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/features/auth/widgets/customButton.dart';
import 'package:clinicc/pages/register_screen.dart';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final String? role = ModalRoute.of(context)?.settings.arguments as String?;
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
                    "Let's Start with\nSign in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/login.png', width: 100),
                            SizedBox(height: 20),
                            TextFormField(
                              onChanged: (data) => email = data,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.email, color: AppColors.color1),
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
                                prefixIcon:
                                    Icon(Icons.lock, color: AppColors.color1),
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
                                  await loginUser();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.color1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text("Sign in",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white)),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(
                                    color: AppColors.color1, fontSize: 16),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                InkWell(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    RegisterScreen.id,
                                    arguments: role,
                                  ),
                                  child: Text(
                                    "Sign Up",
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

  Future<void> loginUser() async {
    try {
      debugPrint('Attempting to log in with email: $email');
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email!,
        password: password!,
      );

      final user = response.user;
      if (user == null) {
        debugPrint('Login failed: User not found');
        throw Exception('User not found');
      }

      debugPrint('Login successful: User ID = ${user.id}');

      final userResponse = await Supabase.instance.client
          .from('users')
          .select('role')
          .eq('id', user.id)
          .single();

      final userRole = userResponse['role'];
      debugPrint('User role: $userRole');

      if (userRole == 'doctor') {
        final doctorProfile = await Supabase.instance.client
            .from('doctors')
            .select('id')
            .eq('user_id', user.id)
            .maybeSingle();

        if (doctorProfile == null) {
          debugPrint('New doctor detected. Redirecting to DoctorFormScreen');
          pushNamed(context, 'DoctorFormScreen');
        } else {
          debugPrint('Existing doctor detected. Redirecting to NavBarScreen');
          pushNamed(context, 'NavBarScreen');
        }
      } else if (userRole == 'patient') {
        debugPrint('Redirecting to Patient Home');
        pushNamed(context, 'BottomNavBar');
      } else {
        debugPrint('Invalid role');
        showSnackBar(context, 'Invalid role');
      }
    } catch (e) {
      debugPrint('Error during login: $e');
      showSnackBar(context, 'Invalid email or password');
    }
  }
}
