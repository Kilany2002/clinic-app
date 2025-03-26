import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import '../../../../../core/functions/routing.dart';

class SpecializationView extends StatelessWidget {
  final String categoryName;

  const SpecializationView({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          categoryName,
          style: getTitleStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.color1,
      ),
      body: const Padding(
        padding: EdgeInsets.all(10),
      ),
    );
  }
}
