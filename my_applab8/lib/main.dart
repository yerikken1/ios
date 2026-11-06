import 'package:flutter/material.dart';

import 'screens/catalog_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const SmartCatalogApp());
}

class SmartCatalogApp extends StatelessWidget {
  const SmartCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catalog-everything you need!',
      theme: ThemeData(
        fontFamily: 'Onest',
        scaffoldBackgroundColor: AppColors.paper,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.burgundy,
          primary: AppColors.burgundy,
          secondary: AppColors.red,
          surface: AppColors.paper,
          onSurface: AppColors.ink,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.burgundy,
          foregroundColor: AppColors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Onest',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.white,
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.burgundyDark,
          actionTextColor: AppColors.redLight,
          contentTextStyle: TextStyle(
            fontFamily: 'Onest',
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.red,
            foregroundColor: AppColors.white,
            shape: const StadiumBorder(),
          ),
        ),
      ),
      home: const CatalogScreen(),
    );
  }
}
