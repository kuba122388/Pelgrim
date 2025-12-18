import 'package:flutter/material.dart';
import 'app_colors.dart';


abstract class AppStyles {
  AppStyles._();

  static const shadowText = Shadow(
    color: AppColors.loginShadow,
    offset: Offset(2, 4),
    blurRadius: 10,
  );

  static const containerShadow = BoxShadow(
    color: Color(0x40000000),
    blurRadius: 4,
    spreadRadius: 2,
    offset: Offset(0, 0),
  );

  static const Offset loginShadowOffset = Offset(2, 4);

  static const double FONT_SIZE_BIG = 18.0;
  static const double FONT_SIZE_MEDIUM = 16.0;
  static const double FONT_SIZE_SMALL = 14.0;
}