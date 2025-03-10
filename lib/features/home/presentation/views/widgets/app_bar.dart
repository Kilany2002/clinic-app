import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';
import 'package:flutter/material.dart';

class AppBarr extends StatelessWidget {
  const AppBarr({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      title: Text(
        'Clinic',
        style: getTitleStyle(color: AppColors.color1, fontSize: 25),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.notifications_active,
            size: 30,
          ),
        )
      ],
    );
  }
}
