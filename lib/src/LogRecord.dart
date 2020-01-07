import 'package:intl/intl.dart';

import 'Level.dart';

class LogRecord {
  /// The log level
  final Level level;

  /// The message
  final String message;

  /// Non-string message passed to Logger.
  final Object object;

  /// Logger where this record is stored.
  final String loggerName;

  /// Time when this record was created.
  DateTime time;

  /// Associated error (if any) when recording errors messages.
  final Object error;

  /// Associated stackTrace (if any) when recording errors messages.
  final StackTrace stackTrace;

  /// A unique identifier, that can be used to connect log entries to a certain event in an application.
  final String identifier;

  /// The dateformat for the time the record was created.
  final String dateFormat;

  LogRecord(this.level, this.message, this.loggerName,
      {this.error,
      this.stackTrace,
      this.object,
      this.identifier,
      this.dateFormat})
      : time = DateTime.now();

  @override
  String toString() => '[${level.name}] $loggerName: $message';

  ///
  /// Returns the log time in the format yyyy-MM-dd HH:mm:ss
  ///
  String getFormattedTime() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(time);
  }
}
