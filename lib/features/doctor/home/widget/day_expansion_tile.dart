import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';
import 'package:clinicc/features/doctor/home/widget/patient_card.dart';
import 'package:flutter/material.dart';

class DayExpansionTile extends StatelessWidget {
  final String day;
  final bool isExpanded;
  final VoidCallback toggleExpansion;
  final List<Map<String, dynamic>> patients;

  const DayExpansionTile({
    Key? key,
    required this.day,
    required this.isExpanded,
    required this.toggleExpansion,
    required this.patients,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: toggleExpansion,
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.color1,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(day, style: getTitleStyle(color: Colors.white)),
                Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white),
              ],
            ),
          ),
        ),
        if (isExpanded)
          ...patients.map((p) => PatientCard(patient: p)).toList(),
      ],
    );
  }
}

