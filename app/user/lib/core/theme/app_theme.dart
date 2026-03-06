import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightFromScheme(ColorScheme scheme) {
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      brightness: Brightness.light,
    );
  }

  static ThemeData darkFromScheme(ColorScheme scheme) {
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      brightness: Brightness.dark,
    );
  }

  static ThemeData lightFallback() => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
        useMaterial3: true,
      );

  static ThemeData darkFallback() => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown, brightness: Brightness.dark),
        useMaterial3: true,
      );
}
