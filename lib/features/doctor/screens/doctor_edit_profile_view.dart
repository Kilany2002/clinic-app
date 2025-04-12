import 'package:clinicc/features/doctor/widgets/location_picker.dart';
import 'package:clinicc/features/doctor/widgets/profile/days_selector.dart';
import 'package:flutter/material.dart';
import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/features/doctor/logic/doctor_profile_controller.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../widgets/profile/ReadOnlyCard.dart';
import '../widgets/profile/TimeSlotsList.dart';

class DoctorEditProfileView extends StatefulWidget {
  const DoctorEditProfileView({super.key});

  @override
  _DoctorEditProfileViewState createState() => _DoctorEditProfileViewState();
}

class _DoctorEditProfileViewState extends State<DoctorEditProfileView> {
  final DoctorProfileController _controller = DoctorProfileController();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _experienceController;
  late List<Map<String, dynamic>> _destinations;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _experienceController = TextEditingController();
    _destinations = [];
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _experienceController.dispose();

    // Dispose all destination controllers
    for (var dest in _destinations) {
      dest['destination'].dispose();
    }

    super.dispose();
  }

  void _updateDestinationLocation(int index, String location) {
    setState(() {
      _destinations[index]['location'] = location;
    });
  }

  Future<void> _pickLocation(int index) async {
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

// Modify the _loadData method to include location:
  Future<void> _loadData() async {
    await _controller.fetchUserData();
    if (mounted) {
      setState(() {
        _nameController.text = _controller.name;
        _descriptionController.text = _controller.description ?? '';
        _priceController.text = _controller.price?.toString() ?? '';
        _experienceController.text = _controller.experience?.toString() ?? '';
        if (_controller.destinationsData != null) {
          _destinations = _controller.destinationsData!.map((dest) {
            return {
              'destination': TextEditingController(
                  text: dest['destination']?.toString() ?? ''),
              'days': List<String>.from(dest['days'] ?? []),
              'timeSlots':
                  List<Map<String, dynamic>>.from(dest['timeSlots'] ?? []),
              'location': dest['location']?.toString() ?? '',
            };
          }).toList();
        }
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Prepare destinations data for saving
        final destinationsToSave = _destinations.map((dest) {
          return {
            'destination': dest['destination'].text,
            'days': dest['days'],
            'timeSlots': dest['timeSlots'],
          };
        }).toList();

        await _controller.updateProfile(
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.tryParse(_priceController.text),
          experience: int.tryParse(_experienceController.text),
          destinations: destinationsToSave,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: $e')),
          );
        }
      }
    }
  }

  void _addDestination() {
    setState(() {
      _destinations.add({
        'destination': TextEditingController(),
        'days': [],
        'timeSlots': [
          {'from': null, 'to': null}
        ],
        'location': '',
      });
    });
  }

  void _removeDestination(int index) {
    setState(() {
      _destinations[index]['destination'].dispose();
      _destinations.removeAt(index);
    });
  }

  void _updateDestinationText(int index, String value) {
    _destinations[index]['destination'].text = value;
  }

  void _toggleDaySelection(int destinationIndex, String day) {
    setState(() {
      if (_destinations[destinationIndex]['days'].contains(day)) {
        _destinations[destinationIndex]['days'].remove(day);
      } else {
        _destinations[destinationIndex]['days'].add(day);
      }
    });
  }

  Future<void> _pickTime(int destinationIndex, bool isFromTime) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        if (isFromTime) {
          _destinations[destinationIndex]['timeSlots'][0]['from'] = time;
        } else {
          _destinations[destinationIndex]['timeSlots'][0]['to'] = time;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: ('Edit Profile'),
        showBackArrow: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _controller.imageUrl != null
                        ? NetworkImage(_controller.imageUrl!)
                        : const AssetImage('assets/images/sara 1.png')
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.blue),
                      onPressed: _controller.editImage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Basic Info Section
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person, color: AppColors.color1),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Specialization (read-only)
              if (_controller.specialization != null)
                ReadOnlyCard(
                    title: 'Specialization',
                    value: _controller.specialization!),
              const SizedBox(height: 16),

              TextFormField(
                controller: _experienceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Years of Experience',
                  prefixIcon: Icon(Icons.work, color: AppColors.color1),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Consultation Fee',
                  prefixIcon: Icon(Icons.attach_money, color: AppColors.color1),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.description, color: AppColors.color1),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              if (_controller.rating != null)
                ReadOnlyCard(
                    title: 'Rating',
                    value: '${_controller.rating!.toStringAsFixed(1)}/5'),
              const SizedBox(height: 20),

              Text(
                'Availability',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.color1,
                ),
              ),
              const SizedBox(height: 16),

              ..._destinations.asMap().entries.map((entry) {
                final index = entry.key;
                final destination = entry.value;

                return Card(
                  color: Colors.white,
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: destination['destination'],
                                decoration: InputDecoration(
                                  labelText: 'Destination ${index + 1}',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _removeDestination(index),
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) =>
                                    value?.isEmpty ?? true ? 'Required' : null,
                                onChanged: (value) =>
                                    _updateDestinationText(index, value),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          leading: const Icon(Icons.location_on),
                          title: Text(
                            destination['location']?.isNotEmpty ?? false
                                ? destination['location']
                                : 'Select Location',
                            style: TextStyle(
                              color:
                                  destination['location']?.isNotEmpty ?? false
                                      ? Colors.black
                                      : Colors.grey,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => _pickLocation(index),
                        ),
                        const SizedBox(height: 8),
                        DaysSelector(
                          days: destination['days'],
                          onDaySelected: (day) =>
                              _toggleDaySelection(index, day),
                        ),
                        const SizedBox(height: 16),
                        TimeSlotsList(
                          timeSlot: destination['timeSlots'][0],
                          onFromTimeSelected: () => _pickTime(index, true),
                          onToTimeSelected: () => _pickTime(index, false),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.color1,
                ),
                onPressed: _addDestination,
                child: const Text('Add Destination'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
