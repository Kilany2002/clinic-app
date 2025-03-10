import 'package:flutter/material.dart';

class DaysSelector extends StatelessWidget {
  final int index;
  final Map<String, dynamic> destination;

  const DaysSelector({Key? key, required this.index, required this.destination}) : super(key: key);

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
            // If selected, add the day to the list. If deselected, remove it.
            if (selected) {
              destination['days'].add(day);
            } else {
              destination['days'].remove(day);
            }
            // Call setState to update the UI and reflect the changes.
            (context as Element).markNeedsBuild();
          },
        );
      }).toList(),
    );
  }
}
