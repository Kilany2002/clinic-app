import 'package:clinicc/core/constants/constant_data.dart';
import 'package:clinicc/helper/show_snack_bar.dart';
import 'package:clinicc/pages/register_screen.dart';
import 'package:clinicc/widgets/customButton.dart';
import 'package:clinicc/widgets/customCircle.dart';
import 'package:clinicc/widgets/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
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
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomCircle(),
                    Text(
                      textAlign: TextAlign.center,
                      'Login as $role',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 0),
                      child: CustomTextField(
                        onChanged: (data) {
                          email = data;
                        },
                        hint: 'Email',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: CustomTextField(
                        onChanged: (data) {
                          password = data;
                        },
                        hint: 'Password',
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                        text: 'Login',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            isLoading = true;
                            setState(() {});

                            try {
                              print('Starting login process...');
                              await loginUser();
                              final user =
                                  Supabase.instance.client.auth.currentUser;
                              print('User logged in: ${user!.email}');
                              final response = await Supabase.instance.client
                                  .from('users')
                                  .select('role, email')
                                  .eq('id', user.id)
                                  .single();

                              final userRole = response['role'];
                              final userEmail = response['email'];
                              print('User role: $userRole');
                              print('User email: $userEmail');
                              if (userRole == 'doctor' && userEmail == email) {
                                print('Navigating to NavBarScreen');
                                Navigator.pushNamed(context, 'NavBarScreen');
                              } else if (userRole == 'patient') {
                                print('Navigating to Patient Home');
                                Navigator.pushNamed(context, 'BottomNavBar');
                              } else {
                                print('Invalid role or email');
                                showSnackBar(context, 'Invalid role or email');
                              }
                            } on Exception catch (e) {
                              print('Error: $e');
                              showSnackBar(
                                  context, 'Invalid email or password');
                            }

                            isLoading = false;
                            setState(() {});
                          }
                        }),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 20,
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
                                color: Colors.blue,
                                fontSize: 20,
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
    );
  }

  Future<void> loginUser() async {
    try {
      print('Attempting to log in with email: $email');
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email!,
        password: password!,
      );

      if (response.user == null) {
        print('Login failed: User not found');
        throw Exception('User not found');
      }

      print('Login successful: User ID = ${response.user!.id}');
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }
}
