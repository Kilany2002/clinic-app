import 'package:flutter/material.dart';
import 'dart:io';

class ProfileImagePicker extends StatelessWidget {
  final VoidCallback onTap;
  final File? image;

  const ProfileImagePicker({super.key, required this.onTap, this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: image != null ? FileImage(image!) : null,
        child: image == null ? const Icon(Icons.camera_alt, size: 50) : null,
      ),
    );
  }
}
