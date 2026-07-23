/// Unified error handling untuk aplikasi
class AppError implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppError({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppError: $message';
}

/// Auth Error
class AuthError extends AppError {
  AuthError({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code,
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

/// Firestore Error
class FirestoreError extends AppError {
  FirestoreError({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code,
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

/// Network Error
class NetworkError extends AppError {
  NetworkError({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code,
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

/// Validation Error
class ValidationError extends AppError {
  ValidationError({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code,
    originalError: originalError,
    stackTrace: stackTrace,
  );
}
