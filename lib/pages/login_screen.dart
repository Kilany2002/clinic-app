import 'package:clinicc/core/constants/constant_data.dart';
import 'package:clinicc/core/functions/routing.dart';
import 'package:clinicc/helper/show_snack_bar.dart';
import 'package:clinicc/pages/register_screen.dart';
import 'package:clinicc/widgets/customButton.dart';
import 'package:clinicc/widgets/customCircle.dart';
import 'package:clinicc/widgets/customTextField.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _checkUserSession();
    _listenToAuthChanges();
  }

  void _checkUserSession() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      debugPrint("User is already logged in: ${user.id}");

      setState(() => isLoading = true);

      final userResponse = await Supabase.instance.client
          .from('users')
          .select('role')
          .eq('id', user.id)
          .single();

      final userRole = userResponse['role'];
      debugPrint("User role: $userRole");

      if (userRole == 'doctor') {
        pushReplacementNamed(context, 'NavBarScreen');
      } else if (userRole == 'patient') {
        pushReplacementNamed(context, 'BottomNavBar');
      } else {
        debugPrint("Invalid role detected.");
      }

      setState(() => isLoading = false); // إيقاف الـ loading بعد التوجيه
    } else {
      debugPrint("No user session found, showing login screen.");
    }
  }

  void _listenToAuthChanges() {
    Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        debugPrint("User session updated: ${user.id}");
      } else {
        debugPrint("User logged out or session expired.");
        pushReplacementNamed(context, 'LoginScreen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? role = ModalRoute.of(context)?.settings.arguments as String?;
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomCircle(),
                    Text(
                      'Login as $role',
                      textAlign: TextAlign.center,
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
                    SizedBox(height: 15),
                    CustomButton(
                      text: 'Login',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() => isLoading = true);
                          await loginUser();
                          setState(() => isLoading = false);
                        }
                      },
                    ),
                    SizedBox(height: 5),
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
                          onTap: () => pushNamed(
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
