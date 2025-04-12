import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/features/patient/data/model/doctor_category_list.dart';
import 'package:flutter/material.dart';

class CategoryDoctorCardWidget extends StatelessWidget {
  final Doctor doctor;
  final bool isList;
  const CategoryDoctorCardWidget(this.doctor, {super.key, this.isList = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.color1,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          if (isList) ...[
            Image.network(doctor.imageUrl,
                errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.error,
                      size: 50,
                      color: Colors.white,
                    ),
                width: 125,
                height: 140,
                fit: BoxFit.cover),
            SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctor.name,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                Text("${doctor.experience} Years Experience",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                Text(doctor.specialty,
                    style: TextStyle(fontSize: 14, color: Colors.white70)),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 25),
                    Text(" ${doctor.rating}",
                        style: TextStyle(fontSize: 25, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          if (!isList)
            Image.network(doctor.imageUrl,
                errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.error,
                      size: 50,
                      color: Colors.white,
                    ),
                width: 100,
                height: 115,
                fit: BoxFit.cover),
        ],
      ),
    );
  }
}