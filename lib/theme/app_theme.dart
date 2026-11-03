import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFFFFFAF3);
  static const green = Color(0xFF0F9D9A);
  static const darkGreen = Color(0xFF164E63);
  static const softGreen = Color(0xFFE2F5F2);
  static const muted = Color(0xFF71858A);
  static const white = Colors.white;
  static const border = Color(0xFFDDEBE7);
  static const navy = Color(0xFF256B80);
  static const gold = Color(0xFFF4C66A);
  static const red = Color(0xFFD97770);
}

abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.green,
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
