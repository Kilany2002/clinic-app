import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';
import 'package:clinicc/features/doctor/home/widget/doctor_greeting.dart';
import 'package:clinicc/features/doctor/home/widget/quick_actions.dart';
import 'package:clinicc/features/doctor/home/widget/stat_card.dart';
import 'package:clinicc/features/doctor/home/widget/patient_list.dart';
import 'package:clinicc/features/doctor/home/widget/work_date_timeline.dart';
import 'package:clinicc/features/doctor/provider/doctor_provider.dart';
import 'package:clinicc/features/home/presentation/views/widgets/app_bar.dart';

Widget skeletonLoader({double width = double.infinity, double height = 20}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

class DoctorHomeView extends StatefulWidget {
  const DoctorHomeView({super.key});

  @override
  State<DoctorHomeView> createState() => _DoctorHomeViewState();
}

class _DoctorHomeViewState extends State<DoctorHomeView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DoctorProvider()..fetchDoctorData(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBarr(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Consumer<DoctorProvider>(
            builder: (context, doctorProvider, child) {
              if (doctorProvider.doctorName == null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    skeletonLoader(width: 200, height: 20),
                    const SizedBox(height: 20),
                    skeletonLoader(width: double.infinity, height: 50),
                    const SizedBox(height: 20),
                    skeletonLoader(width: double.infinity, height: 100),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoctorGreeting(doctorName: doctorProvider.doctorName),

                  if (doctorProvider.workDays.isNotEmpty)
                    WorkDateTimeline(
                      workDays: doctorProvider.workDays,
                      onDateChange: (date) {
                        doctorProvider.setSelectedDate(date);
                      },
                    ),
                  const SizedBox(height: 20),
                  if (doctorProvider.selectedDate != null)
                    Row(
                      children: [
                        QuickActions(
                          selectedDate: doctorProvider.selectedDate!,
                          refreshPatients: () =>
                              doctorProvider.fetchPatientsForDate(
                                  doctorProvider.selectedDate!),
                        ),
                        const Spacer(),
                        StatCard(
                          title: 'Total Patients',
                          value: (doctorProvider
                                      .patientsByDate[
                                          doctorProvider.selectedDate]
                                      ?.length ??
                                  0)
                              .toString(),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  if (doctorProvider.selectedDate != null)
                    Text('Patients by Date', style: getTitleStyle()),

                  const SizedBox(height: 10),

                  if (doctorProvider.selectedDate == null ||
                      doctorProvider
                              .patientsByDate[doctorProvider.selectedDate] ==
                          null)
                    Column(
                      children: List.generate(
                          3,
                          (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: skeletonLoader(
                                    width: double.infinity, height: 80),
                              )),
                    )
                  else if (doctorProvider
                      .patientsByDate[doctorProvider.selectedDate]!.isEmpty)
                    const Center(child: Text("No patients for this date"))
                  else
                    Expanded(
                      child: PatientList(
                          patients: doctorProvider
                              .patientsByDate[doctorProvider.selectedDate]!),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
