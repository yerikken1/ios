class Product {
  final int id;
  final String title;
  final String category;
  final double rating;
  final int price;
  final String image;

  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.rating,
    required this.price,
    required this.image,
  });

  // 549990 -> 549 990 ₸, with non-breaking spaces so it never wraps.
  String get formattedPrice {
    final digits = price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+$)'),
      (_) => ' ',
    );
    return '$digits ₸';
  }
}
