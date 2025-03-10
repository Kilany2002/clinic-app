import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorProfileController {
  final supabase = Supabase.instance.client;

  String _name = "Loading...";
  String _email = "Loading...";
  String? _imageUrl;

  String get name => _name;
  String get email => _email;
  String? get imageUrl => _imageUrl;

  Future<void> fetchUserData() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('User is not logged in');
      return;
    }

    _email = user.email ?? "No Email";

    try {
      print('Fetching doctor data for user: ${user.id}');
      final response = await supabase
          .from('doctors')
          .select()
          .eq('user_id', user.id)
          .single();

      print('Fetched data: $response');
      _name = response['name'] ?? 'Unknown';
      _imageUrl = response['image_url'];
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> editImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final user = supabase.auth.currentUser;
      if (user == null) {
        print('User is not logged in');
        return;
      }

      try {
        final String filePath = 'doctor_profiles/${user.id}.jpg';
        print('Uploading image to: $filePath');
        await supabase.storage.from('doctor_images').upload(filePath, File(pickedFile.path));
        final String imageUrl =
            supabase.storage.from('doctor_images').getPublicUrl(filePath);
        print('Image uploaded successfully. URL: $imageUrl');
        await supabase
            .from('doctors')
            .update({'image_url': imageUrl})
            .eq('user_id', user.id);

        _imageUrl = imageUrl;
      } catch (e) {
        print('Failed to update image: $e');
        throw Exception('Failed to update image: $e');
      }
    }
  }

  Future<void> deleteImage() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('User is not logged in');
      return;
    }

    try {
      final String filePath = 'doctor_profiles/${user.id}.jpg';
      print('Deleting image from: $filePath');
      await supabase.storage.from('doctor_images').remove([filePath]);
      await supabase
          .from('doctors')
          .update({'image_url': null}).eq('user_id', user.id);

      _imageUrl = null;
    } catch (e) {
      print('Failed to delete image: $e');
      throw Exception('Failed to delete image: $e');
    }
  }
}