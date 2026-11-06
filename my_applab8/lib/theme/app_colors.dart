import 'package:flutter/material.dart';

/// Red / burgundy / white palette (same as lab9).
class AppColors {
  static const Color burgundy = Color(0xFF6D0F1F);
  static const Color burgundyDark = Color(0xFF4A0814);
  static const Color red = Color(0xFFC8102E);
  static const Color redLight = Color(0xFFF3D6DA);
  static const Color white = Color(0xFFFFFFFF);

  /// Page background.
  static const Color paper = Color(0xFFFFF7F7);

  /// Card / tile surface.
  static const Color card = white;

  /// Primary text.
  static const Color ink = Color(0xFF2B0A10);

  /// Secondary text.
  static const Color muted = Color(0xFF8A5A62);

  /// Dividers and borders.
  static const Color line = redLight;

  /// Accents: prices, stars, buttons.
  static const Color accent = red;
}
