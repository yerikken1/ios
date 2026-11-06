import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_colors.dart';

class DismissibleProduct extends StatelessWidget {
  final Product product;
  final VoidCallback onDismissed;
  final Widget child;
  final double borderRadius;

  const DismissibleProduct({
    super.key,
    required this.product,
    required this.onDismissed,
    required this.child,
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: AppColors.burgundy,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: const Icon(Icons.delete, color: AppColors.white),
      ),
      onDismissed: (_) => onDismissed(),
      child: child,
    );
  }
}
