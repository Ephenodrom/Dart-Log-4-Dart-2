import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/LogRecord.dart';
import 'package:log_4_dart_2/src/LogRecordFormatter.dart';
import 'package:log_4_dart_2/src/appender/Appender.dart';

class ConsoleAppender extends Appender {
  ConsoleAppender() {
    created = DateTime.now();
    type = AppenderType.CONSOLE;
  }
  @override
  void append(LogRecord logRecord) {
    print(LogRecordFormatter.format(logRecord, format));
    if (logRecord.stackTrace != null) {
      print(logRecord.stackTrace.toString());
    }
  }

  @override
  String toString() {
    return '$type $format $level';
  }
}
