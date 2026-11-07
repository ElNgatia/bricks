import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/core/constants/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/core/extensions/context_extensions.dart';

class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 56, color: context.colors2.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colors2.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

