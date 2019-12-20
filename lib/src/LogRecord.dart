import 'package:intl/intl.dart';

import 'Level.dart';

class LogRecord {
  final Level level;
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

  LogRecord(this.level, this.message, this.loggerName,
      {this.error, this.stackTrace, this.object})
      : time = DateTime.now();

  @override
  String toString() => '[${level.name}] $loggerName: $message';

  String getFormattedTime() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(time);
  }
}
