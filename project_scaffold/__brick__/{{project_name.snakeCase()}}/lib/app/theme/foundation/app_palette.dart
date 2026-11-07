import 'package:flutter/material.dart';

/// Raw color palette.
///
/// This class contains reusable color values only.
/// It is completely theme-agnostic.
class AppPalette {
  const AppPalette._();

  // BRAND — replace with your own colours.
  static const primary = Color(0xFF4F46E5);
  static const primaryLight = Color(0xFF6366F1);
  static const primaryDark = Color(0xFF4338CA);

  static const accent = Color(0xFF14B8A6);
  static const accentLight = Color(0xFF2DD4BF);

  static const yellow = Color(0xFFF5C84C);
  static const orange = Color(0xFFF97316);

  static const purple = Color(0xFF8B5CF6);
  static const purpleLight = Color(0xFFA78BFA);

  // BACKGROUND
  static const backgroundLight = Color(0xFFF3F4F6);
  static const darkBackground = Color(0xFF111827);

  // FEEDBACK
  static const success = Color(0xFF16A34A);
  static const successLight = Color(0xFF22C55E);

  static const warning = Color(0xFFF5C84C);
  static const warningLight = Color(0xFFF7D56D);

  static const error = Color(0xFFFF6B6B);
  static const errorLight = Color(0xFFFF8585);

  static const info = Color(0xFF3B82F6);
  static const infoLight = Color(0xFF60A5FA);
}

