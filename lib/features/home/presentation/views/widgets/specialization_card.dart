import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';
import 'package:clinicc/features/home/data/model/list_of_specializing_card.dart';
import 'package:clinicc/features/home/presentation/views/widgets/specialization_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/functions/routing.dart';

class SpecializationCard extends StatelessWidget {
  const SpecializationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: specializationsList.length,
        itemBuilder: (context, index) {
          final specialization = specializationsList[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                push(context, const SpecializationView());
              },
              child: Stack(
                children: [
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          offset: const Offset(5, 5),
                          color: AppColors.greyColor.withOpacity(0.5),
                        ),
                      ],
                      color: specialization['color'],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Positioned(
                    right: -30,
                    top: -40,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: AppColors.white.withOpacity(0.2),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    right: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       
                        const Gap(10),
                        Text(
                          specialization['title'],
                          style: getTitleStyle(
                              fontSize: 16, color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
