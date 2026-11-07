import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/models/auth.dart';
import 'package:{{project_name.snakeCase()}}/hive/hive_service.dart';

final currentUserProvider = Provider<Auth?>((ref) {
  return HiveManager.instance.userBox.get('auth');
});

