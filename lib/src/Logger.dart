import 'dart:convert';
import 'dart:io';

import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/constants.dart';

import 'LoggerStackTrace.dart';

///
/// The logger.
///
class Logger {
  //implements LoggingInterface {
  /// All appenders for the logger.
  List<Appender> appenders = [];

  /// All registered appenders for the logger.
  List<Appender> registeredAppenders = [];

  int clientDepthOffset = 0;

  /// An tag that is passed to each log record. It can be used to connect log entries to a
  /// certain event in an application.
  String? tag;

  String? loggerName;

  static Logger? _singleton;

  //@Deprecated('Deprecated. Use: Logger.init(...)')
  // Logger() {
  //   throw Exception('Deprecated. Use: Logger.init(...)');
  // }

  factory Logger() {
    assert(_singleton != null, 'Logger.init(...) not yet called');
    return _singleton!;
  }

  Logger._(List<Appender> definedAppenders, List<Appender> activeAppenders,
      {int clientDepthOffset = 0}) {
    registeredAppenders = definedAppenders;
    appenders = activeAppenders;
    this.clientDepthOffset = clientDepthOffset;
  }

  Logger._empty();

  static Logger get instance {
    assert(_singleton != null, 'Logger.init(...) not yet called');
    return _singleton!;
  }

  ///
  /// Initialise the logger from the given [fileName].
  ///
  /// [fileName] has to the the full path to the file.
  ///
  static Future<bool> initFromFile(String fileName) async {
    var fileContents = File(fileName).readAsStringSync();
    var jsonData = json.decode(fileContents);
    return await init(jsonData);
  }

  ///
  /// Initialise the logger from the given [config].
  ///
  static Future<bool> init(Map<String, dynamic>? config,
      {bool test = false,
      DateTime? date,
      int clientProxyCallDepthOffset = 0}) async {
    if (config == null || config.isEmpty) {
      _singleton = Logger._empty();
      return true; // Some tests rely on defining this by code
    }
    var definedAppenders = <Appender>[
      ConsoleAppender(),
      FileAppender(),
      HttpAppender(),
      EmailAppender(),
      MySqlAppender()
    ];
    var activeAppenders = <Appender>[];
    for (Map<String, dynamic> app in config['appenders']) {
      if (!app.containsKey('type')) {
        throw ArgumentError('Missing type for appender');
      }
      for (var a in definedAppenders) {
        if (app['type'].toLowerCase() == a.getType().toLowerCase()) {
          var appender = a.getInstance();
          await appender.init(app, test, date);
          activeAppenders.add(appender);
        }
      }
    }
    _singleton = Logger._(definedAppenders, activeAppenders,
        clientDepthOffset: clientProxyCallDepthOffset);
    return true;
  }

  ///
  /// Iterate over each configured appender and append the logRecord.
  ///
  void log(Level logLevel, Object message, String? tag,
      [Object? error,
      StackTrace? stackTrace,
      Object? object,
      int depthOffset = 0]) {
    var totalDepthOffset = clientDepthOffset + depthOffset;
    var contextInfo = LoggerStackTrace.from(StackTrace.current,
        depthOffset: totalDepthOffset);
    var record = LogRecord(logLevel, message, tag, contextInfo,
        error: error,
        stackTrace: stackTrace,
        object: object,
        loggerName: loggerName);
    for (var app in appenders) {
      if (logLevel >= app.level!) {
        app.append(record);
      }
    }
  }

  ///
  /// Log message at level [Level.TRACE].
  ///
  @Deprecated('Use Logger.trace(...) or mixin Log4Dart with logTrace(...)')
  void logTrace(String? tag, Object message,
          [Object? error,
          StackTrace? stackTrace,
          Object? object,
          int depthOffset = 0]) =>
      log(Level.TRACE, message, tag, error, stackTrace, object, depthOffset);

  ///
  /// Log message at level [Level.DEBUG].
  ///
  @Deprecated('Use Logger.debug(...) or mixin Log4Dart with logDebug(...)')
  void logDebug(String? tag, Object message,
          [Object? error,
          StackTrace? stackTrace,
          Object? object,
          int depthOffset = 0]) =>
      log(Level.DEBUG, message, tag, error, stackTrace, object, depthOffset);

