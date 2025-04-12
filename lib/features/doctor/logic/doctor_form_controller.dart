import 'dart:io';
import 'package:clinicc/features/doctor/widgets/location_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorFormController with ChangeNotifier {
  final supabase = Supabase.instance.client;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  String? _doctorName;
  int? _selectedCategoryId;
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  File? _image;
  String? _imageUrl;
  List<Map<String, dynamic>> _destinations = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = false;
  int get currentStep => _currentStep;
  String? get doctorName => _doctorName;
  int? get selectedCategoryId => _selectedCategoryId;
  File? get image => _image;
  String? get imageUrl => _imageUrl;
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get destinations => _destinations;
  List<Map<String, dynamic>> get categories => _categories;

  bool get canProceedToNextStep {
  switch (_currentStep) {
    case 0:
      return _doctorName != null &&
          _doctorName!.isNotEmpty &&
          _selectedCategoryId != null;
    case 1:
      return experienceController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          priceController.text.isNotEmpty;
    case 2:
      return _destinations.isNotEmpty &&
          _destinations.every((d) =>
              d['destination'].text.isNotEmpty &&
              d['days'].isNotEmpty &&
              d['timeSlots'].isNotEmpty &&
              d['location'].isNotEmpty); // Add location check
    default:
      return false;
  }
}

  void nextStep() {
    if (_currentStep < 2 && canProceedToNextStep) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void updateDoctorName(String name) {
    _doctorName = name;
    notifyListeners();
  }

  void updateSelectedCategory(int? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void updateDestinationText(int index, String value) {
    _destinations[index]['destination'].text = value;
    notifyListeners();
  }

  Future<void> initialize() async {
    _initializeDestinations();
    await _fetchCategories();
  }

void _initializeDestinations() {
  _destinations.add({
    'destination': TextEditingController(),
    'days': [],
    'timeSlots': [
      {'from': TimeOfDay.now(), 'to': TimeOfDay.now()}
    ],
    'location': '',
  });
  notifyListeners();
}
  Future<void> _fetchCategories() async {
    final response = await supabase.from('categories').select('id, name');
    _categories =
        response.map((c) => {'id': c['id'], 'name': c['name']}).toList();
    notifyListeners();
  }

  Future<void> pickAndUploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);

      final user = supabase.auth.currentUser;
      if (user == null) return;

      final String filePath = 'doctor_profiles/${user.id}.jpg';
      await supabase.storage.from('doctor_images').upload(filePath, _image!);
      _imageUrl = supabase.storage.from('doctor_images').getPublicUrl(filePath);
      notifyListeners();
    }
  }
Future<void> pickLocation(BuildContext context, int index) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LocationPickerScreen(
        onLocationSelected: (latLng, address) {
          _updateDestinationLocation(index, address);
          return address;
        },
      ),
    ),
  );
  if (result != null) {
    _updateDestinationLocation(index, result);
  }
}
void _updateDestinationLocation(int index, String location) {
  _destinations[index]['location'] = location;
  notifyListeners();
}
 void addDestination() {
  _destinations.add({
    'destination': TextEditingController(),
    'days': [],
    'timeSlots': [
      {'from': TimeOfDay.now(), 'to': TimeOfDay.now()}
    ],
    'location': '',
  });
  notifyListeners();
}

  Future<void> pickTime(
      BuildContext context, int index, bool isStartTime) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      _destinations[index]['timeSlots'][0][isStartTime ? 'from' : 'to'] =
          selectedTime;
      notifyListeners();
    }
  }

  void removeDestination(int index) {
    _destinations.removeAt(index);
    notifyListeners();
  }

  Future<void> loadExistingImage(String imageUrl) async {
    _imageUrl = imageUrl;
    notifyListeners();
  }

  void toggleDaySelection(int destinationIndex, String day) {
    final days = _destinations[destinationIndex]['days'];
    if (days.contains(day)) {
      days.remove(day);
    } else {
      days.add(day);
    }
    notifyListeners();
  }
Future<void> submitForm(BuildContext context) async {
  if (formKey.currentState!.validate() && _selectedCategoryId != null) {
    _isLoading = true;
    notifyListeners();

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      if (_image != null && _imageUrl == null) {
        await pickAndUploadImage();
      }

      final doctorData = {
        'user_id': user.id,
        'name': _doctorName,
        'category_id': _selectedCategoryId,
        'experience': experienceController.text,
        'description': descriptionController.text,
        'price': priceController.text,
        'destinations': _destinations.map((destination) {
          return {
            'destination': destination['destination'].text,
            'days': destination['days'],
            'location': destination['location'], // Add location
            'timeSlots': destination['timeSlots'].map((slot) {
              return {
                'from': '${slot['from'].hour}:${slot['from'].minute}',
                'to': '${slot['to'].hour}:${slot['to'].minute}',
              };
            }).toList(),
          };
        }).toList(),
        'image_url': _imageUrl,
      };

      await supabase.from('doctors').upsert([doctorData]);
      Navigator.pushNamed(context, 'NavBarScreen');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
}
