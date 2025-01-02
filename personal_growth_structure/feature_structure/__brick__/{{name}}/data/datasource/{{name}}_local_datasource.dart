
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part '{{name}}_local_datasource.g.dart';

abstract class {{name.pascalCase()}}LocalDatasource {
  
}

class {{name.pascalCase()}}LocalDatasourceImpl implements  {{name.pascalCase()}}LocalDatasource{
  {{name.pascalCase()}}LocalDatasourceImpl(this.ref);
  final Ref ref;
  
}

@riverpod
{{name.pascalCase()}}LocalDatasource {{name}}LocalDatasource(Ref ref){
  return {{name.pascalCase()}}LocalDatasourceImpl(ref);
}