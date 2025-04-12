import 'package:clinicc/core/widgets/custom_app_bar.dart';
import 'package:clinicc/features/home/presentation/views/profile/screens/setting_screen/widgets/change_password.dart';
import 'package:clinicc/features/home/presentation/views/profile/screens/setting_screen/widgets/delete_account.dart';
import 'package:clinicc/features/home/presentation/views/profile/screens/setting_screen/widgets/rating.dart';
import 'package:clinicc/features/home/presentation/views/profile/screens/setting_screen/widgets/setting_item.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool showRatingDialog = false;
  bool showPasswordCard = false;

  void toggleDialog() {
    setState(() {
      showRatingDialog = !showRatingDialog;
    });
  }

  void showDelete() {
    showDialog(
      context: context,
      builder: (context) => DeleteAccount(
        onDeleteConfirmed: deleteAccount,
      ),
    );
  }

  void deleteAccount() {
    print("Account deleted");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deleted successfully')),
    );
  }

  void togglePasswordCard() {
    setState(() => showPasswordCard = !showPasswordCard);
  }

  void handlePasswordChange(String current, String newPass) {
    print('Current: $current');
    print('New: $newPass');
    togglePasswordCard();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password changed successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: "Settings",
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {},
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Account settings",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                  ),
                ),
                const SizedBox(height: 24),
                SettingItem(
                  icon: Icons.language,
                  iconBgColor: const Color(0xFFB0D3F2),
                  title: "Change Language",
                  subtitle: "Arabic, English",
                  onTap: () {
                    // TODO: Navigate to change language
                  },
                ),
                SettingItem(
                  icon: Icons.lock,
                  iconBgColor: const Color(0xFFD5C4FB),
                  title: "Change Password",
                  subtitle: "Change your current password",
                  onTap: togglePasswordCard,
                ),
                SettingItem(
                  icon: Icons.star_rate,
                  iconBgColor: const Color(0xFF8BE3B4),
                  title: "Rate Our App",
                  subtitle: "Rate & review us",
                  onTap: toggleDialog,
                ),
                SettingItem(
                  icon: Icons.delete,
                  iconBgColor: const Color(0xFF8BE3B4),
                  title: "Delete Account",
                  subtitle: "delete account",
                  onTap: showDelete,
                ),
              ],
            ),
          ),
        ),
        if (showRatingDialog)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Rating(onSubmit: toggleDialog),
          ),
        if (showPasswordCard)
          ChangePassword(
            onCancel: togglePasswordCard,
            onConfirm: handlePasswordChange,
          ),
      ],
    );
  }
}
