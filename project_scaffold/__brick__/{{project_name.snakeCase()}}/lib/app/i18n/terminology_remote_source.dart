import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{project_name.snakeCase()}}/app/core/constants/network_constants.dart';
import 'package:{{project_name.snakeCase()}}/app/core/errors/failures.dart';
import 'package:{{project_name.snakeCase()}}/app/core/network/api_client.dart';
import 'package:{{project_name.snakeCase()}}/app/i18n/terminology.dart';

class TerminologyRemoteSource {
  TerminologyRemoteSource(this._client);

  final ApiClient _client;

  Future<Terminology> fetch(String orgCode) async {
    try {
      final response = await _client.get(
        NetworkConstants.terminologyPath(orgCode),
      );
      return Terminology.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}

final terminologyRemoteSourceProvider = Provider<TerminologyRemoteSource>((ref) {
  return TerminologyRemoteSource(ref.watch(apiClientProvider));
});

