import 'package:flutter/material.dart';

import '../data/product_data.dart';
import '../models/product.dart';
import '../widgets/dismissible_product.dart';
import '../widgets/empty_catalog.dart';
import '../widgets/product_grid_card.dart';
import '../widgets/product_list_tile.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final List<Product> _products = List.of(seedProducts);
  int _nextId = seedProducts.length + 1;
  bool _isGrid = false;

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    // A pending undo stores an index that is about to shift by one.
    ScaffoldMessenger.of(context).clearSnackBars();
    setState(() {
      _products.insert(0, generateProduct(_nextId++));
    });
  }

  void _delete(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);

    setState(() {
      _products.removeAt(index);
    });

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text('${product.title} removed'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        // A SnackBar with an action stays on screen forever unless told not to.
        persist: false,
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () => _undo(product, index),
        ),
      ),
    );
  }

  void _undo(Product product, int index) {
    setState(() {
      _products.insert(index.clamp(0, _products.length), product);
    });
  }

  void _resetCatalog() {
    ScaffoldMessenger.of(context).clearSnackBars();
    setState(() {
      _products
        ..clear()
        ..addAll(seedProducts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Catalog'),
        actions: [
          IconButton(
            tooltip: _isGrid ? 'Show list' : 'Show grid',
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      body: _products.isEmpty
          ? EmptyCatalog(onReset: _resetCatalog)
          : RefreshIndicator(
              onRefresh: _refresh,
              child: _isGrid ? _buildGrid() : _buildList(),
            ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      key: const PageStorageKey('catalog_list'),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _products.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, thickness: 0.5),
      itemBuilder: (context, index) {
        final product = _products[index];
        return DismissibleProduct(
          product: product,
          onDismissed: () => _delete(product),
          child: ProductListTile(product: product),
        );
      },
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      key: const PageStorageKey('catalog_grid'),
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return DismissibleProduct(
          product: product,
          onDismissed: () => _delete(product),
          child: ProductGridCard(product: product),
        );
      },
    );
  }
}
