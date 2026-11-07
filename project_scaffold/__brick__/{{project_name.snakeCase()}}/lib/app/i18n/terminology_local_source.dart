import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:{{project_name.snakeCase()}}/app/i18n/terminology.dart';
import 'package:{{project_name.snakeCase()}}/hive/hive_service.dart';

class TerminologyLocalSource {
  TerminologyLocalSource(this._box);

  final Box<String> _box;

  Terminology? read(String orgCode) {
    final raw = _box.get(orgCode);
    if (raw == null) return null;
    try {
      return Terminology.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(String orgCode, Terminology terminology) =>
      _box.put(orgCode, jsonEncode(terminology.toJson()));
}

final terminologyLocalSourceProvider = Provider<TerminologyLocalSource>((ref) {
  return TerminologyLocalSource(HiveManager.instance.terminologyBox);
});

