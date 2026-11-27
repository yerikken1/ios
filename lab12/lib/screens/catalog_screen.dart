import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cart/cart_bloc.dart';
import '../cart/cart_event.dart';
import '../cart/cart_state.dart';
import '../models/product.dart';
import 'cart_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  static const List<Product> products = [
    Product(id: '1', name: 'Laptop', price: 350000),
    Product(id: '2', name: 'Smartphone', price: 180000),
    Product(id: '3', name: 'Headphones', price: 45000),
    Product(id: '4', name: 'Keyboard', price: 15000),
    Product(id: '5', name: 'Mouse', price: 8000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
                icon: Badge(
                  isLabelVisible: state.count > 0,
                  label: Text('${state.count}'),
                  child: const Icon(Icons.shopping_cart),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(
                Icons.shopping_bag,
                size: 40,
                color: Colors.blue,
              ),
              title: Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${product.price.toStringAsFixed(0)} ₸'),
              trailing: ElevatedButton(
                onPressed: () {
                  context.read<CartBloc>().add(AddProductEvent(product));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} added to cart'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text('Add'),
              ),
            ),
          );
        },
      ),
    );
  }
}
