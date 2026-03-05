import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0B0B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00C2FF),
          brightness: Brightness.dark,
        ),
      );
}
