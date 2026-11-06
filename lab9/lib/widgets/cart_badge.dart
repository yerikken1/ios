import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';

/// Cart icon with a live counter badge. Only this widget rebuilds when
/// the item count changes, thanks to [Selector].
class CartBadge extends StatelessWidget {
  final VoidCallback onPressed;

  const CartBadge({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Selector<CartProvider, int>(
      selector: (_, cart) => cart.itemCount,
      builder: (context, count, _) => IconButton(
        key: const Key('cartBadgeButton'),
        tooltip: 'Open cart',
        onPressed: onPressed,
        icon: Badge(
          isLabelVisible: count > 0,
          backgroundColor: AppColors.white,
          textColor: AppColors.red,
          label: Text(
            '$count',
            key: const Key('cartBadgeCount'),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          child: const Icon(Icons.shopping_cart_outlined),
        ),
      ),
    );
  }
}
