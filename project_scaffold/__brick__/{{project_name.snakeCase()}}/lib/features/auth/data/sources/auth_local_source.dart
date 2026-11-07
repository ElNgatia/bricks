import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/models/auth.dart';
import 'package:{{project_name.snakeCase()}}/hive/hive_service.dart';

abstract class AuthLocalSource {
  Future<Auth> cacheAuth(Auth auth);
  Auth? getCachedAuthToken();
  Future<void> clearAuth();
}

class AuthLocalSourceImpl implements AuthLocalSource {
  final Box<Auth> userBox;

  AuthLocalSourceImpl({required this.userBox});

  @override
  Future<Auth> cacheAuth(Auth auth) async {
    await userBox.put('auth', auth);
    return auth;
  }

  @override
  Future<void> clearAuth() async {
    await userBox.delete('auth');
  }

  @override
  Auth? getCachedAuthToken() {
    return userBox.get('auth');
  }
}

final authLocalSourceProvider = Provider<AuthLocalSource>((ref) {
  return AuthLocalSourceImpl(userBox: HiveManager.instance.userBox);
});

