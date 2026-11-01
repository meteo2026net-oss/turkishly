import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFFF7F5EF);
  static const green = Color(0xFF31805C);
  static const darkGreen = Color(0xFF203B30);
  static const softGreen = Color(0xFFDDECE0);
  static const muted = Color(0xFF7B867F);
  static const white = Colors.white;
  static const border = Color(0xFFE9E7DF);
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
