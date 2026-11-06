import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/cart_badge.dart';
import '../widgets/product_icon.dart';

/// Screen 2: selected products, per-item removal, total and "Clear All".
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _confirmClear(BuildContext context) async {
    final cart = context.read<CartProvider>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        title: const Text('Clear cart?'),
        content: const Text('All selected products will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const Key('confirmClear'),
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true) cart.clear();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          // Same live badge: updates instantly when items are removed here.
          CartBadge(onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: cart.isEmpty
          ? const _EmptyCart()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: cart.itemCount,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _CartItemTile(product: cart.items[i]),
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : _CartSummary(
              total: cart.totalPrice,
              count: cart.itemCount,
              onClear: () => _confirmClear(context),
            ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final Product product;

  const _CartItemTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: ProductIcon(icon: product.icon, size: 46),
        title: Text(
          product.name,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            color: AppColors.red,
            fontWeight: FontWeight.w700,
          ),
        ),
        trailing: IconButton(
          key: Key('remove_${product.id}'),
          tooltip: 'Remove',
          icon: const Icon(Icons.delete_outline, color: AppColors.burgundy),
          onPressed: () {
            context.read<CartProvider>().remove(product);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('${product.name} removed')),
              );
          },
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final double total;
  final int count;
  final VoidCallback onClear;

  const _CartSummary({
    required this.total,
    required this.count,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final itemsLabel = count == 1 ? 'item' : 'items';
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: const BoxDecoration(
        color: AppColors.burgundy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total ($count $itemsLabel)',
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    key: const Key('cartTotal'),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              key: const Key('clearAll'),
              onPressed: onClear,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.red,
                shape: const StadiumBorder(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
              icon: const Icon(Icons.delete_sweep_outlined),
              label: const Text(
                'Clear All',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.redLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.remove_shopping_cart_outlined,
                size: 56,
                color: AppColors.burgundy,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Go back to the catalog and add some products.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.red,
                shape: const StadiumBorder(),
              ),
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('Back to Catalog'),
            ),
          ],
        ),
      ),
    );
  }
}
