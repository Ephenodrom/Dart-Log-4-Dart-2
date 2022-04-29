import 'dart:math';

import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/LogRecord.dart';
import 'package:log_4_dart_2/src/LogRecordFormatter.dart';
import 'package:log_4_dart_2/src/appender/Appender.dart';

///
/// A appender for writing logs to the console output
///
class ConsoleAppender extends Appender {
  static const LOGGER_NAME = 'CONSOLE';

  @override
  void append(LogRecord logRecord) {
    logRecord.loggerName ??= getType();
    print(LogRecordFormatter.format(logRecord, format!, dateFormat: dateFormat, brackets: brackets));
    var tabs = '\t';
    if (logRecord.error != null) {
      print(tabs + logRecord.error.toString());
      tabs = tabs + tabs;
    }
    if (logRecord.stackTrace != null) {
      print(tabs + logRecord.stackTrace.toString());
    }
  }

  @override
  String toString() {
    return '$type $format $level $lineInfo';
  }

  @override
  Future<void>? init(Map<String, dynamic> config, bool test, DateTime? date) {
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
    if (config.containsKey('depthOffset')) {
      clientDepthOffset = config['depthOffset'];
    } else {
      clientDepthOffset = 0;
    }
    if (config.containsKey('brackets')) {
      brackets = config['brackets'];
    } else {
      brackets = false;
    }
    return null;
  }

  @override
  Appender getInstance() {
    return ConsoleAppender();
  }

  @override
  String getType() {
    return AppenderType.CONSOLE.name;
  }
}
