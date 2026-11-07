import 'package:{{project_name.snakeCase()}}/features/auth/data/models/auth.dart';

abstract class AuthRepository {
  Future<Auth> login(String email, String password);
  Future<void> logout();
  Auth? getCachedAuth();
}

