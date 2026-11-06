import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProductIcon extends StatelessWidget {
  final IconData icon;
  final double size;

  const ProductIcon({super.key, required this.icon, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.red, AppColors.burgundy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(icon, color: AppColors.white, size: size * 0.5),
    );
  }
}
