import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/appender/AppenderType.dart';

///
/// The basic appender.
///
abstract class Appender {
  /// The date the appender was created
  DateTime created;

  /// The loglevel for the appender
  Level level;

  /// The logformat for the appender
  String format;

  /// The type of the appender
  AppenderType type;

  /// The default logging format
  static String defaultFormat = '%d %t %l %m';

  /// Appending the given [logRecord]
  void append(LogRecord logRecord);

  /// Setup the appender
  void init(Map<String, dynamic> config, bool test, DateTime date);
}
