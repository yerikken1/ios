import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class EmptyCatalog extends StatelessWidget {
  final VoidCallback onReset;

  const EmptyCatalog({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 56,
            color: AppColors.muted,
          ),
          const SizedBox(height: 16),
          const Text(
            'Catalog is Empty',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'You swiped everything away.',
            style: TextStyle(fontSize: 14, color: AppColors.muted),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: onReset, child: const Text('Reset Catalog')),
        ],
      ),
    );
  }
}
