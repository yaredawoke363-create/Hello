import 'dart:developer' as developer;
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._();

  static late final Logger _logger;

  static void setup() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: Level.debug,
    );
  }

  static void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
    developer.log(
      message,
      name: 'DEBUG',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void info(String message) {
    _logger.i(message);
    developer.log(message, name: 'INFO');
  }

  static void warning(String message, {Object? error}) {
    _logger.w(message, error: error);
    developer.log(message, name: 'WARNING', error: error);
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    developer.log(
      message,
      name: 'ERROR',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void verbose(String message) {
    _logger.v(message);
  }

  static void wtf(String message) {
    _logger.wtf(message);
  }
}
