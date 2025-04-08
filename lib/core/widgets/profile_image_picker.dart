import 'package:flutter/material.dart';
import 'dart:io';

class ProfileImagePicker extends StatelessWidget {
  final VoidCallback onTap;
  final File? image;
  final String? imageUrl;
  
  const ProfileImagePicker({
    super.key,
    required this.onTap,
    this.image,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        
        radius: 50,
        backgroundColor: Colors.grey[200],
        backgroundImage: _getImage(),
        child: _getImage() == null 
            ? const Icon(Icons.add_a_photo, size: 30)
            : null,
      ),
    );
  }

  ImageProvider? _getImage() {
    if (image != null) {
      return FileImage(image!);
    } else if (imageUrl != null) {
      return NetworkImage(imageUrl!);
    }
    return null;
  }
}