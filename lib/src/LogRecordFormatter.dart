import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:intl/intl.dart';
import 'package:log_4_dart_2/log_4_dart_2.dart';

import '../log_4_dart_2.dart';

class LogRecordFormatter {
  ///
  /// Converts the given [logRecord] to the given [format].
  ///
  /// The [dateFormat] defines the format for the [LogRecord.time]
  ///
  static String format(LogRecord logRecord, String format,
      {String dateFormat = 'yyyy-MM-dd HH:mm:ss'}) {
    if (format.contains('\%d')) {
      var date = DateFormat(dateFormat).format(logRecord.time);
      format = format.replaceAll('\%d', date);
    }
    if (format.contains('\%t')) {
      format = format.replaceAll('\%t', logRecord.loggerName);
    }
    if (format.contains('\%i')) {
      if (StringUtils.isNullOrEmpty(logRecord.identifier)) {
        format = format.replaceAll('\%i', '');
      } else {
        format = format.replaceAll('\%i', logRecord.identifier);
      }
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
  /// The [dateFormat] defines the format for the [LogRecord.time]
  ///
  static String formatJson(LogRecord logRecord,
      {String dateFormat = 'yyyy-MM-dd HH:mm:ss'}) {
    var map = {
      'time': DateFormat(dateFormat).format(logRecord.time),
      'message': logRecord.message,
      'level': logRecord.level.toString(),
      'tag': logRecord.loggerName,
    };

    return json.encode(map);
  }
}
