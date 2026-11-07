import 'package:dio/dio.dart';

class SessionExpiredInterceptor extends Interceptor {
  final void Function() onSessionExpired;

  SessionExpiredInterceptor(this.onSessionExpired);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      onSessionExpired();
    }
    handler.next(err);
  }
}

