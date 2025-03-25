import 'package:flutter/material.dart';
import 'days_selector.dart';
import 'time_slots_list.dart';

class DestinationsList extends StatelessWidget {
  final List<Map<String, dynamic>> destinations;
  final VoidCallback onAddDestination;
  final Function(int, bool) onPickTime;
  final Function(int) onAddTimeSlot;
  final Function(int) onRemoveDestination; 
  const DestinationsList({
    Key? key,
    required this.destinations,
    required this.onAddDestination,
    required this.onPickTime,
    required this.onAddTimeSlot,
    required this.onRemoveDestination, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...destinations.asMap().entries.map((entry) {
          int index = entry.key;
          var destination = entry.value;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: destination['destination'],
                    decoration: InputDecoration(
                      hintText: 'Destination ${index + 1}',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onRemoveDestination(index),
                      ),
                    ),
                  ),
                  DaysSelector(index: index, destination: destination),
                  TimeSlotsList(
                    index: index,
                    timeSlots: destination['timeSlots'],
                    onPickTime: onPickTime,
                    onAddTimeSlot: onAddTimeSlot,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => onAddTimeSlot(index),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: onAddDestination,
          icon: Icon(Icons.add_location),
          label: Text('Add Destination'),
        ),
      ],
    );
  }
}
