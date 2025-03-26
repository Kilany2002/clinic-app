import 'package:clinicc/core/utils/text_style.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value, style: getTitleStyle(fontSize: 22)),
          const SizedBox(height: 5),
          Text(title, style: getSubTitleStyle()),
        ],
      ),
    );
  }
}
