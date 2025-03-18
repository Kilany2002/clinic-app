import 'package:clinicc/features/category/presentation/views/category_view.dart';
import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/pages/chat_screen.dart';
import 'package:clinicc/pages/patient_home_view.dart';
import 'package:flutter/material.dart';

import '../../features/category/presentation/views/profile_view.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});
  static const String id = 'BottomNavBar';

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index = 0;
  List<Widget> pages = [
    PatientHomeView(),
    CategoryView(),
    ChatScreen(),
    ProfileView()
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
                  icon: Icon(Icons.category),
                  label: 'Category'),
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
