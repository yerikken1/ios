/// Domain model for a product from https://fakestoreapi.com/products
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  /// Type-safe deserialization with null-safe fallbacks.
  /// Numbers are read as `num` and converted, so both `109` and `109.95`
  /// are accepted without an int/double cast error.
  factory Product.fromJson(Map<String, dynamic> json) {
    final ratingJson = json['rating'] is Map<String, dynamic>
        ? json['rating'] as Map<String, dynamic>
        : const <String, dynamic>{};

    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'Untitled product',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? 'No description available.',
      category: json['category'] as String? ?? 'uncategorized',
      imageUrl: json['image'] as String? ?? '',
      rating: (ratingJson['rate'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (ratingJson['count'] as num?)?.toInt() ?? 0,
    );
  }

  /// The API returns one photo per product, so the gallery shows
  /// three views of it (full, detail, close-up) in the carousel.
  List<String> get gallery => [imageUrl, imageUrl, imageUrl];

  String get deepLink => 'narxoz://store/product/$id';
}
