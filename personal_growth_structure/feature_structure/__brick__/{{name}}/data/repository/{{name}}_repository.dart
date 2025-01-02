import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part '{{name}}_repository.dart';


abstract class {{name.pascalCase()}}Repository{}

class {{name.pascalCase()}}RepositoryImpl implements {{name.pascalCase()}}Repository{ 
  final Ref ref;
  {{name.pascalCase()}}RepositoryImpl(this.ref);
  
}

@riverpod
{{name.pascalCase()}}Repository {{name}}Repository (Ref ref) {
  return {{name.pascalCase()}}RepositoryImpl(ref);
}