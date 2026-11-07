import 'dart:math';

import 'package:{{project_name.snakeCase()}}/app/core/errors/failures.dart';

/// Retry policy for failed providers: exponential backoff for transient
/// failures, none for errors a retry can't fix (auth, permission, validation).
Duration? providerRetry(int retryCount, Object error) {
  if (error is Error) return null;
  if (error is UnauthorizedException ||
      error is ForbiddenException ||
      error is ValidationException) {
    return null;
  }
  if (retryCount >= 3) return null;

  return Duration(milliseconds: min(500 * pow(2, retryCount).toInt(), 4000));
}
