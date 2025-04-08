import 'package:flutter/material.dart';
import 'package:clinicc/core/widgets/profile_image_picker.dart';
import '../logic/doctor_form_controller.dart';

class BasicInfoStep extends StatelessWidget {
  const BasicInfoStep({
    super.key,
    required this.controller,
  });

  final DoctorFormController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      ProfileImagePicker(
  onTap: () async {
    await controller.pickAndUploadImage();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(controller.imageUrl != null 
        ? 'Profile image uploaded successfully!'
        : 'Failed to upload image')),
    );
  },
  image: controller.image,
  imageUrl: controller.imageUrl, // Add this parameter
),
        const SizedBox(height: 20),
        TextFormField(
          initialValue: controller.doctorName,
          decoration: const InputDecoration(hintText: 'Doctor Name'),
          onChanged: controller.updateDoctorName,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<int>(
          value: controller.selectedCategoryId,
          items: controller.categories.map((category) {
            return DropdownMenuItem<int>(
              value: category['id'],
              child: Text(category['name']),
            );
          }).toList(),
          onChanged: controller.updateSelectedCategory,
          decoration: const InputDecoration(labelText: 'Specialization'),
          validator: (value) => value == null ? 'Required' : null,
        ),
      ],
    );
  }
}
