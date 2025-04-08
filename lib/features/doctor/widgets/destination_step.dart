import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/features/doctor/widgets/days_selector.dart';
import 'package:clinicc/features/doctor/widgets/time_slots_list.dart';
import 'package:flutter/material.dart';
import '../logic/doctor_form_controller.dart';

class DestinationsStep extends StatelessWidget {
  const DestinationsStep({
    super.key,
    required this.controller,
    required this.context,
  });

  final DoctorFormController controller;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...controller.destinations.asMap().entries.map((entry) {
          final index = entry.key;
          final destination = entry.value;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: destination['destination'],
                          decoration: InputDecoration(
                            hintText: 'Destination ${index + 1}',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  controller.removeDestination(index),
                            ),
                          ),
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Required' : null,
                          onChanged: (value) =>
                              controller.updateDestinationText(index, value),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DaysSelector(
                      controller: controller,
                      destinationIndex: index,
                      destination: destination),
                  const SizedBox(height: 16),
                  TimeSlotSelector(
                      controller: controller,
                      context: context,
                      index: index,
                      destination: destination),
                ],
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.canProceedToNextStep
                ? AppColors.color1
                : Colors.grey,
          ),
          onPressed: controller.addDestination,
          child: const Text('Add Destination'),
        ),
      ],
    );
  }
}
