import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightFromScheme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.light,
    );
  }

  static ThemeData darkFromScheme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.dark,
    );
  }

  static ThemeData lightFallback() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF1565C0),
      brightness: Brightness.light,
    );
  }

  static ThemeData darkFallback() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF1565C0),
      brightness: Brightness.dark,
    );
  }
}
