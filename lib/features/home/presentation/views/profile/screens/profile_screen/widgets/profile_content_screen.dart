import 'package:clinicc/core/widgets/custom_app_bar.dart';
import 'package:clinicc/features/home/presentation/views/profile/screens/profile_screen/widgets/profile_button.dart';
import 'package:clinicc/pages/role_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../../data/model/patient_service.dart';
import '../../history_screen/history_details.dart';
import '../../profile_details/profile_details_screen.dart';
import '../../setting_screen/setting_screen.dart';

class ProfileContentScreen extends StatefulWidget {
  const ProfileContentScreen({super.key});

  @override
  State<ProfileContentScreen> createState() => _ProfileContentScreenState();
}

class _ProfileContentScreenState extends State<ProfileContentScreen> {
  final PatientService _patientService = PatientService();
  String? name;
  String? email;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userDetails = await _patientService.fetchUserDetails();
    setState(() {
      name = userDetails?['name'] ?? 'User';
      email = userDetails?['email'] ?? '';
      isLoading = false;
    });
  }

  Future<void> logoutUser() async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to logout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF3A72B9),
                  child: Icon(Icons.person, size: 80, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  name ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF233B55),
                  ),
                ),
                Text(
                  email ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),

                // Navigation Buttons
                ProfileButton(
                  title: 'Profile Details',
                  icon: Icons.account_circle,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileDetailsScreen()),
                    );
                  },
                ),
                ProfileButton(
                  title: 'History',
                  icon: Icons.history,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HistoryDetailsScreen()),
                    );
                  },
                ),
                ProfileButton(
                  title: 'Settings',
                  icon: Icons.settings,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen()),
                    );
                  },
                ),
                ProfileButton(
                  title: 'Logout',
                  icon: Icons.exit_to_app,
                  onTap: logoutUser,
                ),
              ],
            ),
    );
  }
}
