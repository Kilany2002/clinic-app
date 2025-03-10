import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/functions/routing.dart';


class SpecializationView extends StatelessWidget {
  const SpecializationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.white,
            )),
        centerTitle: true,
        title: Text(
          'جراحة عامة',
          style: getTitleStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.color1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        // child:
        //  ListView.separated(
        //   itemCount: 2,
        //   itemBuilder: (context, index) {
        //     return DoctorRateCard();
        //   },
        //   separatorBuilder: (BuildContext context, int index) {
        //     return Container(
        //       margin: EdgeInsets.all(10),
        //     );
        //   },
        // ),
      ),
    );
  }
}
