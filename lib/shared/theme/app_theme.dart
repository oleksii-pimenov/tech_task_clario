import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4A4E71),
          ),
        ),
      );
}
