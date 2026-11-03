import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFFFFF7F5);
  static const green = Color(0xFFC24D78);
  static const darkGreen = Color(0xFF54283D);
  static const softGreen = Color(0xFFFCE8EF);
  static const muted = Color(0xFF927985);
  static const white = Colors.white;
  static const border = Color(0xFFF1DDE4);
  static const navy = Color(0xFFA83F6A);
  static const gold = Color(0xFFE8A64A);
  static const red = Color(0xFFD95C70);
}

abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFC24D78),
      brightness: Brightness.light,
      surface: AppColors.white,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Arial',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.darkGreen,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
