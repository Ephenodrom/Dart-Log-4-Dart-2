import 'package:intl/intl.dart';
import 'package:log_4_dart_2/src/LoggerStackTrace.dart';

import 'Level.dart';

class LogRecord {
  /// The log level
  final Level level;

  /// The message
  final Object message;

  /// Non-string message passed to Logger.
  final Object? object;

  /// Logger where this record is stored.
  String? loggerName;

  /// Time when this record was created.
  DateTime time;

  /// Associated error (if any) when recording errors messages.
  final Object? error;

  /// Associated stackTrace (if any) when recording errors messages.
  final StackTrace? stackTrace;

  /// A unique tag, that can be used to connect log entries to a certain event in an application.
  final String? tag;

  /// The dateformat for the time the record was created.
  final String? dateFormat;

  final LoggerStackTrace contextInfo;

  LogRecord(this.level, this.message, this.tag, this.contextInfo, {this.error, this.stackTrace, this.object, this.loggerName, this.dateFormat})
      : time = DateTime.now();

  @override
  String toString() => '[${level.name}] $tag: $message';

  ///
  /// Returns the log time in the format yyyy-MM-dd HH:mm:ss
  ///
  String getFormattedTime() {
    return DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(time);
  }

  String functionNameAndLine() {
    return '${contextInfo.functionName}:${contextInfo.lineNumber}';
  }

  String? inFileLocation() {
    return '${contextInfo.fileName}(${contextInfo.lineNumber}:${contextInfo.columnNumber})';
  }
}
