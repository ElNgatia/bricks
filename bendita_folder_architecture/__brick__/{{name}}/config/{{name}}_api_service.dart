import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/app.dart';
import 'package:retrofit/retrofit.dart';

part '{{name}}_api_service.g.dart';

@RestApi(baseUrl: "$baseUrl/{{name}}")
abstract class {{name.pascalCase()}}ApiService {
  factory {{name.pascalCase()}}ApiService(
    Dio dio,
  ) = _{{name.pascalCase()}}ApiService;

  @GET('/')
  Future<Map<String, String>> fetchRoot();

  @GET("/all_{{name}}")
  Future<Map<String, {{name.pascalCase()}}Entity>> fetch{{name.pascalCase()}}s();

  @POST("/create_{{name}}")
  Future<{{name.pascalCase()}}Entity> create{{name.pascalCase()}}(@Body() {{name.pascalCase()}}Entity {{name}});

  @GET("/fetch_{{name}}/{id}")
  Future<{{name.pascalCase()}}Entity> fetch{{name.pascalCase()}}ById(@Path("id") String id);
}

@riverpod
{{name.pascalCase()}}ApiService {{name}}ApiService(Ref ref) {
  return {{name.pascalCase()}}ApiService(ref.watch(dioProvider));
}