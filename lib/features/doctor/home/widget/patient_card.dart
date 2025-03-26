import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';
import 'package:flutter/material.dart';

class PatientCard extends StatelessWidget {
  final Map<String, dynamic> patient;

  PatientCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.color1,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            patient['name'],
            style: getTitleStyle(color: Colors.white),
          ),
          Text(patient['appointment_time'],
              style: getTitleStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
