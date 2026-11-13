import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/product.dart';
import '../theme/app_colors.dart';

void showShareSheet(BuildContext context, Product product) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => ShareSheet(product: product),
  );
}

class ShareSheet extends StatelessWidget {
  final Product product;
  const ShareSheet({super.key, required this.product});

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: product.deepLink));
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      const SnackBar(content: Text('Deep link copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Share product',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            const Text('Deep Link',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.burgundy)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.only(left: 14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.redLight),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link, color: AppColors.burgundy),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SelectableText(
                      product.deepLink,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copy',
                    icon: const Icon(Icons.copy_rounded, color: AppColors.red),
                    onPressed: () => _copy(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _copy(context),
                icon: const Icon(Icons.copy_all_rounded),
                label: const Text('Copy Link'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.burgundy,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
