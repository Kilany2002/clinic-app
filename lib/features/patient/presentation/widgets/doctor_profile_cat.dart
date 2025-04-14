import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/widgets/custom_app_bar.dart';
import 'package:clinicc/features/doctor/home/widget/work_date_timeline.dart';
import 'package:clinicc/features/messages/chat_screen.dart';
import 'package:clinicc/features/patient/data/model/doctor_category_list.dart';
import 'package:clinicc/features/patient/presentation/widgets/patient_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DoctorProfileCat extends StatefulWidget {
  final Doctor doctor;

  const DoctorProfileCat({required this.doctor, Key? key}) : super(key: key);

  @override
  _DoctorProfileCatState createState() => _DoctorProfileCatState();
}

class _DoctorProfileCatState extends State<DoctorProfileCat> {
  String? _selectedDay;
  DateTime? _selectedDate;

  Future<void> _showLocationOnMap() async {
    final location = widget.doctor.destinations.isNotEmpty
        ? widget.doctor.destinations.first['location']
        : null;

    if (location == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No location available for this doctor'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final locations = await locationFromAddress(location);
      if (locations.isEmpty) return;

      final LatLng doctorLocation = LatLng(
        locations.first.latitude,
        locations.first.longitude,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: CustomAppBar(
              title: 'Doctor Location',
              showBackArrow: true,
            ),
            body: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: doctorLocation,
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('doctorLocation'),
                  position: doctorLocation,
                  infoWindow: InfoWindow(
                    title: widget.doctor.name,
                    snippet: location,
                  ),
                ),
              },
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not show location: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showPatientDialog() {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date first')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => PatientDialog(
        selectedDate: _selectedDate!,
        doctorId: widget.doctor.id,
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment booked successfully!')),
          );
        },
        doctor: widget.doctor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstDestination = widget.doctor.destinations.isNotEmpty
        ? widget.doctor.destinations.first
        : null;
    final availableDestination =
        firstDestination?['destination'] ?? 'Not specified';
    final List<String> availableDays = widget.doctor.destinations.isNotEmpty
        ? List<String>.from(widget.doctor.destinations.first['days'] ?? [])
        : [];
    final availableTimes = widget.doctor.destinations.isNotEmpty
        ? widget.doctor.destinations.first['timeSlots']?.map<String>((slot) {
              return '${slot['from']} - ${slot['to']}';
            }).toList() ??
            []
        : [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.color1,
        title: const Text("Doctor Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.doctor.imageUrl),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "${widget.doctor.experience} years of experience",
                  style: TextStyle(
                      color: Colors.white,
                      backgroundColor: AppColors.color1,
                      fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),
              const Text("Name",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(
                "Dr. ${widget.doctor.name}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                  "Rating                                                              Price",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Row(
                children: [
                  Row(
                    children: [
                      Text(widget.doctor.rating.toString()),
                      const Icon(Icons.star, color: Colors.yellow),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '${widget.doctor.price} EGP',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.color1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text("Description",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(
                widget.doctor.description,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              const Text("Clinic Location",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(
                availableDestination,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              const Text("Available Days",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: availableDays.map<Widget>((day) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ChoiceChip(
                        label: Text(day),
                        selected: _selectedDay == day,
                        onSelected: (selected) {
                          setState(() {
                            _selectedDay = selected ? day : null;
                          });
                        },
                        selectedColor: AppColors.color1,
                        labelStyle: TextStyle(
                          color:
                              _selectedDay == day ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Select Date",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              WorkDateTimeline(
                workDays: availableDays,
                onDateChange: (DateTime date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                initialSelectedDate: DateTime.now(),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Available Time Slots",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: availableTimes
                          .map<Widget>((time) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Chip(label: Text(time)),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              userId: widget.doctor.userId,
                              userName: widget.doctor.name,
                            ),
                          ),
                        );
                      },
                      child: const Text("Chat with doctor"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.color1,
                      ),
                      onPressed: _showPatientDialog,
                      child: const Text(
                        "Book Now",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.color1,
        onPressed: _showLocationOnMap,
        child: const Icon(Icons.map, color: Colors.white),
      ),
    );
  }
}
