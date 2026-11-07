import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{project_name.snakeCase()}}/app/core/errors/failures.dart';
import 'package:{{project_name.snakeCase()}}/app/core/network/api_client.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/models/auth.dart';

abstract class AuthRemoteSource {
  Future<Auth> login(String email, String password);
  Future<void> logout();
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final ApiClient _client;

  AuthRemoteSourceImpl(this._client);

  @override
  Future<Auth> login(String email, String password) async {
    try {
      final response = await _client.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return Auth.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _client.post('/auth/logout');
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}

final authRemoteSourceProvider = Provider<AuthRemoteSource>((ref) {
  return AuthRemoteSourceImpl(ref.watch(apiClientProvider));
});

