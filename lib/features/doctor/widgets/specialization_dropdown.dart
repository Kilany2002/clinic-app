import 'package:flutter/material.dart';

class SpecializationDropdown extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final List<String> specialization;

  const SpecializationDropdown({
    Key? key,
    required this.selectedValue,
    required this.onChanged,
    required this.specialization,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: const InputDecoration(hintText: 'Specialization'),
      items: specialization
          .map((spec) => DropdownMenuItem(value: spec, child: Text(spec)))
          .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Select a specialization' : null,
    );
  }
}
