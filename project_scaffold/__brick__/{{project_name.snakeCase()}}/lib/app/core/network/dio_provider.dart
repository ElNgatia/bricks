import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{project_name.snakeCase()}}/app/core/constants/network_constants.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: NetworkConstants.baseUrl,
      connectTimeout: NetworkConstants.defaultTimeOut,
      receiveTimeout: NetworkConstants.defaultTimeOut,
      sendTimeout: NetworkConstants.defaultTimeOut,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
});

