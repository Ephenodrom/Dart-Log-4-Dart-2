import 'Logger.dart';

/// Meant to be mixed into client classes that need login.
///
/// class Client with Log4Dart {
///     ...
///     logDebug(...);
///     ...
///
/// Alternatively, use Logger.debug(...) etc directly.
///
/// In either case, call Logger.init(config) once in main!
class Log4Dart {
  void logTrace(Object message, {String? tag, Object? exception, StackTrace? stackTrace, Object? object}) {
    Logger.trace(message, tag: tag, exception: exception, stackTrace: stackTrace, object: object);
  }

  void logDebug(Object message, {String? tag, Object? exception, StackTrace? stackTrace, Object? object}) {
    Logger.debug(message, tag: tag, exception: exception, stackTrace: stackTrace, object: object);
  }

  void logInfo(Object message, {String? tag, Object? exception, StackTrace? stackTrace, Object? object}) {
    Logger.info(message, tag: tag, exception: exception, stackTrace: stackTrace, object: object);
  }

  void logWarn(Object message, {String? tag, Object? exception, StackTrace? stackTrace, Object? object}) {
    Logger.warn(message, tag: tag, exception: exception, stackTrace: stackTrace, object: object);
  }

  void logError(Object message, {String? tag, Object? exception, StackTrace? stackTrace, Object? object}) {
    Logger.error(message, tag: tag, exception: exception, stackTrace: stackTrace, object: object);
  }

  void logFatal(Object message, {String? tag, Object? exception, StackTrace? stackTrace, Object? object}) {
    Logger.fatal(message, tag: tag, exception: exception, stackTrace: stackTrace, object: object);
  }
}
