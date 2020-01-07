import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/LogRecord.dart';
import 'package:log_4_dart_2/src/LogRecordFormatter.dart';
import 'package:log_4_dart_2/src/appender/Appender.dart';

///
/// A appender for writing logs to the console output
///
class ConsoleAppender extends Appender {
  @override
  void append(LogRecord logRecord) {
    print(LogRecordFormatter.format(logRecord, format, dateFormat: dateFormat));
    if (logRecord.stackTrace != null) {
      print(logRecord.stackTrace.toString());
    }
  }

  @override
  String toString() {
    return '$type $format $level';
  }

  @override
  void init(Map<String, dynamic> config, bool test, DateTime date) {
    created = date ?? DateTime.now();
    type = AppenderType.CONSOLE;
    if (config.containsKey('format')) {
      format = config['format'];
    } else {
      format = Appender.defaultFormat;
    }
    if (config.containsKey('dateFormat')) {
      dateFormat = config['dateFormat'];
    } else {
      dateFormat = Appender.defaultDateFormat;
    }
    if (config.containsKey('level')) {
      level = Level.fromString(config['level']);
    } else {
      level = Level.INFO;
    }
  }

  @override
  Appender getInstance() {
    return ConsoleAppender();
  }

  @override
  String getType() {
    return 'CONSOLE';
  }
}