  ///
  /// Log message at level [Level.INFO].
  ///
  @Deprecated('Use Logger.info(...) or mixin Log4Dart with logInfo(...)')
  void logInfo(String tag, Object message,
          [Object? error,
          StackTrace? stackTrace,
          Object? object,
          int depthOffset = 0]) =>
      log(Level.INFO, message, tag, error, stackTrace, object, depthOffset);

  ///
  /// Log message at level [Level.WARNING].
  ///
  @Deprecated('Use Logger.warn(...) or mixin Log4Dart with logWarn(...)')
  void logWarning(String tag, Object message,
          [Object? error,
          StackTrace? stackTrace,
          Object? object,
          int depthOffset = 0]) =>
      log(Level.WARNING, message, tag, error, stackTrace, object, depthOffset);

  ///
  /// Log message at level [Level.ERROR].
  ///
  @Deprecated('Use Logger.error(...) or mixin Log4Dart with logError(...)')
  void logError(String tag, Object message,
          [Object? error,
          StackTrace? stackTrace,
          Object? object,
          int depthOffset = 0]) =>
      log(Level.ERROR, message, tag, error, stackTrace, object, depthOffset);

  ///
  /// Log message at level [Level.FATAL].
  ///
  @Deprecated('Use Logger.fatal(...) or mixin Log4Dart with logFatal(...)')
  void logFatal(String tag, Object message,
          [Object? error,
          StackTrace? stackTrace,
          Object? object,
          int depthOffset = 0]) =>
      log(Level.FATAL, message, tag, error, stackTrace, object, depthOffset);

  ///
  /// Log message at level [Level.TRACE].
  /// (as of version: 1.0.0)
  ///
  static void trace(Object message,
      {String? tag,
      Object? exception,
      StackTrace? stackTrace,
      Object? object}) {
    tag ??= '';
    Logger.instance.log(Level.TRACE, message, tag, exception?.toString(),
        stackTrace, object, kStackDepthOffset);
  }

  ///
  /// Log message at level [Level.DEBUG].
  /// (as of version: 1.0.0)
  ///
  static void debug(Object message,
      {String? tag,
      Object? exception,
      StackTrace? stackTrace,
      Object? object}) {
    tag ??= '';
    Logger.instance.log(Level.DEBUG, message, tag, exception?.toString(),
        stackTrace, object, kStackDepthOffset);
  }

  ///
  /// Log message at level [Level.INFO].
  /// (as of version: 1.0.0)
  ///
  static void info(Object message,
      {String? tag,
      Object? exception,
      StackTrace? stackTrace,
      Object? object}) {
    tag ??= '';
    Logger.instance.log(Level.INFO, message, tag, exception?.toString(),
        stackTrace, object, kStackDepthOffset);
  }

  ///
  /// Log message at level [Level.WARNING].
  /// (as of version: 1.0.0)
  ///
  static void warn(Object message,
      {String? tag,
      Object? exception,
      StackTrace? stackTrace,
      Object? object}) {
    tag ??= '';
    Logger.instance.log(Level.WARNING, message, tag, exception?.toString(),
        stackTrace, object, kStackDepthOffset);
  }

  ///
  /// Log message at level [Level.ERROR].
  /// (as of version: 1.0.0)
  ///
  static void error(Object message,
      {String? tag,
      Object? exception,
      StackTrace? stackTrace,
      Object? object}) {
    tag ??= '';
    Logger.instance.log(Level.ERROR, message, tag, exception?.toString(),
        stackTrace, object, kStackDepthOffset);
  }

  ///
  /// Log message at level [Level.FATAL].
  /// (as of version: 1.0.0)
  ///
  static void fatal(Object message,
      {String? tag,
      Object? exception,
      StackTrace? stackTrace,
      Object? object}) {
    tag ??= '';
    Logger.instance.log(Level.FATAL, message, tag, exception?.toString(),
        stackTrace, object, kStackDepthOffset);
  }

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
