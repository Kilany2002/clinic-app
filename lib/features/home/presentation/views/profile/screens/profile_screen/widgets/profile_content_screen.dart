import 'package:clinicc/core/widgets/custom_app_bar.dart';
import 'package:clinicc/features/home/presentation/views/profile/screens/profile_screen/widgets/profile_button.dart';
import 'package:flutter/material.dart';

import '../../history_screen/history_details.dart';
import '../../profile_details/profile_details_screen.dart';
import '../../setting_screen/setting_screen.dart';

class ProfileContentScreen extends StatelessWidget {
  const ProfileContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Image
          SizedBox(height: 30),
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFF3A72B9),
            child: Icon(Icons.person, size: 80, color: Colors.white),
          ),
          SizedBox(height: 20),
          const Text(
            'Ammar Ahmed',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF233B55),
            ),
          ),
          const Text(
            'a@g.com',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 40),

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
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          ProfileButton(
            title: 'Logout',
            icon: Icons.exit_to_app,
            onTap: () {
              // TODO
            },
          ),
        ],
      ),
    );
  }
}
