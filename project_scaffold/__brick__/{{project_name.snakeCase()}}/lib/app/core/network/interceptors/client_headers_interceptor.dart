import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ClientHeadersInterceptor extends Interceptor {
  String? _version;

  Future<String> _getVersion() async {
    if (_version != null) return _version!;
    try {
      final info = await PackageInfo.fromPlatform();
      _version = '${info.version}+${info.buildNumber}';
    } catch (_) {
      _version = '1.0.0';
    }
    return _version!;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final version = await _getVersion();
    options.headers['X-App-Version'] = version;
    options.headers['X-Platform'] = kIsWeb
        ? 'web'
        : Platform.isAndroid
            ? 'android'
            : Platform.isIOS
                ? 'ios'
                : 'other';

    handler.next(options);
  }
}

