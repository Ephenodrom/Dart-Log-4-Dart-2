import 'dart:convert';
import 'dart:io';

import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/appender/Appender.dart';
import 'package:log_4_dart_2/src/appender/EmailAppender.dart';
import 'package:log_4_dart_2/src/appender/HttpAppender.dart';
import 'package:log_4_dart_2/src/appender/MySqlAppender.dart';

import 'Level.dart';

///
/// The logger
///
class Logger {
  List<Appender> appenders = [];

  static final Logger _singleton = Logger._internal();

  factory Logger() {
    return _singleton;
  }

  Logger._internal();

  ///
  /// Initialise the logger from the given [fileName].
  ///
  /// [fileName] has to the the full path to the file.
  ///
  void initFromFile(String fileName) {
    var fileContents = File(fileName).readAsStringSync();
    var jsonData = json.decode(fileContents);
    init(jsonData);
  }

  ///
  /// Initialise the logger from the given [config].
  ///
  void init(Map<String, dynamic> config) {
    for (Map<String, dynamic> app in config['appenders']) {
      if (!app.containsKey('type')) {
        throw ArgumentError('Missing type for appender');
      }
      if (app['type'].toLowerCase() ==
          AppenderType.CONSOLE.valueAsString().toLowerCase()) {
        var console = ConsoleAppender();
        console.init(app);
        appenders.add(console);
      } else if (app['type'].toLowerCase() ==
          AppenderType.FILE.valueAsString().toLowerCase()) {
        var file = FileAppender();
        file.init(app);
        appenders.add(file);
      } else if (app['type'].toLowerCase() ==
          AppenderType.HTTP.valueAsString().toLowerCase()) {
        var http = HttpAppender();
        http.init(app);
        appenders.add(http);
      } else if (app['type'].toLowerCase() ==
          AppenderType.EMAIL.valueAsString().toLowerCase()) {
        var email = EmailAppender();
        email.init(app);
        appenders.add(email);
      } else if (app['type'].toLowerCase() ==
          AppenderType.MYSQL.valueAsString().toLowerCase()) {
        var mysql = MySqlAppender();
        mysql.init(app);
        appenders.add(mysql);
      }
    }
  }

  ///
  /// Iterate over each configured appender and append the logRecord.
  ///
  void log(Level logLevel, String tag, message,
      [Object error, StackTrace stackTrace, Object object]) {
    var record = LogRecord(logLevel, message, tag,
        error: error, stackTrace: stackTrace, object: object);
    for (var app in appenders) {
      if (logLevel >= app.level) {
        app.append(record);
      }
    }
  }

  ///
  /// Log message at level [Level.DEBUG].
  ///
  void debug(String tag, message,
          [Object error, StackTrace stackTrace, Object object]) =>
      log(Level.DEBUG, tag, message, error, stackTrace, object);

  ///
  /// Log message at level [Level.TRACE].
  ///
  void trace(String tag, message,
          [Object error, StackTrace stackTrace, Object object]) =>
      log(Level.TRACE, tag, message, error, stackTrace, object);

  ///
  /// Log message at level [Level.INFO].
  ///
  void info(String tag, message,
          [Object error, StackTrace stackTrace, Object object]) =>
      log(Level.INFO, tag, message, error, stackTrace, object);

  ///
  /// Log message at level [Level.WARNING].
  ///
  void warning(String tag, message,
          [Object error, StackTrace stackTrace, Object object]) =>
      log(Level.WARNING, tag, message, error, stackTrace, object);

  ///
  /// Log message at level [Level.ERROR].
  ///
  void error(String tag, message,
          [Object error, StackTrace stackTrace, Object object]) =>
      log(Level.ERROR, tag, message, error, stackTrace, object);

  ///
  /// Log message at level [Level.FATAL].
  ///
  void fatal(String tag, message,
          [Object error, StackTrace stackTrace, Object object]) =>
      log(Level.FATAL, tag, message, error, stackTrace, object);
}
