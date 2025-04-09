
import 'package:flutter/material.dart';
import '../../logic/doctor_form_controller.dart';
class TimeSlotSelector extends StatelessWidget {
  const TimeSlotSelector({
    super.key,
    required this.controller,
    required this.context,
    required this.index,
    required this.destination,
  });

  final DoctorFormController controller;
  final BuildContext context;
  final int index;
  final Map<String, dynamic> destination;

  @override
  Widget build(BuildContext context) {
    final timeSlot = destination['timeSlots'][0];
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => controller.pickTime(context, index, true),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Start Time',
                prefixIcon: Icon(Icons.access_time),
              ),
              child: Text(
                timeSlot['from'] != null
                    ? timeSlot['from'].format(context)
                    : 'Select Time',
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => controller.pickTime(context, index, false),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'End Time',
                prefixIcon: Icon(Icons.access_time),
              ),
              child: Text(
                timeSlot['to'] != null
                    ? timeSlot['to'].format(context)
                    : 'Select Time',
              ),
            ),
          ),
        ),
      ],
    );
  }
}