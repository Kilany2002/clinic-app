import 'package:clinicc/features/patient/data/model/doctor_category_list.dart';
import 'package:flutter/material.dart';
import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/features/patient/presentation/widgets/patient_booking_button.dart';

class PatientDialog extends StatefulWidget {
  final DateTime selectedDate;
  final String doctorId;
  final VoidCallback? onSuccess;
  final Doctor doctor;

  const PatientDialog({
    Key? key,
    required this.selectedDate,
    required this.doctorId,
    required this.doctor,
    this.onSuccess,
  }) : super(key: key);

  @override
  _PatientDialogState createState() => _PatientDialogState();
}

class _PatientDialogState extends State<PatientDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _visitType = "First Visit";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      title: const Text("Add Patient"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Patient Name"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _ageController,
            decoration: const InputDecoration(labelText: "Age"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          const Text("Visit Type"),
          Row(
            children: [
              Flexible(
                child: RadioListTile(
                  title: const Text("First Visit"),
                  value: "First Visit",
                  groupValue: _visitType,
                  onChanged: (value) =>
                      setState(() => _visitType = value.toString()),
                ),
              ),
              Flexible(
                child: RadioListTile(
                  title: const Text("Follow-Up"),
                  value: "Follow-Up",
                  groupValue: _visitType,
                  onChanged: (value) =>
                      setState(() => _visitType = value.toString()),
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
          onPressed: () => _navigateToPayment(context),
          child: const Text("Continue"),
        ),
      ],
    );
  }

  // patient_dialog.dart
  void _navigateToPayment(BuildContext context) {
    if (_nameController.text.isEmpty || _ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final age = int.tryParse(_ageController.text);
    if (age == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid age")),
      );
      return;
    }

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Payment"),
            backgroundColor: AppColors.color1,
          ),
          body: PatientBookingButton(
            doctor: widget.doctor,
            patientName: _nameController.text,
            patientAge: age,
            visitType: _visitType,
            selectedDate: widget.selectedDate,
            onBookingSuccess: widget.onSuccess,
            patientFCMToken:
                'd0zf1hPFS7m3JqCuUF76nj:APA91bFimUBF9HHGDVJdTFiYIo0kDqkfmnJkkgQtUWU7_xrOLHxifmaQE_BIN0VN8KWdYbf-IQpAsylmfwiBfeEu0ylTYFMyePJDbM_G4F6_HhQOcNJrvTo',
            doctorFCMToken:
                'd0zf1hPFS7m3JqCuUF76nj:APA91bFimUBF9HHGDVJdTFiYIo0kDqkfmnJkkgQtUWU7_xrOLHxifmaQE_BIN0VN8KWdYbf-IQpAsylmfwiBfeEu0ylTYFMyePJDbM_G4F6_HhQOcNJrvTo',
          ),
        ),
      ),
    );
  }
}
