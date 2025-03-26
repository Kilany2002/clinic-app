import 'package:flutter/material.dart';
import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';
class AddPatient extends StatelessWidget {
  const AddPatient({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.color1,
            radius: 25,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(title, style: getSubTitleStyle()),
        ],
      ),
    );
  }
}