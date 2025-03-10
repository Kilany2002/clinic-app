import 'package:clinicc/core/constants/constant_data.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
   CustomTextField({
    super.key, required this.hint,this.onChanged,this.textType
  });
  final String hint;
   Function(String)? onChanged;
TextInputType? textType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(validator: (value) {
      if (value!.isEmpty) {
        return 'Field is required';
      }
      
    },
      onChanged: onChanged,
      keyboardType: textType,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: primaryColor),
          filled: true,
          fillColor: primaryColor.withOpacity(0.2),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20))),
    );
  }
}
