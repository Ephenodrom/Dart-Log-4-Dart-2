import 'dart:async';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/LogRecord.dart';
import 'package:log_4_dart_2/src/LogRecordFormatter.dart';
import 'package:log_4_dart_2/src/appender/Appender.dart';
import 'dart:developer' as devtools;

/// Set devtools this when running on the physical app or on webbrowser. Will log to dart:devtools. This way, the result
/// will not be a simple string, but the passed in objects (error etc.)
enum ConsoleLoggerMode { stdout, devtools }

///
/// A appender for writing logs to the console output
///
class ConsoleAppender extends Appender {
  static const LOGGER_NAME = 'CONSOLE';

  ConsoleLoggerMode mode = ConsoleLoggerMode.stdout;

  // for devtools logging
  int sequenceNumber = 1;

  @override
  void append(LogRecord logRecord) {
    logRecord.loggerName ??= getType();

    if (mode == ConsoleLoggerMode.devtools) {
      // void log(
      //   String message,
      //   {DateTime? time,
      //   int? sequenceNumber,
      //   int level = 0,
      //   String name = '',
      //   Zone? zone,
      //   Object? error,
      //   StackTrace? stackTrace}
      // )
      devtools.log(
        LogRecordFormatter.eval(logRecord.message),
        time: logRecord.time,
        sequenceNumber: sequenceNumber++,
        level: logRecord.level.value,
        name: '${logRecord.tag}',
        zone: Zone.current,
        error: logRecord.error,
        stackTrace: logRecord.stackTrace,
      );
    } else {
      print(LogRecordFormatter.format(logRecord, format!, dateFormat: dateFormat, brackets: brackets));
    }

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
    if (config.containsKey('mode')) {
      if (config['mode'] == 'stdout') {
        mode = ConsoleLoggerMode.stdout;
      } else if (config['mode'] == 'devtools') {
        mode = ConsoleLoggerMode.devtools;
      }
    } else {
      mode = ConsoleLoggerMode.stdout;
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
