import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:basic_utils/basic_utils.dart';
import 'package:intl/intl.dart';
import 'package:log_4_dart_2/log_4_dart_2.dart';

import '../log_4_dart_2.dart';
import 'constants.dart';

class LogRecordFormatter {
  ///
  /// Converts the given [logRecord] to the given [format].
  ///
  /// The [dateFormat] defines the format for the [LogRecord.time]
  ///
  static String format(LogRecord logRecord, String format, {String? dateFormat = 'yyyy-MM-dd HH:mm:ss', bool brackets = false}) {
    var open = '';
    var close = ' ';
    var fill = '';
    if (brackets) {
      open = kOpen;
      close = kClose;
      fill = ' ' * ('ERROR'.length - logRecord.level.name.length);
    }

    if (format.contains('\%d')) {
      var date = DateFormat(dateFormat).format(logRecord.time);
      format = format.replaceAll('\%d', open + date + close);
    }
    if (format.contains('\%t')) {
      if (!StringUtils.isNullOrEmpty(logRecord.tag)) {
        format = format.replaceAll('\%t', open + logRecord.tag! + close);
      } else {
        format = format.replaceAll('\%t', open + '' + close);
      }
    }

    if (format.contains('\%i')) {
      if (StringUtils.isNullOrEmpty(logRecord.loggerName)) {
        format = format.replaceAll('\%i', open + '' + close);
      } else {
        format = format.replaceAll('\%i', open + logRecord.loggerName! + close);
      }
    }
    if (format.contains('\%l')) {
      format = format.replaceAll('\%l', (open + logRecord.level.name + fill + close).trim());
    }

    if (format.contains('\%m')) {
      format = format.replaceAll('\%m', logRecord.message);
    }

    if (format.contains('\%c')) {
      var fn = logRecord.functionNameAndLine();
      format = format.replaceAll('\%c', open + fn + close);
    }
    if (format.contains('\%f')) {
      var ifl = logRecord.inFileLocation();
      if (ifl != null) {
        format = format.replaceAll('\%f', open + ifl + close);
      } else {
        format = format.replaceAll('\%f', open + ':' + close);
      }
    }

    // MDC: https://logging.apache.org/log4j/2.x/manual/thread-context.html
    if (format.contains('\%X')) {
      format.split('%X').forEach((element) {
        if (element.startsWith('{')) {
          var mdcKey = element.substring(1, element.indexOf('}'));
          List<dynamic> values = Zone.current[mdcKey];
          if (values.isNotEmpty) {
            format = format.replaceAll('%X{$mdcKey}', open + values[0].toString() + close);
          } else {
            format = format.replaceAll('%X{$mdcKey}', open + close);
          }
        }
      });
    }

    format = format.replaceAll('  ', ' ');
    return format;
  }

  ///
  /// Converts the given [logRecord] to a json string for the [HttpAppender].
  ///
  /// The [dateFormat] defines the format for the [LogRecord.time]
  ///
  static String formatJson(LogRecord logRecord, {String? dateFormat = 'yyyy-MM-dd HH:mm:ss.SSS'}) {
    var map = {
      'time': DateFormat(dateFormat).format(logRecord.time),
      'message': logRecord.message,
      'level': logRecord.level.toString(),
      'tag': logRecord.tag,
    };

    return json.encode(map);
  }

  ///
  /// Maps the given [logRecord] to the given [template].
  ///
  /// If [template] is null, it will return the logRecord as JSON.
  ///
  /// The [dateFormat] defines the format for the [LogRecord.time]
  ///
  static String formatEmail(String? template, LogRecord logRecord, {String? dateFormat = 'yyyy-MM-dd HH:mm:ss'}) {
    if (template == null) {
      return formatJson(logRecord, dateFormat: dateFormat);
    }
    return format(logRecord, template);
  }
}
