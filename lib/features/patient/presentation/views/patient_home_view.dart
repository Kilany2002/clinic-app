import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';
import 'package:clinicc/features/home/data/model/list_of_doctor_card_model.dart';
import 'package:clinicc/features/home/presentation/views/widgets/app_bar.dart';
import 'package:clinicc/features/home/presentation/views/widgets/search_bar_widget.dart';
import 'package:clinicc/features/home/presentation/views/widgets/specialization_card.dart';
import 'package:clinicc/features/home/presentation/views/widgets/doctor_card.dart'; // Import the DoctorCard
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const String id = 'HomeView';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController searchController = TextEditingController();

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
              Row(
                children: [
                  Text(
                    'Hello  ,',
                    style: getTitleStyle(color: AppColors.black),
                  ),
                  Text(
                    ' UserName',
                    style: getTitleStyle(),
                  )
                ],
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
                  text: "Search."),
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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DoctorCard(
                        imageUrl: doctors[index]["imageUrl"],
                        name: doctors[index]["name"],
                        rating: doctors[index]["rating"],
                        experience: doctors[index]["experience"],
                        price: doctors[index]["price"],
                      ),
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
