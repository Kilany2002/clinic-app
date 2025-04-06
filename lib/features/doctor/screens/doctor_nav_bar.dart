import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/features/doctor/screens/doctor_home_view.dart';
import 'package:clinicc/features/doctor/screens/doctor_profile_view.dart';
import 'package:clinicc/features/messages/conversations_screen.dart';
import 'package:flutter/material.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});
  static const String id = 'NavBarScreen';

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int index = 0;
  
  List<Widget> pages = [
    DoctorHomeView(),
    ConversationsScreen(),
    DoctorProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[index],
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: AppColors.white,
            unselectedItemColor: AppColors.greyColor,
            backgroundColor: AppColors.color1,
            currentIndex: index,
            onTap: (value) => setState(() => index = value),
            items: [
              BottomNavigationBarItem(
                backgroundColor: AppColors.color1,
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  backgroundColor: AppColors.color1,
                  icon: Icon(Icons.chat),
                  label: 'Chat'),
              BottomNavigationBarItem(
                  backgroundColor: AppColors.color1,
                  icon: Icon(Icons.person),
                  label: 'Profile'),
            ]));
  }
}
