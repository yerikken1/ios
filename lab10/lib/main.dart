import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/product_list_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const CloudProductExplorerApp(),
    ),
  );
}

class CloudProductExplorerApp extends StatelessWidget {
  const CloudProductExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product explorer',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const ProductListScreen(),
    );
  }
}
