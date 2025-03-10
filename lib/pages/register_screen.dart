import 'package:clinicc/core/constants/constant_data.dart';
import 'package:clinicc/helper/show_snack_bar.dart';
import 'package:clinicc/pages/login_screen.dart';
import 'package:clinicc/widgets/customButton.dart';
import 'package:clinicc/widgets/customCircle.dart';
import 'package:clinicc/widgets/customTextField.dart';
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
  bool isLoading = false;
  String? password;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? role; // Add a variable to store the role

  @override
  Widget build(BuildContext context) {
    // Safely retrieve the role argument
    role = ModalRoute.of(context)?.settings.arguments as String?;

    if (role == null) {
      // Handle the case where the role is not provided
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
                      'Sign Up as $role', // Display the role
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 0),
                      child: CustomTextField(
                        textType: TextInputType.emailAddress,
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
                        text: 'Sign Up',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            isLoading = true;
                            setState(() {});

                            try {
                              print('Starting registration process...');
                              await registerUser(role!);
                              Navigator.pushNamed(context, LoginScreen.id,
                                  arguments: role);
                            } on Exception catch (e) {
                              print('Error: $e');
                              showSnackBar(context, 'Registration failed: $e');
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
                          "Already have an account? ",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () => Navigator.pushNamed(
                              context, LoginScreen.id,
                              arguments: role),
                          child: Text(
                            "Sign In",
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

      // Save user role in Supabase table
      await Supabase.instance.client.from('users').insert({
        'id': response.user!.id,
        'email': email,
        'role': role,
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
