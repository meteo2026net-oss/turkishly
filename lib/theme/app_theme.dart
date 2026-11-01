import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFFF7F8FC);
  static const green = Color(0xFF1766B1);
  static const darkGreen = Color(0xFF102B52);
  static const softGreen = Color(0xFFE8F0FB);
  static const muted = Color(0xFF78869A);
  static const white = Colors.white;
  static const border = Color(0xFFE4EAF2);
  static const navy = Color(0xFF082B63);
  static const gold = Color(0xFFE7B64B);
  static const red = Color(0xFFE33445);
}

abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.navy,
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
