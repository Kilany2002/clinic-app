import 'package:flutter/material.dart';

class DaysSelector extends StatelessWidget {
  final int index;
  final Map<String, dynamic> destination;

  const DaysSelector({super.key, required this.index, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
          .map((day) {
        bool isSelected = destination['days'].contains(day);
        return FilterChip(
          label: Text(day),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              destination['days'].add(day);
            } else {
              destination['days'].remove(day);
            }
            (context as Element).markNeedsBuild();
          },
        );
      }).toList(),
    );
  }
}
