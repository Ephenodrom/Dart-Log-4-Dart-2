import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/appender/AppenderType.dart';

abstract class Appender {
  DateTime created;
  Level level;
  String format;
  AppenderType type;
  static String defaultFormat = '%d %t %l %m';

  void append(LogRecord logRecord);
}
