import 'package:flutter/material.dart';

class TimeSlotsList extends StatelessWidget {
  final int index;
  final List<dynamic> timeSlots;
  final Function(int, bool) onPickTime;
  final Function(int) onAddTimeSlot;

  const TimeSlotsList({
    Key? key,
    required this.index,
    required this.timeSlots,
    required this.onPickTime,
    required this.onAddTimeSlot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: timeSlots.length,
      itemBuilder: (context, timeIndex) {
        final timeSlot = timeSlots[timeIndex];
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onPickTime(index, true),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Start Time',
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  child: Text(
                      timeSlot['from'] != null ? timeSlot['from'].format(context) : 'Select Time'),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => onPickTime(index, false),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'End Time',
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  child: Text(
                      timeSlot['to'] != null ? timeSlot['to'].format(context) : 'Select Time'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
