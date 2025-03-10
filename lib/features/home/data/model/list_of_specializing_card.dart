import 'package:clinicc/core/utils/colors.dart';
import 'package:flutter/material.dart';

// ✅ قائمة التخصصات
final List<String> specializations = [
  'جراحة عامة',
  'طب الأطفال',
  'أمراض القلب',
  'طب الأسنان',
  'الطب النفسي',
  'الأمراض الجلدية'
];

final List<Color> colors = [
  AppColors.color1,
  AppColors.color2,
  AppColors.redColor,
];

final List<Map<String, dynamic>> specializationsList = List.generate(
  specializations.length,
  (index) => {
    'title': specializations[index],
    'color': colors[index % colors.length],
  },
);
