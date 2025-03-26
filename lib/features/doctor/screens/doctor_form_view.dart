import 'dart:io';
import 'package:clinicc/core/widgets/profile_image_picker.dart';
import 'package:clinicc/features/doctor/widgets/destinations_list.dart';
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
  int? _selectedCategoryId;
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<Map<String, dynamic>> _destinations = [];
  File? _image;
  String? _imageUrl;
  bool _isLoading = false;
  String? _doctorName;

  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _initializeDestinations();
    _fetchCategories(); 
    _fetchDoctorName(); 
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
  Future<void> _fetchCategories() async {
    final response = await supabase.from('categories').select('id, name');
    setState(() {
      _categories =
          response.map((c) => {'id': c['id'], 'name': c['name']}).toList();
    });
  }

  Future<void> _fetchDoctorName() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final response = await supabase
          .from('users')
          .select('name')
          .eq('id', user.id)
          .single();

      if (response['name'] != null) {
        setState(() {
          _doctorName = response['name'];
        });
      }
    }
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

        final String filePath = 'doctor_profiles/${user.id}.jpg';
        await supabase.storage.from('doctor_images').upload(filePath, _image!);
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedCategoryId != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = supabase.auth.currentUser;
        if (user == null) throw Exception('User not logged in');

        print("Selected Category ID: $_selectedCategoryId"); // ✅ Debugging

        final doctorData = {
          'user_id': user.id,
          'name': _doctorName,
          'category_id': _selectedCategoryId,
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
          'image_url': _imageUrl,
        };

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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a specialization')),
      );
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

                /// ✅ **Doctor Name as Hint**
                _buildTextFormField(
                    TextEditingController(text: _doctorName), 'Doctor Name'),

                /// ✅ **Dropdown for Categories from Supabase**
                DropdownButtonFormField<int>(
                  value: _selectedCategoryId,
                  items: _categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category['id'],
                      child: Text(category['name']),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedCategoryId = value),
                  decoration: InputDecoration(hintText: 'Specialization'),
                  validator: (value) =>
                      value == null ? 'Select specialization' : null,
                ),

                _buildTextFormField(_experienceController,
                    'Years of Experience', TextInputType.number),
                _buildTextFormField(_descriptionController, 'Description'),
                _buildTextFormField(
                    _priceController, 'Price', TextInputType.number),
                const SizedBox(height: 10),

                DestinationsList(
                  destinations: _destinations,
                  onAddDestination: () => setState(() => _destinations.add({
                        'destination': TextEditingController(),
                        'days': [],
                        'timeSlots': [],
                      })),
                  onPickTime: (index, isStartTime) async {
                    final TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      setState(() {
                        _destinations[index]['timeSlots'][0]
                            [isStartTime ? 'from' : 'to'] = selectedTime;
                      });
                    }
                  },
                  onRemoveDestination: (index) =>
                      setState(() => _destinations.removeAt(index)),
                  onAddTimeSlot: (int) {},
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
      [TextInputType? inputType]) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(labelText: hintText),
      validator: (value) => value!.isEmpty ? 'Enter $hintText' : null,
    );
  }
}
