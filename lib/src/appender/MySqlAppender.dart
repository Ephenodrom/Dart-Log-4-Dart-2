import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/LogRecord.dart';
import 'package:log_4_dart_2/src/appender/Appender.dart';

///
/// A appender for sending log entries via http
///
class MySqlAppender extends Appender {
  String url;
  Map<String, String> headers;

  @override
  void append(LogRecord logRecord) {}

  @override
  String toString() {
    return '$type $url $level';
  }

  @override
  void init(Map<String, dynamic> config) {
    created = DateTime.now();
    type = AppenderType.MYSQL;
    if (config.containsKey('level')) {
      level = Level.fromString(config['level']);
    } else {
      level = Level.INFO;
    }
  }
}
