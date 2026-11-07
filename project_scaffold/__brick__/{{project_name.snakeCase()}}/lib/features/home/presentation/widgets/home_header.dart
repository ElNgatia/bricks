import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{project_name.snakeCase()}}/app/core/constants/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/core/extensions/context_extensions.dart';
import 'package:{{project_name.snakeCase()}}/app/core/extensions/name_initials.dart';
import 'package:{{project_name.snakeCase()}}/app/core/widgets/app_card.dart';
import 'package:{{project_name.snakeCase()}}/app/theme/theme_notifier.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/presentation/providers/login_provider.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/providers/home_provider.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final name = user?.name.isNotEmpty == true ? user!.name : 'User';

    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: context.colors2.primary.withValues(alpha: 0.15),
            child: Text(
              name.initials,
              style: TextStyle(
                color: context.colors2.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.t.home.welcome(name: name),
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colors2.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  user?.email ?? '',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors2.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              context.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: context.colors2.textSecondary,
            ),
            onPressed: () {
              final current = ref.read(themeProvider);
              ref.read(themeProvider.notifier).setTheme(
                    current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
                  );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: context.colors2.error),
            onPressed: () => ref.read(loginProvider.notifier).signOut(),
          ),
        ],
      ),
    );
  }
}

