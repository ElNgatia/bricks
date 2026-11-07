import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  const AppTypography._();

  static TextTheme build({
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final base = GoogleFonts.montserratTextTheme();

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: base.displayMedium?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: base.displaySmall?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: base.titleLarge?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: base.titleSmall?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        color: textPrimary,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: textSecondary,
      ),
      bodySmall: base.bodySmall?.copyWith(
        color: textSecondary,
      ),
      labelLarge: base.labelLarge?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: base.labelMedium?.copyWith(
        color: textSecondary,
      ),
      labelSmall: base.labelSmall?.copyWith(
        color: textSecondary,
      ),
    );
  }
}

