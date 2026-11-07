import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/core/constants/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/core/extensions/context_extensions.dart';

class AppDialogs {
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: ctx.textTheme.titleMedium),
        content: Text(message, style: ctx.textTheme.bodyMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(cancelText),
          ),
          FilledButton(
            style: isDestructive
                ? FilledButton.styleFrom(backgroundColor: ctx.colors2.error)
                : null,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}

