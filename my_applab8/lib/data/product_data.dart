import 'dart:math';

import 'package:flutter/material.dart';

import '../models/product.dart';

const Color _audio = Color(0xFF5C6BC0);
const Color _wearable = Color(0xFF26A69A);
const Color _computer = Color(0xFF8D6E63);
const Color _home = Color(0xFFEF6C00);
const Color _gaming = Color(0xFFAB47BC);

const List<Product> seedProducts = [
  Product(
    id: 1,
    title: 'Aurora Wireless Headphones',
    category: 'Audio',
    rating: 4.8,
    price: 129.99,
    icon: Icons.headphones,
    color: _audio,
  ),
  Product(
    id: 2,
    title: 'Pulse Fitness Band',
    category: 'Wearables',
    rating: 4.3,
    price: 49.50,
    icon: Icons.watch,
    color: _wearable,
  ),
  Product(
    id: 3,
    title: 'Nimbus 14 Ultrabook',
    category: 'Computers',
    rating: 4.7,
    price: 899.00,
    icon: Icons.laptop_mac,
    color: _computer,
  ),
  Product(
    id: 4,
    title: 'Lumen Smart Lamp',
    category: 'Smart Home',
    rating: 4.1,
    price: 34.90,
    icon: Icons.lightbulb,
    color: _home,
  ),
  Product(
    id: 5,
    title: 'Vortex Game Controller',
    category: 'Gaming',
    rating: 4.6,
    price: 59.99,
    icon: Icons.sports_esports,
    color: _gaming,
  ),
  Product(
    id: 6,
    title: 'Echo Mini Speaker',
    category: 'Audio',
    rating: 4.4,
    price: 39.00,
    icon: Icons.speaker,
    color: _audio,
  ),
  Product(
    id: 7,
    title: 'Orbit Smartwatch',
    category: 'Wearables',
    rating: 4.5,
    price: 199.00,
    icon: Icons.watch_outlined,
    color: _wearable,
  ),
  Product(
    id: 8,
    title: 'Forge Mechanical Keyboard',
    category: 'Computers',
    rating: 4.9,
    price: 109.00,
    icon: Icons.keyboard,
    color: _computer,
  ),
  Product(
    id: 9,
    title: 'Guardian Door Camera',
    category: 'Smart Home',
    rating: 4.2,
    price: 79.99,
    icon: Icons.videocam,
    color: _home,
  ),
  Product(
    id: 10,
    title: 'Titan Gaming Mouse',
    category: 'Gaming',
    rating: 4.7,
    price: 44.99,
    icon: Icons.mouse,
    color: _gaming,
  ),
  Product(
    id: 11,
    title: 'Studio Condenser Microphone',
    category: 'Audio',
    rating: 4.6,
    price: 89.00,
    icon: Icons.mic,
    color: _audio,
  ),
  Product(
    id: 12,
    title: 'Vista 27 4K Monitor',
    category: 'Computers',
    rating: 4.5,
    price: 349.00,
    icon: Icons.desktop_windows,
    color: _computer,
  ),
  Product(
    id: 13,
    title: 'Climate Smart Thermostat',
    category: 'Smart Home',
    rating: 4.3,
    price: 119.00,
    icon: Icons.thermostat,
    color: _home,
  ),
  Product(
    id: 14,
    title: 'Horizon VR Headset',
    category: 'Gaming',
    rating: 4.4,
    price: 299.00,
    icon: Icons.vrpano,
    color: _gaming,
  ),
  Product(
    id: 15,
    title: 'Trail GPS Tracker',
    category: 'Wearables',
    rating: 4.0,
    price: 69.00,
    icon: Icons.location_on,
    color: _wearable,
  ),
  Product(
    id: 16,
    title: 'Volt Fast Charger',
    category: 'Computers',
    rating: 4.8,
    price: 29.99,
    icon: Icons.battery_charging_full,
    color: _computer,
  ),
];

const List<(String, String, IconData, Color)> _newArrivals = [
  ('Nova Earbuds', 'Audio', Icons.earbuds, _audio),
  ('Stride Smart Ring', 'Wearables', Icons.circle_outlined, _wearable),
  ('Atlas Tablet', 'Computers', Icons.tablet_mac, _computer),
  ('Breeze Air Purifier', 'Smart Home', Icons.air, _home),
  ('Arcade Handheld Console', 'Gaming', Icons.videogame_asset, _gaming),
];

final Random _random = Random();

Product generateProduct(int id) {
  final (title, category, icon, color) =
      _newArrivals[_random.nextInt(_newArrivals.length)];

  return Product(
    id: id,
    title: '$title #$id',
    category: category,
    rating: 3.5 + _random.nextInt(16) / 10,
    price: 20 + _random.nextInt(300) + 0.99,
    icon: icon,
    color: color,
  );
}
