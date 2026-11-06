import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/product_data.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/cart_badge.dart';
import '../widgets/product_icon.dart';
import 'cart_screen.dart';

/// Screen 1: catalog of 6 products with "Add to Cart" toggles.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  void _openCart(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
        actions: [
          CartBadge(onPressed: () => _openCart(context)),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: kProducts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, index) => _ProductCard(product: kProducts[index]),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    // Rebuild only when this product's in-cart state changes.
    final inCart = context.select<CartProvider, bool>(
      (cart) => cart.contains(product),
    );

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            ProductIcon(icon: product.icon),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _CartToggle(product: product, inCart: inCart),
          ],
        ),
      ),
    );
  }
}

class _CartToggle extends StatelessWidget {
  final Product product;
  final bool inCart;

  const _CartToggle({required this.product, required this.inCart});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: inCart
          ? OutlinedButton.icon(
              key: Key('toggle_${product.id}_added'),
              onPressed: () => cart.toggle(product),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.burgundy,
                side: const BorderSide(color: AppColors.burgundy, width: 1.5),
                shape: const StadiumBorder(),
              ),
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Added'),
            )
          : FilledButton.icon(
              key: Key('toggle_${product.id}_add'),
              onPressed: () => cart.toggle(product),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: AppColors.white,
                shape: const StadiumBorder(),
              ),
              icon: const Icon(Icons.add_shopping_cart, size: 18),
              label: const Text('Add'),
            ),
    );
  }
}
