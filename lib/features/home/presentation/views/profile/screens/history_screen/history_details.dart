import 'package:clinicc/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'widgets/history_card.dart';

class HistoryDetailsScreen extends StatefulWidget {
  const HistoryDetailsScreen({Key? key}) : super(key: key);

  @override
  State<HistoryDetailsScreen> createState() => _HistoryDetailsScreenState();
}

class _HistoryDetailsScreenState extends State<HistoryDetailsScreen> {
  List<Map<String, String>> appointments = [
    {
      "doctorName": "Dr: Osama Ali",
      "date": "9 MAR",
      "time": "11:00 AM",
      "imageUrl": "assets/images/sara 1.png"
    },
    {
      "doctorName": "Dr: Ahmed Mohamed",
      "date": "10 MAR",
      "time": "1:00 PM",
      "imageUrl": "assets/images/sara 1.png"
    }
  ];

  void deleteAppointment(int index) {
    setState(() {
      appointments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "History Details",
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final item = appointments[index];
          return HistoryCard(
            doctorName: item["doctorName"]!,
            date: item["date"]!,
            time: item["time"]!,
            imageUrl: item["imageUrl"]!,
            onDelete: () => deleteAppointment(index),
          );
        },
      ),
    );
  }
}
