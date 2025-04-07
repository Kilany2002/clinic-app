import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';
import 'package:clinicc/core/widgets/custom_app_bar.dart';

import 'package:clinicc/features/doctor/logic/doctor_service.dart';
import 'package:clinicc/features/patient/data/model/doctor_category_list.dart';
import 'package:clinicc/features/patient/presentation/widgets/category_doctor_card_widget.dart';
import 'package:clinicc/features/patient/presentation/widgets/doctor_profile_cat.dart';
import 'package:clinicc/features/patient/presentation/widgets/popular_doctors_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/functions/routing.dart';

class DoctorsCategoryView extends StatefulWidget {
  final int categoryId;

  const DoctorsCategoryView({super.key, required this.categoryId});

  @override
  _DoctorsCategoryViewState createState() => _DoctorsCategoryViewState();
}

class _DoctorsCategoryViewState extends State<DoctorsCategoryView> {
  bool isGridView = false;
  late Future<List<Doctor>> doctorsFuture;
  late Future<List<Doctor>> popularDoctorsFuture;
  final DoctorService doctorService = DoctorService();

  @override
  void initState() {
    super.initState();
    doctorsFuture = doctorService.fetchDoctorsByCategory(widget.categoryId);
    popularDoctorsFuture = doctorService.fetchPopularDoctors(widget.categoryId);
  }

  void toggleView() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Popular Doctor",
                      style: getTitleStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  FutureBuilder<List<Doctor>>(
                    future: popularDoctorsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return Center(child: Text('لا يوجد أطباء مشهورين'));
                      }
                      return SizedBox(
                        height: 190,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return PopularDoctorCard(snapshot.data![index]);
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 41),
                  Divider(
                    color: AppColors.greyColor,
                    thickness: 1,
                    endIndent: 20,
                    indent: 20,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text("Book a Doctor",
                          style: getTitleStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(
                              isGridView ? Icons.filter_list : Icons.grid_view,
                              color: AppColors.color1,
                              size: 30),
                          onPressed: toggleView,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Doctor>>(
                future: doctorsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return Center(child: Text('لا يوجد أطباء لهذه الفئة'));
                  }

                  final doctors = snapshot.data!;

                  return isGridView
                      ? GridView.builder(
                          padding: EdgeInsets.all(5),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: doctors.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                push(context,
                                    DoctorProfileCat(doctor: doctors[index]));
                              },
                              child: CategoryDoctorCardWidget(doctors[index]),
                            );
                          },
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(10),
                          itemCount: doctors.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                push(context,
                                    DoctorProfileCat(doctor: doctors[index]));
                              },
                              child: CategoryDoctorCardWidget(doctors[index]),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
