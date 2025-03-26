import 'package:flutter/material.dart';
import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/features/doctor/services/patient_service.dart';

class AddPatientDialog extends StatefulWidget {
  final DateTime selectedDate; // Changed to DateTime
  final VoidCallback refreshPatients;

  const AddPatientDialog({
    Key? key,
    required this.selectedDate,
    required this.refreshPatients,
  }) : super(key: key);

  @override
  _AddPatientDialogState createState() => _AddPatientDialogState();
}

class _AddPatientDialogState extends State<AddPatientDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String visitType = "First Visit";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      title: const Text("Add Patient"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Patient Name"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: ageController,
            decoration: const InputDecoration(labelText: "Age"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          const Text("Visit Type"),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: RadioListTile(
                  title: const Text("First Visit", style: TextStyle(fontSize: 14)),
                  value: "First Visit",
                  dense: true,
                  activeColor: AppColors.color1,
                  contentPadding: EdgeInsets.zero,
                  groupValue: visitType,
                  onChanged: (value) {
                    setState(() {
                      visitType = value.toString();
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: RadioListTile(
                  title: const Text("Follow-Up", style: TextStyle(fontSize: 14)),
                  value: "Follow-Up",
                  dense: true,
                  activeColor: AppColors.color1,
                  contentPadding: EdgeInsets.zero,
                  groupValue: visitType,
                  onChanged: (value) {
                    setState(() {
                      visitType = value.toString();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _addPatient,
          child: const Text("Add"),
        ),
      ],
    );
  }

 Future<void> _addPatient() async {
  // Validate input fields
  if (nameController.text.isEmpty || ageController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please fill all fields"),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // Parse age
  int? age = int.tryParse(ageController.text);
  if (age == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter a valid age"),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // Call the service to add the patient
  bool success = await PatientService.addPatient(
    name: nameController.text,
    age: age,
    visitType: visitType,
    date: widget.selectedDate,
    context: context,
  );

  if (success) {
    widget.refreshPatients(); // Refresh the patient list
    Navigator.pop(context); // Close the dialog
  }
}
}