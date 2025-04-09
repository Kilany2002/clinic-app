import 'package:flutter/material.dart';
import '../../logic/doctor_form_controller.dart';

class ExperienceStep extends StatelessWidget {
  final DoctorFormController controller;
  final VoidCallback onChanged;

  const ExperienceStep({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller.experienceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Years of Experience'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Description'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.priceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Price'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}
