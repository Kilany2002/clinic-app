import 'package:clinicc/features/doctor/logic/doctor_service.dart';
import 'package:flutter/material.dart';
import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';
import 'package:clinicc/features/home/data/model/patient_service.dart';
import 'package:clinicc/features/home/presentation/views/widgets/app_bar.dart';
import 'package:clinicc/features/home/presentation/views/widgets/search_bar_widget.dart';
import 'package:clinicc/features/home/presentation/views/widgets/specialization_card.dart';
import 'package:clinicc/features/home/presentation/views/widgets/doctor_card.dart';
import 'package:gap/gap.dart';

class PatientHomeView extends StatefulWidget {
  const PatientHomeView({super.key});

  @override
  State<PatientHomeView> createState() => _PatientHomeViewState();
}

class _PatientHomeViewState extends State<PatientHomeView> {
  final PatientService patientService = PatientService();
  final DoctorService doctorService = DoctorService();
  TextEditingController searchController = TextEditingController();
  Future<String?>? userDataFuture;
  Future<List<Map<String, dynamic>>>? doctorsFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture =
        patientService.fetchUserName(); 
    doctorsFuture = doctorService.fetchAllDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60), child: AppBarr()),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String?>(
                future: userDataFuture,
                builder: (context, snapshot) {
                  print("📢 FutureBuilder State: ${snapshot.connectionState}");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    print("❌ Error: ${snapshot.error}");
                    return Text('Error fetching name', style: getbodyStyle());
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    print("❌ No data, showing default");
                    return const Text('Hello, Patient');
                  }

                  print("✅ Displaying name: ${snapshot.data}");
                  return Row(
                    children: [
                      Text(
                        'Hello, ',
                        style: getTitleStyle(color: AppColors.black),
                      ),
                      Text(
                        snapshot.data!,
                        style: getTitleStyle(),
                      ),
                    ],
                  );
                },
              ),
              const Gap(10),
              Text(
                "Book now and be a part of your health journey.",
                textAlign: TextAlign.start,
                style: getTitleStyle(color: AppColors.black, fontSize: 20),
              ),
              const Gap(10),
              SearchBarWidget(
                suffixIcon: FloatingActionButton(
                  backgroundColor: AppColors.color1,
                  onPressed: () {},
                  child: const Icon(
                    Icons.search,
                    color: AppColors.white,
                  ),
                ),
                searchController: searchController,
                text: "Search.",
              ),
              const Gap(10),
              Align(
                  alignment: Alignment.centerLeft,
                  child:
                      Text("Specialties", style: getTitleStyle(fontSize: 20))),
              const Gap(10),
              const SpecializationCard(),
              const Gap(10),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Doctors", style: getTitleStyle(fontSize: 20))),
              const Gap(10),
              SizedBox(
                height: 270,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: doctorsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No doctors available');
                    }

                    final doctors = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: DoctorCard(
                            imageUrl: doctors[index]["image_url"],
                            name: doctors[index]["name"],
                            rating: 4.5,
                            experience: doctors[index]["experience"] as int,
                            price: doctors[index]["price"] as double,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
