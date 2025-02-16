import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/widgets/custom_app_bar.dart';
import 'package:clinicc/features/category/data/model/category_list.dart';
import 'package:clinicc/features/category/presentation/widgets/categry_specialist_card.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Category',
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  size: 30,
                  color: AppColors.white,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    final item = categoryList[index];

                    return CategrySpecialistCard(
                      imageUrl: item['imageUrl']!,
                      titleCat: item['titleCat']!,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
