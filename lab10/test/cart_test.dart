import 'package:flutter_test/flutter_test.dart';
import 'package:lab10/models/product.dart';
import 'package:lab10/providers/cart_provider.dart';

void main() {
  const a = Product(id: 1, title: 'A', price: 10, description: '', category: 'c',
      imageUrl: '', rating: 4, reviewCount: 1);
  const b = Product(id: 2, title: 'B', price: 2.5, description: '', category: 'c',
      imageUrl: '', rating: 4, reviewCount: 1);

  test('adding the same product increases quantity and total', () {
    final cart = CartProvider()..add(a)..add(a)..add(b);
    expect(cart.items.length, 2);
    expect(cart.itemCount, 3);
    expect(cart.totalPrice, 22.5);
  });

  test('decrease removes item at quantity 1, clear empties cart', () {
    final cart = CartProvider()..add(a)..add(b);
    cart.decrease(2);
    expect(cart.items.length, 1);
    cart.clear();
    expect(cart.isEmpty, true);
  });
}
