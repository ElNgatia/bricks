import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/theme/foundation/app_palette.dart';
import 'package:{{project_name.snakeCase()}}/app/theme/foundation/app_typography.dart';
import 'package:{{project_name.snakeCase()}}/app/theme/theme_extensions.dart';
import 'package:{{project_name.snakeCase()}}/app/theme/util/app_colors_theme_extention.dart';

class AppThemeV2 {
  static ThemeData theme(ThemeMode themeMode) {
    final colors = themeMode == ThemeMode.dark
        ? AppColorsThemeExtentionV2.dark
        : AppColorsThemeExtentionV2.light;

    final brightness = themeMode == ThemeMode.dark
        ? Brightness.dark
        : Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,
      textTheme: AppTypography.build(
        textPrimary: colors.textPrimary,
        textSecondary: colors.textSecondary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.inputFill,
        hintStyle: TextStyle(color: colors.textDisabled),
        prefixIconColor: colors.textTertiary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppPalette.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppPalette.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppPalette.error, width: 1.5),
        ),
        errorStyle: const TextStyle(color: AppPalette.errorLight, fontSize: 12),
      ),
      cardColor: colors.cardBackground,
      extensions: [
        colors,
        themeMode == ThemeMode.dark
            ? AppColorsExtension.dark
            : AppColorsExtension.light,
      ],
    );
  }
}

