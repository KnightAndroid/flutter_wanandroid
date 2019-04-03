import 'package:flutter/material.dart';
/**
 * Describe :
 * Created by Knight on 2019/3/24
 * @Version :
 * 点滴之行,看世界
 */




class ResColors {
  //黑色
  static const Color colorBack =  Color(0xFF000000);
  //白色
  static const Color colorWhite = Color(0xFFFFFFFF);
  //灰白色
  static const Color colorFFWhite = Color(0xFFEEEEEE);
  static const Color colorWhite10 = Color(0x1AFFFFFF);
  //红色
  static const Color colorRed = Color(0xFFF44336);
  //蓝色
  static const Color colorBlue = Color(0xFF2196F3);
  static const MaterialColor blue = MaterialColor(
    _bluePrimaryValue,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(_bluePrimaryValue),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );
  static const int _bluePrimaryValue = 0xFF2196F3;
  static const MaterialAccentColor colorBlueAccent = MaterialAccentColor(
    _blueAccentPrimaryValue,
    <int, Color>{
      100: Color(0xFF82B1FF),
      200: Color(_blueAccentPrimaryValue),
      400: Color(0xFF2979FF),
      700: Color(0xFF2962FF),
    },
  );
  static const int _blueAccentPrimaryValue = 0xFF448AFF;
  //灰色
  static const MaterialColor colorGrey = MaterialColor(
    _greyPrimaryValue,
    <int, Color>{
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFEEEEEE),
      300: Color(0xFFE0E0E0),
      350: Color(0xFFD6D6D6), // only for raised button while pressed in light theme
      400: Color(0xFFBDBDBD),
      500: Color(_greyPrimaryValue),
      600: Color(0xFF757575),
      700: Color(0xFF616161),
      800: Color(0xFF424242),
      850: Color(0xFF303030), // only for background color in dark theme
      900: Color(0xFF212121),
    },
  );
  static const int _greyPrimaryValue = 0xFF9E9E9E;

}
