import 'package:dio/dio.dart';
import 'package:{{project_name.snakeCase()}}/hive/hive_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Read cached token from encrypted userBox
    final auth = HiveManager.instance.userBox.get('auth');
    if (auth != null && auth.token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${auth.token}';
    }
    handler.next(options);
  }
}

