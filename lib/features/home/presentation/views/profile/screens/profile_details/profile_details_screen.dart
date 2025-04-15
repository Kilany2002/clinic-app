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
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        throw Exception("No user logged in");
      }

      final response = await Supabase.instance.client
          .from('users')
          .select('name, phone_number, email')
          .eq('id', currentUser.id)
          .maybeSingle();

      if (response == null) {
        throw Exception("User data not found");
      }

      setState(() {
        user = UserProfile(
          name: response['name']?.toString() ?? "Not provided",
          phone: response['phone_number']?.toString() ?? "Not provided",
          email: response['email']?.toString() ?? "Not provided",
        );
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _fetchUserData();
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
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () async {
                final updatedUser = await Navigator.push<UserProfile>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(user: user!),
                  ),
                );
                if (updatedUser != null) {
                  setState(() => user = updatedUser);
                }
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _buildBodyContent(),
      ),
    );
  }

  Widget _buildBodyContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchUserData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                setValue('Full Name', user?.name ?? "Not available"),
                const Divider(height: 24),
                setValue('Phone number', user?.phone ?? "Not available"),
                const Divider(height: 24),
                setValue('Email', user?.email ?? "Not available"),
                const Divider(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
