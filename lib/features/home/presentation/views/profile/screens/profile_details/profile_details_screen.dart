import 'package:clinicc/core/widgets/custom_app_bar.dart';
import 'package:clinicc/features/home/presentation/views/profile/screens/profile_details/widgets/set_value.dart';
import 'package:clinicc/features/home/presentation/views/profile/screens/profile_details/widgets/user_profile.dart';
import 'package:flutter/material.dart';
import 'edit_details/edit_profile_details.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  _ProfileDetailsScreenState createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  UserProfile user = UserProfile(
    name: "Ammar Ahmed",
    phone: "01078654434",
    email: "ammar21@gmail.com",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: 'Profile Details',
        actions: [
          TextButton(
            onPressed: () async {
              final updatedUser = await Navigator.push<UserProfile>(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: user),
                ),
              );
              if (updatedUser != null) {
                setState(() {
                  user = updatedUser;
                });
              }
            },
            child: const Text(
              'Edit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFF3A72B9),
            child: Icon(Icons.person, size: 80, color: Colors.white),
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                setValue('Full Name', user.name),
                setValue('Phone number', user.phone),
                setValue('Email', user.email),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
