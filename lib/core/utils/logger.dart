import 'dart:developer' as developer;

class AppLogger {
  static const String _appName = 'IWish';

  static void info(String message, [String? tag]) {
    developer.log(
      message,
      name: tag ?? _appName,
      level: 800,
    );
  }

  static void error(String message,
      [Object? error, StackTrace? stackTrace, String? tag]) {
    developer.log(
      message,
      name: tag ?? _appName,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void warning(String message, [String? tag]) {
    developer.log(
      message,
      name: tag ?? _appName,
      level: 900,
    );
  }

  static void debug(String message, [String? tag]) {
    developer.log(
      message,
      name: tag ?? _appName,
      level: 700,
    );
  }
}
