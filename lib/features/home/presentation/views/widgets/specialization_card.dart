import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';
import 'package:clinicc/features/home/data/model/category_service.dart';
import 'package:clinicc/features/home/presentation/views/widgets/specialization_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../core/functions/routing.dart';

class SpecializationCard extends StatelessWidget {
  const SpecializationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Color> cardColors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];
    return FutureBuilder(
      future: CategoryService().fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No categories found.'));
        }

        final categories = snapshot.data!;

        return SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    push(context,
                        SpecializationView(categoryName: category['name'], categoryId: category['id'],));
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
                          color: cardColors[index % cardColors.length],
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
                              category['name'],
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
      },
    );
  }
}
