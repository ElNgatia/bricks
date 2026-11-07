import 'dart:io';

import 'package:dio/dio.dart';
import 'package:{{project_name.snakeCase()}}/app/core/time/server_clock.dart';

class ServerTimeInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final dateHeader = response.headers.value('date');
    if (dateHeader != null) {
      try {
        final serverDate = HttpDate.parse(dateHeader);
        ServerClock.instance.syncWithServer(serverDate);
      } catch (_) {}
    }
    handler.next(response);
  }
}

