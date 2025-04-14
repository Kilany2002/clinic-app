import 'package:clinicc/core/widgets/custom_app_bar.dart';
import 'package:clinicc/features/home/presentation/views/profile/screens/profile_details/widgets/set_value.dart';
import 'package:clinicc/features/home/presentation/views/profile/screens/profile_details/widgets/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_details/edit_profile_details.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  _ProfileDetailsScreenState createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  UserProfile? user;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        setState(() {
          errorMessage = "No user logged in";
          isLoading = false;
        });
        return;
      }

      final response = await Supabase.instance.client
          .from('users')
          .select('name, phone_number, email')
          .eq('id', currentUser.id)
          .maybeSingle();

      if (response == null) {
        setState(() {
          errorMessage = "User data not found";
          isLoading = false;
        });
        return;
      }

      setState(() {
        user = UserProfile(
          name: response['name'] ?? "Not provided",
          phone: response['phone_number'] ?? "Not provided",
          email: response['email'] ?? "Not provided",
        );
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load user data";
        isLoading = false;
      });
    }
  }

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
          if (user != null)
            TextButton(
              onPressed: () async {
                final updatedUser = await Navigator.push<UserProfile>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(user: user!),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          setValue('Full Name', user?.name ?? "Not available"),
                          setValue(
                              'Phone number', user?.phone ?? "Not available"),
                          setValue('Email', user?.email ?? "Not available"),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
