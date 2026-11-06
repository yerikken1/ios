import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/catalog_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(
    // The provider sits ABOVE MaterialApp, so every route
    // (Catalog and Cart) reads the same CartProvider instance.
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const CartApp(),
    ),
  );
}

class CartApp extends StatelessWidget {
  const CartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 9 Global Cart',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const CatalogScreen(),
    );
  }
}
