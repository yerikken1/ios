import 'package:flutter/material.dart';

import '../models/product.dart';

const List<Product> kProducts = [
  Product(
    id: 'p1',
    name: 'Wireless Headphones',
    description: 'Noise cancelling, 30h battery',
    price: 129.99,
    icon: Icons.headphones,
  ),
  Product(
    id: 'p2',
    name: 'Smart Watch',
    description: 'Heart rate & GPS tracking',
    price: 199.00,
    icon: Icons.watch,
  ),
  Product(
    id: 'p3',
    name: 'Bluetooth Speaker',
    description: 'Waterproof, deep bass',
    price: 59.50,
    icon: Icons.speaker,
  ),
  Product(
    id: 'p4',
    name: 'Instant Camera',
    description: 'Print photos in seconds',
    price: 89.90,
    icon: Icons.camera_alt,
  ),
  Product(
    id: 'p5',
    name: 'Gaming Controller',
    description: 'Ergonomic, low latency',
    price: 49.99,
    icon: Icons.sports_esports,
  ),
  Product(
    id: 'p6',
    name: 'Mechanical Keyboard',
    description: 'Hot-swap red switches',
    price: 109.00,
    icon: Icons.keyboard,
  ),
];
