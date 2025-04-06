import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/constants/functions/show_snack_bar.dart';
import 'package:clinicc/features/auth/pages/login_screen.dart';
import 'package:clinicc/generated/l10n.dart';
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
                    S.of(context).registerAs(role!),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.asset('assets/images/sgin_up.jpg', width: 100),
                            const SizedBox(height: 20),
                            TextFormField(
                              onChanged: (data) => name = data,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).pleaseEnterName;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person, color: AppColors.color1),
                                hintText: S.of(context).nameHint,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              onChanged: (data) => phoneNumber = data,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).pleaseEnterPhone;
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone, color: AppColors.color1),
                                hintText: S.of(context).phoneHint,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              onChanged: (data) => email = data,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).pleaseEnterEmail;
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email, color: AppColors.color1),
                                hintText: S.of(context).emailHint,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
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
                                prefixIcon: Icon(Icons.lock, color: AppColors.color1),
                                hintText: S.of(context).passwordHint,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    setState(() => isLoading = true);

                                    try {
                                      await registerUser(role!);
                                      Navigator.pushNamed(
                                        context,
                                        LoginScreen.id,
                                        arguments: role,
                                      );
                                    } on Exception catch (e) {
                                      showSnackBar(context, '${S.of(context).userRegistrationFailed} $e');
                                    }

                                    setState(() => isLoading = false);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.color1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  S.of(context).signUp,
                                  style: const TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).alreadyHaveAccount,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    LoginScreen.id,
                                    arguments: role,
                                  ),
                                  child: Text(
                                    S.of(context).signIn,
                                    style: TextStyle(
                                      color: AppColors.color1,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
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
      final response = await Supabase.instance.client.auth.signUp(
        email: email!,
        password: password!,
      );

      if (response.user == null) {
        showSnackBar(context, S.of(context).userRegistrationFailed);
        return;
      }

      await Supabase.instance.client.from('users').insert({
        'id': response.user!.id,
        'email': email,
        'role': role,
        'name': name,
        'created_at': DateTime.now().toIso8601String(),
      });

      showSnackBar(context, S.of(context).userRegistrationSuccess);
    } on Exception catch (e) {
      showSnackBar(context, '${S.of(context).userRegistrationFailed} $e');
    }
  }
}
