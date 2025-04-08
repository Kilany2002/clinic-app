import 'package:flutter/material.dart';

import '../../../core/utils/colors.dart';

// Update in menu_item.dart
Widget buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.color1,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: Colors.white54, size: 16),
        onTap: onTap, 
      ),
    ),
  );
}
