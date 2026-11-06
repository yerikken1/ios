import 'package:flutter/material.dart';

/// Red / burgundy / white palette.
class AppColors {
  static const Color burgundy = Color(0xFF6D0F1F);
  static const Color burgundyDark = Color(0xFF4A0814);
  static const Color red = Color(0xFFC8102E);
  static const Color redLight = Color(0xFFF3D6DA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFF7F7);
  static const Color textDark = Color(0xFF2B0A10);
  static const Color textMuted = Color(0xFF8A5A62);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.burgundy,
    primary: AppColors.burgundy,
    secondary: AppColors.red,
    surface: AppColors.white,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.burgundy,
      foregroundColor: AppColors.white,
      centerTitle: false,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 2,
      shadowColor: AppColors.burgundy.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.burgundyDark,
      contentTextStyle: TextStyle(color: AppColors.white),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
