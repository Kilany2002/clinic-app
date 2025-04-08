import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorProfileController {
  final supabase = Supabase.instance.client;

  String _name = "Loading...";
  String _email = "Loading...";
  String? _imageUrl;
  String? _description;
  double? _price;
  int? _experience;
  String? _specialization;
  String? _category;
  double? _rating;
  List<Map<String, dynamic>>? _destinationsData;
  List<String>? _workingDays;
  List<Map<String, String>>? _workingHours;

  // Getters
  String get name => _name;
  String get email => _email;
  String? get imageUrl => _imageUrl;
  String? get description => _description;
  double? get price => _price;
  int? get experience => _experience;
  String? get specialization => _specialization;
  String? get category => _category;
  double? get rating => _rating;
  List<Map<String, dynamic>>? get destinationsData => _destinationsData;
  List<String>? get workingDays => _workingDays;
  List<Map<String, String>>? get workingHours => _workingHours;

  Future<void> fetchUserData() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('User is not logged in');
      return;
    }

    _email = user.email ?? "No Email";

    try {
      final response = await supabase
          .from('doctors')
          .select()
          .eq('user_id', user.id)
          .single();

      _name = response['name'] ?? 'Unknown';
      _imageUrl = response['image_url'];
      _description = response['description'];
      _specialization = response['specialization'];
      _category = response['category_id']?.toString();

      // Parse numeric fields
      _price = _parseDouble(response['price']);
      _experience = _parseInt(response['experience']);
      _rating = _parseDouble(response['rating']);

      // Parse destinations data
      if (response['destinations'] != null &&
          response['destinations'] is List) {
        _destinationsData =
            List<Map<String, dynamic>>.from(response['destinations']);
        _parseWorkingDaysAndHours();
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  void _parseWorkingDaysAndHours() {
    if (_destinationsData == null) return;

    _workingDays = [];
    _workingHours = [];

    for (var destination in _destinationsData!) {
      if (destination['days'] is List) {
        _workingDays!.addAll((destination['days'] as List).cast<String>());
      }
      if (destination['timeSlots'] is List) {
        for (var slot in destination['timeSlots']) {
          _workingHours!.add({
            'from': slot['from']?.toString() ?? '',
            'to': slot['to']?.toString() ?? '',
          });
        }
      }
    }

    // Remove duplicates from days
    _workingDays = _workingDays?.toSet().toList();
  }

  Future<void> updateProfile({
    required String name,
    String? description,
    double? price,
    int? experience,
    List<Map<String, dynamic>>? destinations,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('User is not logged in');
      return;
    }

    try {
      final updateData = {
        'name': name,
        'description': description,
        'price': price,
        'experience': experience,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (destinations != null) {
        updateData['destinations'] = destinations;
      }

      await supabase.from('doctors').update(updateData).eq('user_id', user.id);

      // Update local values
      _name = name;
      _description = description;
      _price = price;
      _experience = experience;
      if (destinations != null) {
        _destinationsData = destinations;
        _parseWorkingDaysAndHours();
      }
    } catch (e) {
      print('Failed to update profile: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> editImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      try {
        final String filePath = 'doctor_profiles/${user.id}.jpg';
        await supabase.storage.from('doctor_images').upload(
            filePath, File(pickedFile.path),
            fileOptions: FileOptions(contentType: 'image/jpeg'));

        final String imageUrl =
            supabase.storage.from('doctor_images').getPublicUrl(filePath);

        await supabase
            .from('doctors')
            .update({'image_url': imageUrl}).eq('user_id', user.id);

        _imageUrl = imageUrl;
      } catch (e) {
        print('Failed to update image: $e');
        throw Exception('Failed to update image: $e');
      }
    }
  }

  Future<void> deleteImage() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final String filePath = 'doctor_profiles/${user.id}.jpg';
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
