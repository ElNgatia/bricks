import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/theme/foundation/app_palette.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.bgDeep,
    required this.bgMid,
    required this.bgLight,
    required this.surface,
    required this.card,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.isDark,
  });

  final Color bgDeep;
  final Color bgMid;
  final Color bgLight;
  final Color surface;
  final Color card;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final bool isDark;

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? bgDeep,
    Color? bgMid,
    Color? bgLight,
    Color? surface,
    Color? card,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    bool? isDark,
  }) {
    return AppColorsExtension(
      bgDeep: bgDeep ?? this.bgDeep,
      bgMid: bgMid ?? this.bgMid,
      bgLight: bgLight ?? this.bgLight,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      bgDeep: Color.lerp(bgDeep, other.bgDeep, t)!,
      bgMid: Color.lerp(bgMid, other.bgMid, t)!,
      bgLight: Color.lerp(bgLight, other.bgLight, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }

  static const light = AppColorsExtension(
    bgDeep: Color(0xFFE5E7EB),
    bgMid: AppPalette.backgroundLight,
    bgLight: Color(0xFFF9FAFB),
    surface: Colors.white,
    card: Colors.white,
    border: Color(0xFFE2E8F0),
    textPrimary: Color(0xFF1E293B),
    textSecondary: Color(0xFF64748B),
    textTertiary: Color(0xFF94A3B8),
    isDark: false,
  );

  static const dark = AppColorsExtension(
    bgDeep: Color(0xFF030712),
    bgMid: AppPalette.darkBackground,
    bgLight: Color(0xFF1F2937),
    surface: Color(0xFF1F2937),
    card: Color(0xFF1F2937),
    border: Color(0xFF4B5563),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    textTertiary: Color(0xFF64748B),
    isDark: true,
  );
}

