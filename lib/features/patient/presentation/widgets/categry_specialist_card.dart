import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';
import 'package:clinicc/features/patient/presentation/widgets/category_doctors_view.dart';
import 'package:flutter/material.dart';

import '../../../../core/functions/routing.dart';

class CategrySpecialistCard extends StatelessWidget {
  final String imageUrl;
  final String titleCat;
  final int categoryId;

  const CategrySpecialistCard({
    super.key,
    required this.imageUrl,
    required this.titleCat,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pushReplacement(context, DoctorsCategoryView(categoryId: categoryId));
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 180,
        height: 180,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.color1,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 166,
                  height: 125,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      imageUrl,
                      width: 166,
                      height: 111,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(" $titleCat",
                  style: getTitleStyle(color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
