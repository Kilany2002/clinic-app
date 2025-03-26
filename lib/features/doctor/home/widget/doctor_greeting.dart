import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';
import 'package:flutter/material.dart';

class DoctorGreeting extends StatelessWidget {
  final String? doctorName;

  const DoctorGreeting({Key? key, required this.doctorName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Hello Dr,', style: getTitleStyle(color: AppColors.black)),
        Text(' ${doctorName ?? 'Doctor'}', style: getTitleStyle()),
      ],
    );
  }
}
