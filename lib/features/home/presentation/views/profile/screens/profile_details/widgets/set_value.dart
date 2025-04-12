import 'package:flutter/material.dart';

Widget setValue(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(height: 6),
      Text(
        value,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 20),
    ],
  );
}
