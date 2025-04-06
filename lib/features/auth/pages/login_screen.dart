import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/constants/functions/show_snack_bar.dart';
import 'package:clinicc/features/auth/pages/forget_password.dart';
import 'package:clinicc/features/auth/pages/register_screen.dart';
import 'package:clinicc/features/auth/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:clinicc/generated/l10n.dart';

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
          child: Text(S.of(context).roleNotProvided),
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
                    S.of(context).signInAs(role),
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
                                  return S.of(context).pleaseEnterEmail;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.email, color: AppColors.color1),
                                hintText: S.of(context).emailHint,
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
                                  return S.of(context).pleaseEnterPassword;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.lock, color: AppColors.color1),
                                hintText: S.of(context).passwordHint,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: CustomButton(
                                text: S.of(context).login,
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    setState(() => isLoading = true);
                                    await loginUser();
                                    setState(() => isLoading = false);
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgetPasswordScreen()),
                                );
                              },
                              child: Text(
                                S.of(context).forgotPassword,
                                style: TextStyle(
                                    color: AppColors.color1, fontSize: 16),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).dontHaveAccount,
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
                                    S.of(context).signUp,
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
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email!,
        password: password!,
      );

      final user = response.user;
      if (user == null) throw Exception('User not found');

      final userResponse = await Supabase.instance.client
          .from('users')
          .select('role')
          .eq('id', user.id)
          .single();

      final userRole = userResponse['role'];

      if (userRole == 'doctor') {
        final doctorProfile = await Supabase.instance.client
            .from('doctors')
            .select('id')
            .eq('user_id', user.id)
            .maybeSingle();

        if (doctorProfile == null) {
          Navigator.pushNamed(context, 'DoctorFormScreen');
        } else {
          Navigator.pushNamed(context, 'NavBarScreen');
        }
      } else if (userRole == 'patient') {
        Navigator.pushNamed(context, 'BottomNavBar');
      } else {
        showSnackBar(context, S.of(context).invalidRole);
      }
    } catch (e) {
      showSnackBar(context, S.of(context).loginFailed);
    }
  }
}
