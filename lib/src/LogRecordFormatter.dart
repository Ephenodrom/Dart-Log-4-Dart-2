import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:log_4_dart_2/log_4_dart_2.dart';

import '../log_4_dart_2.dart';

class LogRecordFormatter {
  ///
  /// Converts the given [logRecord] to the given [format]
  ///
  static String format(LogRecord logRecord, String format) {
    if (format.contains('\%d')) {
      var date = DateFormat('yyyy-MM-dd HH:mm:ss').format(logRecord.time);
      format = format.replaceAll('\%d', date);
    }
    if (format.contains('\%t')) {
      format = format.replaceAll('\%t', logRecord.loggerName);
    }
    if (format.contains('\%l')) {
      format = format.replaceAll('\%l', logRecord.level.name);
    }
    if (format.contains('\%m')) {
      format = format.replaceAll('\%m', logRecord.message);
    }
    return format;
  }

  ///
  /// Converts the given [logRecord] to a json string for the [HttpAppender].
  ///
  static String formatJson(LogRecord logRecord) {
    var map = {
      'time': DateFormat('yyyy-MM-dd HH:mm:ss').format(logRecord.time),
      'message': logRecord.message,
      'level': logRecord.level.toString(),
      'tag': logRecord.loggerName,
    };

    return json.encode(map);
  }
}
