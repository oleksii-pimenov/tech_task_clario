import 'package:flutter/material.dart';

class AppColors {
  // Base colors
  static const green = Color(0xFF27B274);
  static const lightGreen = Color(0xFFEFFBF9);
  static const red = Color(0xFFFF8080);
  static const lightRed = Color(0xFFFDEFEE);
  static const darkViolet = Color(0xFF151D51);
  static const grey = Color(0xFFD0D2DC);
  static const lightGrey = Color(0xFFE8E8EE);
  static const white = Colors.white;

  static const lightBlue = Color(0xFF70C3FF);
  static const darkBlue = Color(0xFF4B65FF);

  static const gradientTop = Color(0xFFF4F9FF);
  static const gradientBottom = Color(0xFFE0EDFB);

  // Themed colors
  static const textField = TextField();
  static const error = Error();
  static const success = Success();
}

class TextField {
  const TextField();

  final enabledBorder = const Color.fromRGBO(21, 29, 81, 0.2);
  final enabledFont = const Color.fromRGBO(21, 29, 81, 1);
  final enabledBackground = AppColors.white;

  final disabledBorder = const Color.fromRGBO(21, 29, 81, 0.2);
  final disabledFont = const Color.fromRGBO(21, 29, 81, 0.2);
  final disabledBackground = const Color.fromRGBO(21, 29, 81, 0.2);

  final focusedBorder = AppColors.darkViolet;
  final focusedFont = const Color.fromRGBO(21, 29, 81, 1);
  final focusedBackground = AppColors.white;
}

class Error {
  const Error();

  final border = AppColors.red;
  final font = AppColors.red;
  final background = AppColors.lightRed;
}

class Success {
  const Success();

  final border = AppColors.green;
  final font = AppColors.green;
  final background = AppColors.lightGreen;
}
