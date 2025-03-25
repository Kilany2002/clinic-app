import 'package:clinicc/core/utils/colors.dart';
import 'package:flutter/material.dart';

TextStyle getHeadlineTextStyle(
    {double fontSize = 24, fontWeight = FontWeight.bold, Color? color}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? AppColors.color1,
  );
}

TextStyle getSubTitleStyle(
    {Color color = Colors.black54, double fontSize = 14}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
  );
}

TextStyle getTitleStyle(
    {double fontSize = 18, fontWeight = FontWeight.bold, Color? color}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? AppColors.color1,
  );
}

TextStyle getbodyStyle(
    {double fontSize = 16, fontWeight = FontWeight.normal, Color? color}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? AppColors.black,
  );
}
// small

TextStyle getSmallStyle(
    {double fontSize = 14, fontWeight = FontWeight.normal, Color? color}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? AppColors.black,
  );
}
