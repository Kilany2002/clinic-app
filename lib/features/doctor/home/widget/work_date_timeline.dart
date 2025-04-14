import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:intl/intl.dart';
import 'package:clinicc/core/utils/colors.dart';

class WorkDateTimeline extends StatelessWidget {
  final List<String> workDays;
  final Function(DateTime) onDateChange;

  const WorkDateTimeline({
    Key? key,
    required this.workDays,
    required this.onDateChange, DateTime? initialSelectedDate,
  }) : super(key: key);

  List<DateTime> _generateWorkDates() {
    DateTime today = DateTime.now();
    DateTime endDate = today.add(const Duration(days: 365));
    List<DateTime> workDates = [];

    while (today.isBefore(endDate)) {
      String dayName = DateFormat('EEEE').format(today);
      if (workDays.contains(dayName)) {
        workDates.add(today);
      }
      today = today.add(const Duration(days: 1));
    }
    return workDates;
  }

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: _generateWorkDates().isNotEmpty
          ? _generateWorkDates().first
          : DateTime.now(),
      activeColor: AppColors.color1,
      dayProps: EasyDayProps(
        width: 60,
        height: 80,
      ),
      onDateChange: onDateChange,
    );
  }
}