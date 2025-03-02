import 'package:clinicc/features/category/data/model/doctor_category_list.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: Colors.blue,
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
                    backgroundColor: Colors.blue,
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
              style: TextStyle(color: Colors.blue, fontSize: 16),
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
                    onPressed: () {},
                    child: Text("Send Message"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
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
