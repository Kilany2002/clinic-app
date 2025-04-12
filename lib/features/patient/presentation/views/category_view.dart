import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/widgets/custom_app_bar.dart';
import 'package:clinicc/features/home/data/model/category_service.dart';
import 'package:clinicc/features/patient/presentation/widgets/categry_specialist_card.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Category',
          showBackArrow: true,
          actions: [
            IconButton(
                onPressed: () {},
                icon:
                    const Icon(Icons.search, size: 30, color: AppColors.white)),
          ],
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
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

            return Padding(
              padding: const EdgeInsets.all(15),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final item = categories[index];

                  return CategrySpecialistCard(
                    imageUrl: item['image'] ?? '',
                    titleCat: item['name'] ?? 'Unknown',
                    categoryId: item['id'] ?? 0,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
