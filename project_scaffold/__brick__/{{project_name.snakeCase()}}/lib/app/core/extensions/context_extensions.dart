import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/theme/theme_extensions.dart';
import 'package:{{project_name.snakeCase()}}/app/theme/util/app_colors_theme_extention.dart';
import 'package:{{project_name.snakeCase()}}/app/i18n/strings.g.dart';

extension ContextExtensions on BuildContext {
  /// Fast access to primary Theme colors extension
  AppColorsThemeExtentionV2 get colors2 =>
      Theme.of(this).extension<AppColorsThemeExtentionV2>() ??
      AppColorsThemeExtentionV2.light;

  /// Fast access to detailed Theme colors extension
  AppColorsExtension get colors =>
      Theme.of(this).extension<AppColorsExtension>() ??
      AppColorsExtension.light;

  /// TextTheme shortcut
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Slang translations shortcut
  Translations get t => Translations.of(this);

  /// Media query helpers
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
  EdgeInsets get padding => mediaQuery.padding;

  /// Check theme mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

