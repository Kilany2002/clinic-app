import 'package:clinicc/features/doctor/home/widget/add_patient.dart';
import 'package:flutter/material.dart';
import 'package:clinicc/features/doctor/home/widget/add_patient_dialog.dart';

class QuickActions extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback refreshPatients;

  const QuickActions({
    super.key,
    required this.selectedDate,
    required this.refreshPatients,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AddPatient(
            icon: Icons.person_add,
            title: 'Add Patient',
            onTap: () => _showAddPatientDialog(context)),
      ],
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddPatientDialog(
        selectedDate: selectedDate,
        refreshPatients: refreshPatients,
      ),
    );
  }
}
