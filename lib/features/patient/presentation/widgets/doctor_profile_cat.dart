import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/widgets/custom_app_bar.dart';
import 'package:clinicc/features/messages/chat_screen.dart';
import 'package:clinicc/features/patient/data/model/doctor_category_list.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pay_with_paymob/pay_with_paymob.dart';

class DoctorProfileCat extends StatelessWidget {
  final Doctor doctor;

  DoctorProfileCat({required this.doctor});
  Future<void> _showLocationOnMap(BuildContext context) async {
    // Get the first destination's location (you can modify this to show all locations)
    final location = doctor.destinations.isNotEmpty
        ? doctor.destinations.first['location']
        : null;

    if (location == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No location available for this doctor'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Convert address to coordinates
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
              title: ('Doctor Location'),
              showBackArrow: true,
            ),
            body: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: doctorLocation,
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('doctorLocation'),
                  position: doctorLocation,
                  infoWindow: InfoWindow(
                    title: doctor.name,
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

  @override
  Widget build(BuildContext context) {
    final firstDestination =
        doctor.destinations.isNotEmpty ? doctor.destinations.first : null;
    final availableDestination =
        firstDestination?['destination'] ?? 'Not specified';
    final availableDays = doctor.destinations.isNotEmpty
        ? doctor.destinations.first['days'] ?? []
        : [];
    final availableTimes = doctor.destinations.isNotEmpty
        ? doctor.destinations.first['timeSlots']?.map<String>((slot) {
              return '${slot['from']} - ${slot['to']}';
            }).toList() ??
            []
        : [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.color1,
        title: Text("Doctor Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(doctor.imageUrl),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "${doctor.experience} years of experience",
                style: TextStyle(
                    color: Colors.white,
                    backgroundColor: AppColors.color1,
                    fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
            Text("Name",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(
              "Dr,${doctor.name}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
                "Rating                                                              Price",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Row(
              children: [
                // Rating
                Row(
                  children: [
                    Text(doctor.rating.toString()),
                    Icon(Icons.star, color: Colors.yellow),
                  ],
                ),
                Spacer(), //
                Row(
                  children: [
                    Text(
                      '${doctor.price} EGP',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.color1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text("Description",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              doctor.description,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 10),
            Text("Clinic Location",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(
              availableDestination,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 10),
            Text("Available Days",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: availableDays
                    .map<Widget>((day) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Chip(label: Text(day)),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 10),
            Text("Available Time Slots",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: availableTimes
                    .map<Widget>((time) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Chip(label: Text(time)),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            userId: doctor.userId,
                            userName: doctor.name,
                          ),
                        ),
                      );
                    },
                    child: Text("Chat with doctor"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.color1,
                    ),
                    onPressed: () {
                      // Initialize payment data
                      PaymentData.initialize(
                        apiKey:
                            "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2T1RnMU56azNMQ0p1WVcxbElqb2lNVGN5TkRFNE56ZzFOaTQxT1RBeU56TWlmUS44Z0RXdTAxNnk5MGt0QkZ2Z2tfNzFGRVpTQktWeFVBZUpZZUs3WU9MRXNQcmRDRWVLbTFVUEluRk93Um90QlVpdlFycEFHcFkzTFEzY3liNC0yaE9ZUQ==",
                        integrationCardId: "4612972",
                        integrationMobileWalletId: "4612975",
                        iframeId: "856699",
                        //    userData: UserData(
                        //    email: "user@example.com", // Replace with user email
                        //  phone: "1234567890", // Replace with user phone
                        //name: "John", // Replace with user first name
                        //  lastName: "Doe", // Replace with user last name
                        // ),
                        style: Style(
                          primaryColor: Colors.blue,
                          scaffoldColor: Colors.white,
                          appBarBackgroundColor: Colors.blue,
                          appBarForegroundColor: Colors.white,
                          textStyle: TextStyle(),
                          buttonStyle: ElevatedButton.styleFrom(),
                          circleProgressColor: Colors.blue,
                          unselectedColor: Colors.grey,
                        ),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentView(
                            onPaymentSuccess: () {
                              // Handle payment success
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Payment successful!")),
                              );
                            },
                            onPaymentError: () {
                              // Handle payment failure
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Payment failed. Please try again.")),
                              );
                            },
                            price: 100, // Replace with the actual price
                          ),
                        ),
                      );
                    },
                    child: Text("Book Now"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.color1,
        onPressed: () => _showLocationOnMap(context),
        child: Icon(Icons.map, color: Colors.white),
      ),
    );
  }
}
