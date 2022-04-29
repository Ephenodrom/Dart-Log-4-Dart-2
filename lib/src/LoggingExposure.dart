import 'package:log_4_dart_2/src/constants.dart';

import 'Logger.dart';

class LoggingExposure {
  void logTrace(String message, {String? tag, Object? exception, StackTrace? stackTrace, Object? object}) {
    tag ??= '';
    Logger.instance.trace(tag, message, exception?.toString(), stackTrace, object, kStackDepthOffsetForLoggerExposureClass);
  }

  void logDebug(String message, {String? tag, Object? exception, StackTrace? stackTrace, Object? object}) {
    tag ??= '';
    Logger.instance.debug(tag, message, exception?.toString(), stackTrace, object, kStackDepthOffsetForLoggerExposureClass);
  }

  void logInfo(String message, {String? tag, Object? exception, StackTrace? stackTrace, Object? object}) {
    tag ??= '';
    Logger.instance.info(tag, message, exception?.toString(), stackTrace, object, kStackDepthOffsetForLoggerExposureClass);
  }

  void logWarn(String message, {String? tag, Object? exception, StackTrace? stackTrace, Object? object}) {
    tag ??= '';
    Logger.instance.warning(tag, message, exception?.toString(), stackTrace, object, kStackDepthOffsetForLoggerExposureClass);
  }

  void logError(String message, {String? tag, Object? exception, StackTrace? stackTrace, Object? object}) {
    tag ??= '';
    Logger.instance.error(tag, message, exception?.toString(), stackTrace, object, kStackDepthOffsetForLoggerExposureClass);
  }

  void logFatal(String message, {String? tag, Object? exception, StackTrace? stackTrace, Object? object}) {
    tag ??= '';
    Logger.instance.fatal(tag, message, exception?.toString(), stackTrace, object, kStackDepthOffsetForLoggerExposureClass);
  }
}
