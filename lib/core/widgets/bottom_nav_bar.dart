import 'package:clinicc/book_view.dart';
import 'package:clinicc/features/category/presentation/views/category_view.dart';
import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/features/home/presentation/views/home_view.dart';
import 'package:clinicc/profile_view.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index = 0;
  List<Widget> pages = [HomeView(), CategoryView(), BookView(), ProfileView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[index],
        bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: false,
            showSelectedLabels: false,
            selectedItemColor: AppColors.color1,
            unselectedItemColor: AppColors.color1,
            backgroundColor: AppColors.color1,
            currentIndex: index,
            onTap: (value) => setState(() => index = value),
            items: [
              BottomNavigationBarItem(
                backgroundColor: AppColors.color1,
                icon: Image.asset(
                  'assets/icons/home.png',
                ),
                activeIcon: Image.asset(
                  'assets/icons/home.png',
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  backgroundColor: AppColors.color1,
                  activeIcon: Image.asset(
                    'assets/icons/category.png',
                  ),
                  icon: Image.asset(
                    'assets/icons/category.png',
                  ),
                  label: 'Car'),
              BottomNavigationBarItem(
                  backgroundColor: AppColors.color1,
                  activeIcon: Image.asset(
                    'assets/icons/book.png',
                  ),
                  icon: Image.asset(
                    'assets/icons/book.png',
                  ),
                  label: 'Profile'),
              BottomNavigationBarItem(
                  backgroundColor: AppColors.color1,
                  activeIcon: Image.asset(
                    'assets/icons/profile.png',
                  ),
                  icon: Image.asset(
                    'assets/icons/profile.png',
                  ),
                  label: 'Profile'),
            ]));
  }
}
