import 'package:clinicc/core/utils/text_style.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final String text;
  final Widget suffixIcon;
  const SearchBarWidget({
    super.key,
    required this.searchController, required this.text, required this.suffixIcon,
  });

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          style: getbodyStyle(),
          controller: searchController,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(25)),
              hintText: text,
              suffixIcon: suffixIcon),
        ));
  }
}
// 'ابحث عن دكتور'
// FloatingActionButton(
//                 backgroundColor: AppColors.primaryColor,
//                 onPressed: () {},
//                 child: const Icon(
//                   Icons.search,
//                   color: AppColors.whiteColor,
//                 ),
//               )