import 'package:clinicc/core/widgets/custom_app_bar.dart';
import 'package:clinicc/features/patient/data/model/history_service.dart';
import 'package:flutter/material.dart';
import 'widgets/history_card.dart';

class HistoryDetailsScreen extends StatefulWidget {
  const HistoryDetailsScreen({Key? key}) : super(key: key);

  @override
  State<HistoryDetailsScreen> createState() => _HistoryDetailsScreenState();
}

class _HistoryDetailsScreenState extends State<HistoryDetailsScreen> {
  List<Map<String, dynamic>> historyList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    final data = await HistoryService.getBookingHistory();
    setState(() {
      historyList = data;
      isLoading = false;
    });
  }

  void deleteAppointment(int index) async {
    final historyId = historyList[index]['id'];
    final success =
        await HistoryService.deleteHistoryRecord(historyId, context);
    if (success) {
      setState(() {
        historyList.removeAt(index);
      });
    }
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : historyList.isEmpty
              ? const Center(child: Text("No history available."))
              : ListView.builder(
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    final item = historyList[index];
                    final doctorName = item['doctor_name'] ?? '';
                    final dateTime = DateTime.parse(item['date']);
                    final date =
                        "${dateTime.day} ${_monthAbbreviation(dateTime.month)}";
                    final time = "${_formatTime(dateTime)}";
                    final imageUrl = item['doctor_image_url'] ?? '';

                    return HistoryCard(
                      doctorName: "Dr: $doctorName",
                      date: date,
                      time: time,
                      imageUrl: imageUrl,
                      onDelete: () => deleteAppointment(index),
                    );
                  },
                ),
    );
  }

  String _monthAbbreviation(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }
}
