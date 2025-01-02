import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '{{name}}_route.g.dart';

@riverpod
List<GoRoute> {{name.pascalCase()}}Routes(Ref ref) => [
];