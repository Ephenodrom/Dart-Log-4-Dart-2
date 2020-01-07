import 'package:basic_utils/basic_utils.dart';
import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/LogRecord.dart';
import 'package:log_4_dart_2/src/LogRecordFormatter.dart';
import 'package:log_4_dart_2/src/appender/Appender.dart';

///
/// A appender for sending log entries via http
///
class HttpAppender extends Appender {
  /// The destination for the http post request
  String url;

  /// The headers to send with the request
  Map<String, String> headers;

  @override
  void append(LogRecord logRecord) {
    var body = LogRecordFormatter.formatJson(logRecord, dateFormat: dateFormat);
    HttpUtils.postForFullResponse(url, body, headers: headers);
  }

  @override
  String toString() {
    return '$type $url $level';
  }

  @override
  void init(Map<String, dynamic> config, bool test, DateTime date) {
    created = date ?? DateTime.now();
    type = AppenderType.HTTP;
    if (config.containsKey('level')) {
      level = Level.fromString(config['level']);
    } else {
      level = Level.INFO;
    }
    if (config.containsKey('dateFormat')) {
      dateFormat = config['dateFormat'];
    } else {
      dateFormat = Appender.defaultDateFormat;
    }
    if (config.containsKey('url')) {
      url = config['url'];
    } else {
      throw ArgumentError('Missing url argument for HttpAppender');
    }
    headers = {};
    if (config.containsKey('headers')) {
      List<String> h = config['headers'];
      for (var s in h) {
        var splitted = s.split(':');
        headers.putIfAbsent(splitted.elementAt(0), () => splitted.elementAt(1));
      }
    }
  }

  @override
  Appender getInstance() {
    return HttpAppender();
  }

  @override
  String getType() {
    return 'HTTP';
  }
}
