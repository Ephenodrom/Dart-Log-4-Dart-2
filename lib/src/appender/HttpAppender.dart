import 'package:basic_utils/basic_utils.dart';
import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/LogRecord.dart';
import 'package:log_4_dart_2/src/LogRecordFormatter.dart';
import 'package:log_4_dart_2/src/appender/Appender.dart';

///
/// A appender for sending log entries via http
///
class HttpAppender extends Appender {
  String url;
  Map<String, String> headers;

  @override
  void append(LogRecord logRecord) {
    var body = LogRecordFormatter.formatJson(logRecord);
    HttpUtils.postForFullResponse(url, body, headers: headers);
  }

  @override
  String toString() {
    return '$type $url $level';
  }

  @override
  void init(Map<String, dynamic> config) {
    created = DateTime.now();
    type = AppenderType.HTTP;
    if (config.containsKey('level')) {
      level = Level.fromString(config['level']);
    } else {
      level = Level.INFO;
    }
  }
}
