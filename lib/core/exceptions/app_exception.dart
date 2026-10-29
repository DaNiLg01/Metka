/// Базовый класс для всех исключений приложения
class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => 'AppException: $message (Code: $code)';
}

/// Исключение, связанное с ошибкой базы данных
class DatabaseException extends AppException {
  DatabaseException(String message) : super(message, 'DB_ERROR');
}

/// Исключение, связанное с сетью (на будущее, если добавим синхронизацию)
class NetworkException extends AppException {
  NetworkException(String message) : super(message, 'NETWORK_ERROR');
}