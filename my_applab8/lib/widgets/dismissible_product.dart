import 'package:flutter/material.dart';

import '../models/product.dart';

class DismissibleProduct extends StatelessWidget {
  final Product product;
  final VoidCallback onDismissed;
  final Widget child;

  const DismissibleProduct({
    super.key,
    required this.product,
    required this.onDismissed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDismissed(),
      child: child,
    );
  }
}
