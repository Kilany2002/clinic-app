import 'package:flutter/material.dart';

class TimeSlotsList extends StatelessWidget {
  final Map<String, dynamic> timeSlot;
  final VoidCallback onFromTimeSelected;
  final VoidCallback onToTimeSelected;

  const TimeSlotsList({
    super.key,
    required this.timeSlot,
    required this.onFromTimeSelected,
    required this.onToTimeSelected,
  });

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return 'Select Time';
    final parts = time.split(':');
    if (parts.length != 2) return time;

    try {
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : hour;

      return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return time; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onFromTimeSelected,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Start Time',
                prefixIcon: Icon(Icons.access_time),
              ),
              child: Text(
                _formatTime(timeSlot['from']?.toString()),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: onToTimeSelected,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'End Time',
                prefixIcon: Icon(Icons.access_time),
              ),
              child: Text(
                _formatTime(timeSlot['to']?.toString()),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
