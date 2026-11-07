import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/models/auth.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/sources/auth_local_source.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/sources/auth_remote_source.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource _remoteSource;
  final AuthLocalSource _localSource;

  AuthRepositoryImpl({
    required this._remoteSource,
    required this._localSource,
  });

  @override
  Future<Auth> login(String email, String password) async {
    final auth = await _remoteSource.login(email, password);
    await _localSource.cacheAuth(auth);
    return auth;
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteSource.logout();
    } finally {
      await _localSource.clearAuth();
    }
  }

  @override
  Auth? getCachedAuth() {
    return _localSource.getCachedAuthToken();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteSource: ref.watch(authRemoteSourceProvider),
    localSource: ref.watch(authLocalSourceProvider),
  );
});

