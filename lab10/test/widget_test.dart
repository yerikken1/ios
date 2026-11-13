import 'package:flutter_test/flutter_test.dart';
import 'package:lab10/models/product.dart';

void main() {
  test('Product.fromJson handles int price and nested rating', () {
    final p = Product.fromJson({
      'id': 1,
      'title': 'Bag',
      'price': 109, // int, not double
      'description': 'Nice bag',
      'category': "men's clothing",
      'image': 'https://example.com/a.png',
      'rating': {'rate': 4, 'count': 120},
    });
    expect(p.price, 109.0);
    expect(p.rating, 4.0);
    expect(p.reviewCount, 120);
    expect(p.deepLink, 'narxoz://store/product/1');
  });

  test('Product.fromJson uses null-safe fallbacks', () {
    final p = Product.fromJson({});
    expect(p.id, 0);
    expect(p.title, 'Untitled product');
    expect(p.price, 0.0);
    expect(p.rating, 0.0);
    expect(p.reviewCount, 0);
  });
}
