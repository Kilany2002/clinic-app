import 'package:flutter/material.dart';
import 'package:clinicc/features/doctor/services/doctor_service.dart';
import 'package:intl/intl.dart';

class DoctorProvider with ChangeNotifier {
  final DoctorService _doctorService = DoctorService();

  String? _doctorName;
  List<String> _workDays = [];
  Map<DateTime, List<Map<String, dynamic>>> _patientsByDate = {};
  DateTime? _selectedDate;

  String? get doctorName => _doctorName;
  List<String> get workDays => _workDays;
  Map<DateTime, List<Map<String, dynamic>>> get patientsByDate =>
      _patientsByDate;
  DateTime? get selectedDate => _selectedDate;

  Future<void> fetchDoctorData() async {
    try {
      final doctorData = await _doctorService.fetchDoctorData();
      if (doctorData != null) {
        _doctorName = doctorData['name'] ?? 'Unknown Doctor';
        _workDays = doctorData['destinations'] != null
            ? doctorData['destinations']
                .expand<String>((destination) => destination['days'] != null
                    ? (destination['days'] as List<dynamic>).cast<String>()
                    : <String>[])
                .toSet()
                .toList()
            : [];

        if (_workDays.isNotEmpty) {
          _selectedDate = _findNextWorkDate(DateTime.now());
          await fetchPatientsForDate(_selectedDate!);
        }
      } else {
        _doctorName = 'Unknown Doctor';
        _workDays = [];
      }
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to fetch doctor data: $e");
    }
  }

  Future<void> fetchPatientsForDate(DateTime date) async {
    try {
      final patients = await _doctorService.fetchPatientsForDate(date);
      _patientsByDate[date] = patients;
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to fetch patients for date: $e");
    }
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    fetchPatientsForDate(date);
    notifyListeners();
  }

  DateTime _findNextWorkDate(DateTime fromDate) {
    while (true) {
      String dayName = DateFormat('EEEE').format(fromDate);
      if (_workDays.contains(dayName)) {
        return fromDate;
      }
      fromDate = fromDate.add(const Duration(days: 1));
    }
  }
}
