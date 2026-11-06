import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_colors.dart';
import 'category_tag.dart';
import 'star_rating.dart';

const TextStyle _titleStyle = TextStyle(
  fontSize: 14,
  height: 1.25,
  fontWeight: FontWeight.w600,
  color: AppColors.ink,
);

class ProductGridCard extends StatelessWidget {
  final Product product;

  const ProductGridCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: AppColors.burgundy.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The photo absorbs whatever height the 0.72 cell has left,
          // so the text below can never overflow the card.
          Expanded(
            child: Image.asset(
              product.image,
              cacheWidth: 500,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // The hidden two-line text keeps every card's photo the same
                // height, whether the title takes one line or two.
                Stack(
                  children: [
                    const Text('\n', style: _titleStyle),
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _titleStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: CategoryTag(category: product.category)),
                    const SizedBox(width: 6),
                    StarRating(rating: product.rating),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  product.formattedPrice,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
