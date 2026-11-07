import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/app/core/constants/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/core/extensions/context_extensions.dart';
import 'package:{{project_name.snakeCase()}}/app/core/widgets/app_empty_state.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/presentation/providers/login_provider.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/presentation/screens/login_screen.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/widgets/home_header.dart';

class HomeScreen extends ConsumerWidget {
  static const path = '/home';
  static const name = 'home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(loginProvider, (prev, next) {
      if (next.status == LoginStatus.initial && next.auth == null) {
        context.go(LoginScreen.path);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.home.title),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            const HomeHeader(),
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.t.home.overview,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppEmptyState(
              icon: Icons.dashboard_customize_outlined,
              title: context.t.home.recentActivity,
              subtitle: context.t.home.noActivity,
            ),
          ],
        ),
      ),
    );
  }
}

