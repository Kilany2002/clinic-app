import 'package:clinicc/core/functions/Language_service.dart';
import 'package:clinicc/core/widgets/custom_app_bar.dart';
import 'package:clinicc/features/home/presentation/views/profile/screens/setting_screen/widgets/change_password.dart';
import 'package:clinicc/features/home/presentation/views/profile/screens/setting_screen/widgets/delete_account.dart';
import 'package:clinicc/features/home/presentation/views/profile/screens/setting_screen/widgets/rating.dart';
import 'package:clinicc/features/home/presentation/views/profile/screens/setting_screen/widgets/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("English"),
            onTap: () async {
              await LanguageService.setLanguage('en');
              Navigator.pop(context);
              _showRestartDialog();
            },
          ),
          ListTile(
            title: const Text("Arabic"),
            onTap: () async {
              await LanguageService.setLanguage('ar');
              Navigator.pop(context);
              _showRestartDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showRestartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Restart Required"),
        content:
            const Text("Please restart the app to apply the language change."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> deleteAccount() async {
    try {
      final supabase = Supabase.instance.client;
      await supabase
          .from('users')
          .delete()
          .eq('id', supabase.auth.currentUser!.id);
      await supabase.auth.signOut();

      if (!mounted) return;

      Navigator.of(context)
          .pushNamedAndRemoveUntil('RoleSelectionScreen', (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting account: $e')),
      );
    }
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
                  onTap: () => _showLanguagePicker(context),
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
