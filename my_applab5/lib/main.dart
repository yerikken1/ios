import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ============================================================================
// MAIN APP
// ============================================================================

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
      home: const PhoneFrame(
        child: ProductPreviewScreen(),
      ),
    );
  }
}

// ============================================================================
// PHONE FRAME
// Displays the app as a phone-sized screen inside Edge
// ============================================================================

class PhoneFrame extends StatelessWidget {
  final Widget child;

  const PhoneFrame({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Container(
          width: 390,
          height: 844,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.20),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      ),
    );
  }
}

// ============================================================================
// PRODUCT PREVIEW SCREEN
// ============================================================================

class ProductPreviewScreen extends StatelessWidget {
  const ProductPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // ============================================================
      // BOTTOM ACTION BAR
      // ============================================================

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SizedBox(
            height: 50,
            width: double.infinity,
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
                size: 20,
              ),
              label: const Text(
                'Add to Cart',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56,
        title: const Text(
          'Product Preview',
          style: TextStyle(
            fontSize: 19,
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
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              const ProductCover(),

              const SizedBox(height: 18),

              // Product information
              const ProductInformation(),

              const SizedBox(height: 24),

              // ======================================================
              // DESCRIPTION
              // ======================================================

              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 7),

              Text(
                'A stylish and versatile backpack designed for everyday '
                'use. It features a spacious interior, comfortable '
                'shoulder straps, and a water-resistant exterior. '
                'Perfect for work, travel, school, or everyday adventures.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: Colors.grey.shade700,
                    ),
              ),

              const SizedBox(height: 24),

              // ======================================================
              // PRODUCT DETAILS
              // ======================================================

              Text(
                'Product Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 12),

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

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PRODUCT COVER
// ============================================================================

class ProductCover extends StatefulWidget {
  const ProductCover({super.key});

  @override
  State<ProductCover> createState() => _ProductCoverState();
}

class _ProductCoverState extends State<ProductCover> {
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    // Small popup at the bottom
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.white,
              size: 20,
            ),

            const SizedBox(width: 10),

            Text(
              isFavorite
                  ? 'Added to favorites'
                  : 'Removed from favorites',
            ),
          ],
        ),

        // Small popup, not full screen
        behavior: SnackBarBehavior.floating,

        // Distance from the bottom
        margin: const EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20,
        ),

        // Rounded corners
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),

        // How long it stays
        duration: const Duration(seconds: 2),

        // Small height
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Stack(
        children: [
          // ==========================================================
          // PRODUCT IMAGE
          // ==========================================================

          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(18),

                child: Image.network(
                  'https://cdn.sportmaster.ru/upload/mdm/media_content/resize/a21/768_1024_3cb0/191230430299.jpg',

                  // Shows the ENTIRE image.
                  // Nothing is cropped.
                  fit: BoxFit.contain,

                  width: double.infinity,
                  height: double.infinity,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 55,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // ==========================================================
          // FAVORITE BUTTON
          // ==========================================================

          Positioned(
            top: 12,
            right: 12,

            child: Material(
              color: Colors.white,
              elevation: 4,
              shape: const CircleBorder(),

              child: InkWell(
                customBorder: const CircleBorder(),

                // Make favorite button work
                onTap: toggleFavorite,

                child: Padding(
                  padding: const EdgeInsets.all(10),

                  child: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,

                    size: 22,

                    // Red when selected
                    color: isFavorite
                        ? Colors.red
                        : Colors.black87,
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
        // ==========================================================
        // TITLE + RATING
        // ==========================================================

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Premium Everyday Backpack',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
              ),
            ),

            const SizedBox(width: 8),

            const RatingWidget(),
          ],
        ),

        const SizedBox(height: 12),

        // ==========================================================
        // PRICE
        // ==========================================================

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$129.99',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),

            const SizedBox(width: 8),

            Text(
              '\$159.99',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // ==========================================================
        // CATEGORY BADGES
        // ==========================================================

        const Wrap(
          spacing: 6,
          runSpacing: 6,
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
        horizontal: 8,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(10),
      ),

      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: Colors.amber,
            size: 17,
          ),

          SizedBox(width: 3),

          Text(
            '4.8',
            style: TextStyle(
              fontSize: 13,
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
        size: 15,
        color: Theme.of(context).colorScheme.primary,
      ),

      label: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),

      visualDensity: VisualDensity.compact,

      materialTapTargetSize:
          MaterialTapTargetSize.shrinkWrap,
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
      padding: const EdgeInsets.only(bottom: 11),

      child: Row(
        children: [
          // ==========================================================
          // ICON
          // ==========================================================

          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),

          const SizedBox(width: 10),

          // ==========================================================
          // TITLE
          // ==========================================================

          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          // ==========================================================
          // VALUE
          // ==========================================================

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}