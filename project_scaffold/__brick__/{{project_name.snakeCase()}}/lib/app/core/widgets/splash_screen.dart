import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/presentation/screens/login_screen.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/screens/home_screen.dart';
import 'package:{{project_name.snakeCase()}}/hive/hive_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const path = '/splash';
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final auth = HiveManager.instance.userBox.get('auth');
    if (auth != null && auth.token.isNotEmpty) {
      context.go(HomeScreen.path);
    } else {
      context.go(LoginScreen.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

