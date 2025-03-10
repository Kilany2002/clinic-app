import 'package:flutter/material.dart';
import 'days_selector.dart';
import 'time_slots_list.dart';

class DestinationsList extends StatelessWidget {
  final List<Map<String, dynamic>> destinations;
  final VoidCallback onAddDestination;
  final Function(int, bool) onPickTime;
  final Function(int) onAddTimeSlot;

  const DestinationsList({
    Key? key,
    required this.destinations,
    required this.onAddDestination,
    required this.onPickTime,
    required this.onAddTimeSlot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            TextFormField(
              controller: destinations[index]['destination'],
              decoration: InputDecoration(hintText: 'Destination ${index + 1}'),
            ),
            DaysSelector(index: index, destination: destinations[index]),
            TimeSlotsList(
              index: index,
              timeSlots: destinations[index]['timeSlots'],
              onPickTime: onPickTime,
              onAddTimeSlot: onAddTimeSlot,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onAddTimeSlot(index),
            ),
          ],
        );
      },
    );
  }
}
