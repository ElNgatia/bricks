import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/theme/foundation/app_palette.dart';

class AppColorsThemeExtentionV2
    extends ThemeExtension<AppColorsThemeExtentionV2> {
  final Color primary;
  final Color background;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;
  final Color cardBackground;
  final Color inputFill;
  final Color border;
  final Color contrastColor;
  final Color success;
  final Color error;
  final Color action;
  final bool isDark;

  const AppColorsThemeExtentionV2({
    required this.background,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.cardBackground,
    required this.inputFill,
    required this.contrastColor,
    required this.success,
    required this.error,
    required this.border,
    required this.isDark,
    required this.primary,
    required this.action,
  });

  @override
  ThemeExtension<AppColorsThemeExtentionV2> copyWith({
    Color? primary,
    Color? background,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? cardBackground,
    Color? inputFill,
    Color? border,
    Color? contrastColor,
    Color? success,
    Color? error,
    Color? action,
    bool? isDark,
  }) {
    return AppColorsThemeExtentionV2(
      primary: primary ?? this.primary,
      background: background ?? this.background,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      cardBackground: cardBackground ?? this.cardBackground,
      inputFill: inputFill ?? this.inputFill,
      contrastColor: contrastColor ?? this.contrastColor,
      success: success ?? this.success,
      error: error ?? this.error,
      border: border ?? this.border,
      isDark: isDark ?? this.isDark,
      action: action ?? this.action,
    );
  }

  @override
  ThemeExtension<AppColorsThemeExtentionV2> lerp(
    covariant ThemeExtension<AppColorsThemeExtentionV2>? other,
    double t,
  ) {
    if (other is! AppColorsThemeExtentionV2) return this;
    return AppColorsThemeExtentionV2(
      primary: Color.lerp(primary, other.primary, t)!,
      background: Color.lerp(background, other.background, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      contrastColor: Color.lerp(contrastColor, other.contrastColor, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      border: Color.lerp(border, other.border, t)!,
      action: Color.lerp(action, other.action, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }

  static const light = AppColorsThemeExtentionV2(
    primary: AppPalette.primary,
    background: AppPalette.backgroundLight,
    textPrimary: Color(0xFF1E293B),
    textSecondary: Color(0xFF64748B),
    textTertiary: Color(0xFF94A3B8),
    textDisabled: Color(0xFFCBD5E1),
    cardBackground: Colors.white,
    inputFill: Color(0xFFF1F5F9),
    contrastColor: Colors.black,
    success: AppPalette.success,
    error: AppPalette.error,
    border: Color(0xFFE2E8F0),
    isDark: false,
    action: AppPalette.primaryLight,
  );

  static const dark = AppColorsThemeExtentionV2(
    primary: AppPalette.accent,
    background: AppPalette.darkBackground,
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    textTertiary: Color(0xFF64748B),
    textDisabled: Color(0xFF475569),
    cardBackground: Color(0xFF1F2937),
    inputFill: Color(0xFF374151),
    contrastColor: Colors.white,
    success: AppPalette.successLight,
    error: AppPalette.errorLight,
    border: Color(0xFF4B5563),
    isDark: true,
    action: AppPalette.accent,
  );
}

