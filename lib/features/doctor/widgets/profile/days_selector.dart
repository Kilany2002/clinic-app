import 'package:clinicc/core/utils/colors.dart';
import 'package:flutter/material.dart';

class DaysSelector extends StatelessWidget {
  final List<String> days;
  final Function(String) onDaySelected;

  const DaysSelector({
    super.key,
    required this.days,
    required this.onDaySelected,
  });

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
        bool isSelected = days.contains(day);
        return FilterChip(
          selectedColor: AppColors.orange,
          label: Text(day),
          selected: isSelected,
          onSelected: (_) => onDaySelected(day),
        );
      }).toList(),
    );
  }
}

