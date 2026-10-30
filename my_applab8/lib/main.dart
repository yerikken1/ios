import 'package:flutter/material.dart';

import 'screens/catalog_screen.dart';

void main() {
  runApp(const SmartCatalogApp());
}

class SmartCatalogApp extends StatelessWidget {
  const SmartCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Catalog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF435744)),
      ),
      home: const CatalogScreen(),
    );
  }
}
