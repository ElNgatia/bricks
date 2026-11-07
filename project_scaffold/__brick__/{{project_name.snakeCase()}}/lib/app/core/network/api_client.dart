import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{project_name.snakeCase()}}/app/core/network/dio_provider.dart';
import 'package:{{project_name.snakeCase()}}/app/core/network/session_expiry.dart';
import 'package:{{project_name.snakeCase()}}/app/core/network/interceptors/auth_interceptor.dart';
import 'package:{{project_name.snakeCase()}}/app/core/network/interceptors/client_headers_interceptor.dart';
import 'package:{{project_name.snakeCase()}}/app/core/network/interceptors/logger_interceptor.dart';
import 'package:{{project_name.snakeCase()}}/app/core/network/interceptors/server_time_interceptor.dart';
import 'package:{{project_name.snakeCase()}}/app/core/network/interceptors/session_expired_interceptor.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  final sessionExpiry = ref.watch(sessionExpiryProvider);

  return ApiClient(dio, onSessionExpired: sessionExpiry.notify);
});

class ApiClient {
  ApiClient(this._dio, {required this._onSessionExpired}) {
    _initialize();
  }

  final Dio _dio;
  final void Function() _onSessionExpired;

  void _initialize() {
    _dio.interceptors.addAll([
      ClientHeadersInterceptor(),
      AuthInterceptor(),
      LoggerInterceptor(),
      ServerTimeInterceptor(),
      SessionExpiredInterceptor(_onSessionExpired),
    ]);
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get<T>(path, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      onSendProgress: onSendProgress,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.patch<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete<T>(path, data: data, queryParameters: queryParameters, options: options);
  }
}

