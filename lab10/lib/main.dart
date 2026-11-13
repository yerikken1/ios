import 'package:flutter/material.dart';

import 'screens/product_list_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const CloudProductExplorerApp());
}

class CloudProductExplorerApp extends StatelessWidget {
  const CloudProductExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloud Product Explorer',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const ProductListScreen(),
    );
  }
}
