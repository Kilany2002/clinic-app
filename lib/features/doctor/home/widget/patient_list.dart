import 'package:flutter/material.dart';
import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';

class PatientList extends StatelessWidget {
  final List<Map<String, dynamic>> patients;

  const PatientList({Key? key, required this.patients}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];
        return _buildPatientCard(
          patient['name'],
          patient['order_number'].toString(),
          patient['visit_type'],
          patient['visit_type'] == "First Visit" ? Colors.blue : Colors.green,
        );
      },
    );
  }

  Widget _buildPatientCard(
      String name, String orderNumber, String visitType, Color statusColor) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          child: Text(orderNumber),
          backgroundColor: AppColors.color1,
          foregroundColor: AppColors.white,
        ),
        title: Text(name, style: getTitleStyle(fontSize: 16)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(visitType, style: getSubTitleStyle()),
        ),
      ),
    );
  }
}
