import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/appender/AppenderType.dart';

///
/// The basic appender.
///
abstract class Appender {
  /// The date the appender was created.
  late DateTime created;

  /// The loglevel for the appender.
  Level? level;

  int? clientDepthOffset;

  String? lineInfo;

  /// The logformat for the appender.
  String? format;

  /// The type of the appender.
  AppenderType? type;

  /// The default logging format.
  static String defaultFormat = '%d %t %l %m %f';

  /// The default date format.
  static String defaultDateFormat = 'yyyy-MM-dd HH:mm:ss';

  /// The dateformat used for the appender.
  String? dateFormat;

  bool brackets = false;

  ///
  /// Appending the given [logRecord].
  ///
  void append(LogRecord logRecord);

  ///
  /// Setup the appender. This needs to be called for every appender to configure the appender with the necessary data.
  ///
  Future<void>? init(Map<String, dynamic> config, bool test, DateTime? date);

  ///
  /// Retuns a new instance of the appender.
  ///
  Appender getInstance();

  ///
  /// Returns the type of the appender.
  ///
  String getType();
}
