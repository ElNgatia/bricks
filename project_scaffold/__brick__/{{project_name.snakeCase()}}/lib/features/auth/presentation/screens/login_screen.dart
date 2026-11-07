import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/app/core/constants/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/core/extensions/context_extensions.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/presentation/providers/login_provider.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/presentation/widgets/login_form.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/screens/home_screen.dart';

class LoginScreen extends ConsumerWidget {
  static const path = '/login';
  static const name = 'login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<LoginState>(loginProvider, (prev, next) {
      if (next.status == LoginStatus.success) {
        context.go(HomeScreen.path);
      } else if (next.status == LoginStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: context.colors2.error,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.t.auth.login.welcomeBack,
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: context.colors2.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    context.t.auth.login.subtitle,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colors2.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const LoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

