import 'dart:convert';
import 'dart:io';

import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/appender/Appender.dart';

import 'Level.dart';

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
        if (app.containsKey('format')) {
          console.format = app['format'];
        } else {
          console.format = Appender.defaultFormat;
        }
        if (app.containsKey('level')) {
          console.level = Level.fromString(app['level']);
        } else {
          console.level = Level.INFO;
        }
        appenders.add(console);
      } else if (app['type'].toLowerCase() ==
          AppenderType.FILE.valueAsString().toLowerCase()) {
        var file = FileAppender();
        if (app.containsKey('format')) {
          file.format = app['format'];
        } else {
          file.format = Appender.defaultFormat;
        }
        if (app.containsKey('filePattern')) {
          file.filePattern = app['filePattern'];
        } else {
          throw ArgumentError('Missing file argument for file appender');
        }
        if (app.containsKey('fileExtension')) {
          file.fileExtension = app['fileExtension'];
        }
        if (app.containsKey('rotationCycle')) {
          file.rotationCycle = app['rotationCycle'].toRotationCycle();
        }
        if (app.containsKey('level')) {
          file.level = Level.fromString(app['level']);
        } else {
          file.level = Level.INFO;
        }
        if (app.containsKey('path')) {
          file.path = app['path'];
        }
        appenders.add(file);
      }
    }
  }

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

  /// Log message at level [Level.DEBUG].
  void debug(String tag, message,
          [Object error, StackTrace stackTrace, Object object]) =>
      log(Level.DEBUG, tag, message, error, stackTrace, object);

  /// Log message at level [Level.TRACE].
  void trace(String tag, message,
          [Object error, StackTrace stackTrace, Object object]) =>
      log(Level.TRACE, tag, message, error, stackTrace, object);

  /// Log message at level [Level.INFO].
  void info(String tag, message,
          [Object error, StackTrace stackTrace, Object object]) =>
      log(Level.INFO, tag, message, error, stackTrace, object);

  /// Log message at level [Level.WARNING].
  void warning(String tag, message,
          [Object error, StackTrace stackTrace, Object object]) =>
      log(Level.WARNING, tag, message, error, stackTrace, object);

  /// Log message at level [Level.ERROR].
  void error(String tag, message,
          [Object error, StackTrace stackTrace, Object object]) =>
      log(Level.ERROR, tag, message, error, stackTrace, object);

  /// Log message at level [Level.FATAL].
  void fatal(String tag, message,
          [Object error, StackTrace stackTrace, Object object]) =>
      log(Level.FATAL, tag, message, error, stackTrace, object);
}
