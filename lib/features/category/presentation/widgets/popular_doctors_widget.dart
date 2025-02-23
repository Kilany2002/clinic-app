import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';
import 'package:clinicc/features/category/data/model/doctor_category_list.dart';
import 'package:flutter/material.dart';

class PopularDoctorCard extends StatelessWidget {
  final Doctor doctor;
  PopularDoctorCard(this.doctor);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: AppColors.color1,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Image.network(doctor.imageUrl,
                  width: 94, height: 113, fit: BoxFit.cover)),
          SizedBox(height: 5),
          Text(doctor.name,
              style: getbodyStyle(
                fontSize: 12,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              )),
          Text("${doctor.experience} Years Experience",
              style: getSmallStyle(
                fontSize: 10,
                color: AppColors.white,
              )),
          Row(
            children: [
              Icon(Icons.star, color: Colors.yellow, size: 13),
              Text(" ${doctor.rating}",
                  style: getSmallStyle(
                    fontSize: 13,
                    color: AppColors.white,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
