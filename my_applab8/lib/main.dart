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
      title: 'Smart catalog',
      theme: ThemeData(
        fontFamily: 'Onest',
        scaffoldBackgroundColor: AppColors.paper,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          primary: AppColors.ink,
          surface: AppColors.paper,
          onSurface: AppColors.ink,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.paper,
          foregroundColor: AppColors.ink,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Onest',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.ink,
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.ink,
          actionTextColor: Color(0xFFFF9B73),
          contentTextStyle: TextStyle(
            fontFamily: 'Onest',
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
      home: const CatalogScreen(),
    );
  }
}
