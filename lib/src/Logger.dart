import 'dart:convert';
import 'dart:io';

import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/appender/Appender.dart';

import 'Level.dart';

///
/// The logger.
///
class Logger {
  /// All appenders for the logger.
  List<Appender> appenders = [];

  /// All registered appenders for the logger.
  List<Appender> registeredAppenders = [];

  /// An identifier that is passed to each log record. It can be used to connect log entries to a certain event in an application.
  String? identifier;

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
  void initFromFile(String fileName) async {
    var fileContents = File(fileName).readAsStringSync();
    var jsonData = json.decode(fileContents);
    await init(jsonData);
  }

  ///
  /// Initialise the logger from the given [config].
  ///
  Future<void> init(Map<String, dynamic> config, {bool test = false, DateTime? date}) async {
    if (registeredAppenders.isEmpty) {
      registerAllAppender([ConsoleAppender(), FileAppender(), HttpAppender(), EmailAppender(), MySqlAppender()]);
    }
    reset();
    for (Map<String, dynamic> app in config['appenders']) {
      if (!app.containsKey('type')) {
        throw ArgumentError('Missing type for appender');
      }
      for (var a in registeredAppenders) {
        if (app['type'].toLowerCase() == a.getType().toLowerCase()) {
          var appender = a.getInstance();
          await appender.init(app, test, date);
          appenders.add(appender);
        }
      }
    }
  }

  ///
  /// Iterate over each configured appender and append the logRecord.
  ///
  void log(Level logLevel, String tag, String message, [Object? error, StackTrace? stackTrace, Object? object]) {
    var record = LogRecord(logLevel, message, tag, error: error, stackTrace: stackTrace, object: object, identifier: identifier);
    for (var app in appenders) {
      if (logLevel >= app.level!) {
        app.append(record);
      }
    }
  }

  ///
  /// Log message at level [Level.DEBUG].
  ///
  void debug(String tag, String message, [Object? error, StackTrace? stackTrace, Object? object]) => log(Level.DEBUG, tag, message, error, stackTrace, object);

  ///
  /// Log message at level [Level.TRACE].
  ///
  void trace(String tag, String message, [Object? error, StackTrace? stackTrace, Object? object]) => log(Level.TRACE, tag, message, error, stackTrace, object);

  ///
  /// Log message at level [Level.INFO].
  ///
  void info(String tag, String message, [Object? error, StackTrace? stackTrace, Object? object]) => log(Level.INFO, tag, message, error, stackTrace, object);

  ///
  /// Log message at level [Level.WARNING].
  ///
  void warning(String tag, String message, [Object? error, StackTrace? stackTrace, Object? object]) =>
      log(Level.WARNING, tag, message, error, stackTrace, object);

  ///
  /// Log message at level [Level.ERROR].
  ///
  void error(String tag, String message, [Object? error, StackTrace? stackTrace, Object? object]) => log(Level.ERROR, tag, message, error, stackTrace, object);

  ///
  /// Log message at level [Level.FATAL].
  ///
  void fatal(String tag, String message, [Object? error, StackTrace? stackTrace, Object? object]) => log(Level.FATAL, tag, message, error, stackTrace, object);

  ///
  /// Adds a custom appender to the list of appenders.
  ///
  void addCustomAppender(Appender appender) {
    appenders.add(appender);
  }

  ///
  /// Resets the logger and remove all appender and their configuration.
  ///
  void reset() {
    appenders.clear();
  }

  ///
  /// Register an appender for the logger.
  ///
  void registerAppender(Appender appender) {
    registeredAppenders.add(appender);
  }

  ///
  /// Register a list of appender for the logger.
  ///
  void registerAllAppender(List<Appender> appender) {
    registeredAppenders.addAll(appender);
  }
}
