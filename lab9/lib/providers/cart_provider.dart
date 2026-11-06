import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../models/product.dart';

/// Global cart state shared by every screen.
class CartProvider extends ChangeNotifier {
  // LinkedHashMap keeps the order in which items were added.
  final LinkedHashMap<String, Product> _items = LinkedHashMap();

  UnmodifiableListView<Product> get items =>
      UnmodifiableListView(_items.values);

  int get itemCount => _items.length;

  bool get isEmpty => _items.isEmpty;

  double get totalPrice =>
      _items.values.fold(0.0, (sum, product) => sum + product.price);

  bool contains(Product product) => _items.containsKey(product.id);

  void add(Product product) {
    if (_items.containsKey(product.id)) return;
    _items[product.id] = product;
    notifyListeners();
  }

  void remove(Product product) {
    if (_items.remove(product.id) != null) notifyListeners();
  }

  void toggle(Product product) =>
      contains(product) ? remove(product) : add(product);

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
