import 'package:clinicc/features/doctor/logic/doctor_service.dart';
import 'package:clinicc/features/patient/data/model/doctor_category_list.dart';
import 'package:flutter/material.dart';
import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';
import 'package:clinicc/core/functions/routing.dart';

class SpecializationView extends StatefulWidget {
  final String categoryName;
  final int categoryId;

  const SpecializationView({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  _SpecializationViewState createState() => _SpecializationViewState();
}

class _SpecializationViewState extends State<SpecializationView> {
  final DoctorService doctorService = DoctorService();
  late Future<List<Doctor>> doctorsFuture;

  @override
  void initState() {
    super.initState();
    doctorsFuture = doctorService.fetchDoctorsByCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
        centerTitle: true,
        title: Text(
          widget.categoryName,
          style: getTitleStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.color1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Doctor>>(
          future: doctorsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('No doctors available in this category.'));
            }

            final doctors = snapshot.data!;
            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];

                return GestureDetector(
                  onTap: () {
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.color1,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            doctor.imageUrl.isNotEmpty
                                ? doctor.imageUrl
                                : 'https://cdn.pixabay.com/photo/2022/06/09/04/51/robot-7251710_1280.png',
                            width: 100,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctor.name,
                                style: getTitleStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                doctor.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.yellow, size: 25),
                                  Text(
                                    doctor.rating != null
                                        ? doctor.rating.toString()
                                        : "N/A",
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ],
                              ),
                              Text(
                                "Price: \$${doctor.price != null ? doctor.price.toString() : 'N/A'}",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
