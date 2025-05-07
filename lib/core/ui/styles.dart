import 'package:flutter/material.dart';

abstract class AppStyles {
  ///colors
  static const Color primaryColor = Color(0xFFEFEFF4);
  static const Color secondaryColor = Color(0xFF676767);
  static const Color backgroundColor = Color(0xFFFCFDFF);
  static const Color blackColor = Color(0xFF090909);
  static const Color red = Color(0xFFE08E68);
  static const Color yellow = Color(0xFFF3D068);
  static const Color lightYellow = Color(0xFFFEFBDB);
  static const Color blue = Color(0xFF1669C4);
  static const Color siren = Color(0xFF90A1C6);
  static const Color textField = Color(0xFFF5F5F5);
  static const Color waterBlue = Color(0xFF76CFC6);
  static const Color lightBlue = Color(0xFFCEE5EE);
  static const Color lightPink = Color(0xFFF2EAFC);
  static const Color lighGreen = Color(0xFFB9ECE7);

  ///Text styles
  static const textStyleAbhaya = TextStyle(
    fontFamily: 'AbhayaLibre',
    fontSize: 36,
    // fontWeight: FontWeight.bold,
  );

  static const textStyleSoFoSans = TextStyle(
    fontFamily: 'CoFoSans',
    fontSize: 17,
    color: AppStyles.blackColor,
  );

  ///Buttons and element styles
  static const borderRadius = 8.0;
  static const paddingMain = 8.0;
  static const pictureLength = 325.0;
}
