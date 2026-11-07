import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{project_name.snakeCase()}}/app/settings/app_settings_local_source.dart';

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final settings = ref.read(appSettingsLocalSourceProvider);
    return settings.getThemeMode() ?? ThemeMode.system;
  }

  Future<void> setTheme(ThemeMode theme) async {
    state = theme;
    await ref.read(appSettingsLocalSourceProvider).setThemeMode(theme);
  }
}

