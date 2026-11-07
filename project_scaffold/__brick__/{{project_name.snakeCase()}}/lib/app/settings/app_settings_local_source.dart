import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:{{project_name.snakeCase()}}/hive/hive_service.dart';

class AppSettingsKeys {
  AppSettingsKeys._();

  static const themeMode = 'themeMode';
  static const organisationId = 'organisationId';
}

abstract class AppSettingsLocalSource {
  ThemeMode? getThemeMode();
  Future<void> setThemeMode(ThemeMode mode);

  String? getOrganisationId();
  Future<void> setOrganisationId(String id);
  Future<void> clearOrganisationId();
}

class AppSettingsLocalSourceImpl implements AppSettingsLocalSource {
  final Box settingsBox;

  AppSettingsLocalSourceImpl({required this.settingsBox});

  @override
  ThemeMode? getThemeMode() {
    final value = settingsBox.get(AppSettingsKeys.themeMode);
    if (value is! String) return null;

    for (final mode in ThemeMode.values) {
      if (mode.name == value) return mode;
    }
    return null;
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) {
    return settingsBox.put(AppSettingsKeys.themeMode, mode.name);
  }

  @override
  String? getOrganisationId() {
    final value = settingsBox.get(AppSettingsKeys.organisationId);
    return value is String ? value : null;
  }

  @override
  Future<void> setOrganisationId(String id) {
    return settingsBox.put(AppSettingsKeys.organisationId, id);
  }

  @override
  Future<void> clearOrganisationId() {
    return settingsBox.delete(AppSettingsKeys.organisationId);
  }
}

final appSettingsLocalSourceProvider = Provider<AppSettingsLocalSource>((ref) {
  return AppSettingsLocalSourceImpl(
    settingsBox: HiveManager.instance.settingsBox,
  );
});

