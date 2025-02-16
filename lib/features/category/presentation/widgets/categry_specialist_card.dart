import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';
import 'package:flutter/material.dart';

class CategrySpecialistCard extends StatelessWidget {
  final String imageUrl;
  final String titleCat;

  const CategrySpecialistCard({
    super.key,
    required this.imageUrl,
    required this.titleCat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward_ios,
                      color: Colors.white, size: 30)),
            ],
          ),
        ],
      ),
    );
  }
}
