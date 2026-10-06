import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce Product',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
      ),
      home: const ProductPreviewScreen(),
    );
  }
}

class ProductPreviewScreen extends StatelessWidget {
  const ProductPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // ============================================================
      // STICKY BOTTOM ACTION BAR
      // ============================================================
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Expanded makes Add to Cart fill the available width.
              Expanded(
                child: SizedBox(
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product added to cart!'),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                    ),
                    label: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ============================================================
      // APP BAR
      // ============================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Product Preview',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      // ============================================================
      // PAGE CONTENT
      // ============================================================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 900,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image + bookmark
                  const ProductCover(),

                  const SizedBox(height: 20),

                  // Title + rating + price + categories
                  const ProductInformation(),

                  const SizedBox(height: 28),

                  // ======================================================
                  // DESCRIPTION
                  // ======================================================

                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'A stylish and versatile backpack designed for everyday '
                    'use. It features a spacious interior, comfortable '
                    'shoulder straps, and a water-resistant exterior. '
                    'Perfect for work, travel, school, or everyday adventures.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: Colors.grey.shade700,
                        ),
                  ),

                  const SizedBox(height: 28),

                  // ======================================================
                  // PRODUCT DETAILS
                  // ======================================================

                  Text(
                    'Product Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 14),

                  const ProductDetailRow(
                    icon: Icons.inventory_2_outlined,
                    title: 'Material',
                    value: 'Premium Polyester',
                  ),

                  const ProductDetailRow(
                    icon: Icons.straighten,
                    title: 'Dimensions',
                    value: '45 × 30 × 18 cm',
                  ),

                  const ProductDetailRow(
                    icon: Icons.water_drop_outlined,
                    title: 'Water Resistant',
                    value: 'Yes',
                  ),

                  const ProductDetailRow(
                    icon: Icons.local_shipping_outlined,
                    title: 'Shipping',
                    value: 'Free shipping',
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PRODUCT COVER
// ============================================================================

class ProductCover extends StatelessWidget {
  const ProductCover({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      // Original image is 768 × 1024.
      // Therefore the correct ratio is 3:4.
      aspectRatio: 3 / 4,

      child: Stack(
        fit: StackFit.expand,
        children: [
          // ------------------------------------------------------------------
          // PRODUCT IMAGE
          // ------------------------------------------------------------------

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              'https://cdn.sportmaster.ru/upload/mdm/media_content/resize/a21/768_1024_3cb0/191230430299.jpg',

              // Keeps the image filling the 3:4 area.
              fit: BoxFit.cover,

              // Fallback if the image cannot be loaded.
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 70,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),

          // ------------------------------------------------------------------
          // BOOKMARK BADGE
          // ------------------------------------------------------------------

          Positioned(
            top: 16,
            right: 16,
            child: Material(
              color: Colors.white,
              elevation: 4,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.bookmark_border,
                    size: 25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PRODUCT INFORMATION
// ============================================================================

class ProductInformation extends StatelessWidget {
  const ProductInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ------------------------------------------------------------------
        // TITLE + STAR RATING
        // ------------------------------------------------------------------

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flexible prevents the title from causing RenderFlex overflow.
            Flexible(
              child: Text(
                'Premium Everyday Backpack',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
              ),
            ),

            const SizedBox(width: 12),

            const RatingWidget(),
          ],
        ),

        const SizedBox(height: 14),

        // ------------------------------------------------------------------
        // PRICE
        // ------------------------------------------------------------------

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$129.99',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),

            const SizedBox(width: 10),

            Flexible(
              child: Text(
                '\$159.99',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // ------------------------------------------------------------------
        // CATEGORY BADGES
        // ------------------------------------------------------------------
        //
        // Wrap automatically moves badges to new lines on small screens.

        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            CategoryBadge(
              icon: Icons.backpack_outlined,
              label: 'Backpacks',
            ),
            CategoryBadge(
              icon: Icons.flight_takeoff_outlined,
              label: 'Travel',
            ),
            CategoryBadge(
              icon: Icons.water_drop_outlined,
              label: 'Water Resistant',
            ),
            CategoryBadge(
              icon: Icons.workspace_premium_outlined,
              label: 'Premium',
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// STAR RATING
// ============================================================================

class RatingWidget extends StatelessWidget {
  const RatingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: Colors.amber,
            size: 19,
          ),
          SizedBox(width: 4),
          Text(
            '4.8',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CATEGORY BADGE
// ============================================================================

class CategoryBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryBadge({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        icon,
        size: 17,
        color: Theme.of(context).colorScheme.primary,
      ),
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}

// ============================================================================
// PRODUCT DETAIL ROW
// ============================================================================

class ProductDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProductDetailRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Icon
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),

          const SizedBox(width: 12),

          // Title
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          // Flexible prevents long values from overflowing.
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}