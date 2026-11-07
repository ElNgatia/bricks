import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/app/core/widgets/splash_screen.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/presentation/screens/login_screen.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/screens/home_screen.dart';
import 'package:{{project_name.snakeCase()}}/hive/hive_service.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

bool _isAuthenticated() {
  final auth = HiveManager.instance.userBox.get('auth');
  return auth != null && auth.token.isNotEmpty;
}

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: false,
  initialLocation: SplashScreen.path,
  redirect: (context, state) {
    if (state.matchedLocation == SplashScreen.path) {
      return null;
    }

    final isLoggedIn = _isAuthenticated();
    final isLoggingIn = state.matchedLocation == LoginScreen.path;

    if (!isLoggedIn && !isLoggingIn) {
      return LoginScreen.path;
    }

    if (isLoggedIn && isLoggingIn) {
      return HomeScreen.path;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: SplashScreen.path,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: LoginScreen.path,
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: HomeScreen.path,
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);

