import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/features/patient/data/model/doctor_category_list.dart';
import 'package:flutter/material.dart';
import 'package:pay_with_paymob/pay_with_paymob.dart';

class DoctorProfileCat extends StatelessWidget {
  final Doctor doctor;

  DoctorProfileCat({required this.doctor});

  final List<String> availableDates = [
    "8 MAR",
    "9 MAR",
    "10 MAR",
    "11 MAR",
    "12 MAR"
  ];
  final List<String> availableTimes = ["8:00", "11:00", "13:30", "18:00"];

  @override
  Widget build(BuildContext context) {
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
            Text(
              doctor.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              doctor.specialty,
              style: TextStyle(color: AppColors.color1, fontSize: 16),
            ),
            Row(
              children: [
                Icon(Icons.star, color: Colors.yellow),
                Text(doctor.rating.toString()),
              ],
            ),
            SizedBox(height: 10),
            Text(
              doctor.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 10),
            Text("Book a Date",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: availableDates
                    .map((date) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Chip(label: Text(date)),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 10),
            Text("Select a Time",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: availableTimes
                    .map((time) => Padding(
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
                      Navigator.pushNamed(context, 'ChatView',
                          arguments: doctor);
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
    );
  }
}
