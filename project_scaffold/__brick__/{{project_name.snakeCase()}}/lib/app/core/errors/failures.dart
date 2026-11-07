import 'package:dio/dio.dart';

/// Base class for all application exceptions.
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

/// Exception when there's no network connection.
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
  });
}

/// Exception for server errors (5xx).
class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error. Please try again later.',
    super.statusCode,
  });
}

/// Exception for unauthorized access (401).
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Session expired. Please login again.',
    super.statusCode = 401,
  });
}

/// Exception for forbidden access (403).
class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'You do not have permission to perform this action.',
    super.statusCode = 403,
  });
}

/// Exception for validation errors (400).
class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  const ValidationException({
    super.message = 'Validation failed. Please check your input.',
    super.statusCode = 400,
    this.errors,
  });
}

/// Exception for unknown errors.
class UnknownException extends AppException {
  const UnknownException({
    super.message = 'Something went wrong. Please try again.',
  });
}

/// Maps DioException to typed AppException.
AppException mapDioException(DioException e) {
  if (e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout) {
    return const NetworkException();
  }

  if (e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return const NetworkException(
      message: 'The server is taking too long to respond. Please try again.',
    );
  }

  final statusCode = e.response?.statusCode;
  final data = e.response?.data;

  String? serverMessage;
  Map<String, dynamic>? validationErrors;

  if (data is Map<String, dynamic>) {
    serverMessage = data['message'] as String?;
    if (data['errors'] is Map<String, dynamic>) {
      validationErrors = data['errors'] as Map<String, dynamic>;
    }
  }

  switch (statusCode) {
    case 400:
      return ValidationException(
        message: serverMessage ?? 'Validation failed. Please check your input.',
        statusCode: statusCode,
        errors: validationErrors,
      );
    case 401:
      return UnauthorizedException(
        message: serverMessage ?? 'Session expired. Please login again.',
        statusCode: statusCode,
      );
    case 403:
      return ForbiddenException(
        message: serverMessage ?? 'You do not have permission to perform this action.',
        statusCode: statusCode,
      );
    case 500:
    case 502:
    case 503:
    case 504:
      return ServerException(
        message: serverMessage ?? 'Server error. Please try again later.',
        statusCode: statusCode,
      );
    default:
      return UnknownException(
        message: serverMessage ?? 'Something went wrong. Please try again.',
      );
  }
}

