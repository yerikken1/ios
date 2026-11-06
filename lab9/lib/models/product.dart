import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final IconData icon;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
  });
}
