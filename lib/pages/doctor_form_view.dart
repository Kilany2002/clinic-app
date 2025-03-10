import 'dart:io';
import 'package:clinicc/core/widgets/profile_image_picker.dart';
import 'package:clinicc/features/doctor/widgets/destinations_list.dart';
import 'package:clinicc/features/doctor/widgets/specialization_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorFormScreen extends StatefulWidget {
  const DoctorFormScreen({Key? key}) : super(key: key);
  static const String id = 'DoctorFormScreen';

  @override
  _DoctorFormScreenState createState() => _DoctorFormScreenState();
}

class _DoctorFormScreenState extends State<DoctorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedSpecialization;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<Map<String, dynamic>> _destinations = [];
  File? _image;
  String? _imageUrl;
  bool _isLoading = false;

  final supabase = Supabase.instance.client;

  final List<String> specialization = [
    'جراحة عامة',
    "دكتور قلب",
    "دكتور أطفال",
    "دكتور عظام",
    'جراحة عيون',
    "دكتور النساء والتوليد",
    "دكتور باطنه",
    "دكتور أسنان",
    'انف واذن وحنجرة',
    "التجميلية والراحة",
  ];

  @override
  void initState() {
    super.initState();
    _initializeDestinations();
  }

  void _initializeDestinations() {
    _destinations.add({
      'destination': TextEditingController(),
      'days': [],
      'timeSlots': [
        {'from': TimeOfDay.now(), 'to': TimeOfDay.now()},
      ],
    });
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      try {
        final user = supabase.auth.currentUser;
        if (user == null) return;

        // Define the file path in the bucket
        final String filePath = 'doctor_profiles/${user.id}.jpg';

        // Upload image to Supabase Storage (bucket: doctor_images)
        await supabase.storage.from('doctor_images').upload(filePath, _image!);

        // Get the public URL of the uploaded file
        final String imageUrl =
            supabase.storage.from('doctor_images').getPublicUrl(filePath);

        setState(() {
          _imageUrl = imageUrl;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  void _addDestination() {
    setState(() {
      _destinations.add({
        'destination': TextEditingController(),
        'days': [],
        'timeSlots': [],
      });
    });
  }

  void _pickTime(int index, bool isStartTime) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        if (isStartTime) {
          _destinations[index]['timeSlots'][0]['from'] = selectedTime;
        } else {
          _destinations[index]['timeSlots'][0]['to'] = selectedTime;
        }
      });
    }
  }

  void _addTimeSlot(int index) {
    setState(() {
      _destinations[index]['timeSlots'].add({
        'from': TimeOfDay.now(),
        'to': TimeOfDay.now(),
      });
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = supabase.auth.currentUser;
        if (user == null) {
          throw Exception('User not logged in');
        }

        // Prepare doctor data
        final doctorData = {
          'name': _nameController.text,
          'specialization': _selectedSpecialization,
          'experience': _experienceController.text,
          'description': _descriptionController.text,
          'price': _priceController.text,
          'destinations': _destinations.map((destination) {
            return {
              'destination': destination['destination'].text,
              'days': destination['days'],
              'timeSlots': destination['timeSlots'].map((slot) {
                return {
                  'from': '${slot['from'].hour}:${slot['from'].minute}',
                  'to': '${slot['to'].hour}:${slot['to'].minute}',
                };
              }).toList(),
            };
          }).toList(),
          'image_url': _imageUrl, // Use the already uploaded image URL
          'user_id':
              user.id, // Associate the doctor data with the logged-in user
        };

        // Save doctor data in Supabase
        await supabase.from('doctors').upsert([doctorData]);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile submitted successfully!')),
        );

        Navigator.pushNamed(context, 'NavBarScreen');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileImagePicker(onTap: _pickAndUploadImage, image: _image),
                const SizedBox(height: 20),
                _buildTextFormField(_nameController, 'Name'),
                SpecializationDropdown(
                  selectedValue: _selectedSpecialization,
                  onChanged: (value) =>
                      setState(() => _selectedSpecialization = value),
                  specialization: specialization,
                ),
                _buildTextFormField(_experienceController,
                    'Years of Experience', TextInputType.number),
                _buildTextFormField(
                    _descriptionController, 'Description', null),
                _buildTextFormField(
                    _priceController, 'Price', TextInputType.number),
                const SizedBox(height: 10),
                DestinationsList(
                  destinations: _destinations,
                  onAddDestination: _addDestination,
                  onPickTime: _pickTime,
                  onAddTimeSlot: _addTimeSlot,
                ),
                IconButton(
                  icon: const Icon(Icons.add_location),
                  onPressed: _addDestination,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String hintText,
      [TextInputType? inputType, int? maxLines]) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(hintText: hintText),
      validator: (value) => value!.isEmpty ? 'Enter $hintText' : null,
    );
  }
}
