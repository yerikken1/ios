import 'package:equatable/equatable.dart';

import '../models/product.dart';

class CartState extends Equatable {
  final List<Product> items;
  final double totalPrice;
  final int count;

  const CartState({
    required this.items,
    required this.totalPrice,
    required this.count,
  });

  factory CartState.initial() {
    return const CartState(
      items: [],
      totalPrice: 0,
      count: 0,
    );
  }

  @override
  List<Object> get props => [items, totalPrice, count];
}
