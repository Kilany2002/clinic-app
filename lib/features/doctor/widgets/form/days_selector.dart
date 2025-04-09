import 'package:flutter/material.dart';
import '../../../../core/utils/colors.dart';
import '../../logic/doctor_form_controller.dart';

class DaysSelector extends StatelessWidget {
  const DaysSelector({
    super.key,
    required this.controller,
    required this.destinationIndex,
    required this.destination,
  });

  final DoctorFormController controller;
  final int destinationIndex;
  final Map<String, dynamic> destination;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        'Saturday',
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday'
      ].map((day) {
        bool isSelected = destination['days'].contains(day);
        return FilterChip(
          selectedColor: AppColors.orange,
          label: Text(day),
          selected: isSelected,
          onSelected: (_) =>
              controller.toggleDaySelection(destinationIndex, day),
        );
      }).toList(),
    );
  }
}
