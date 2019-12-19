import 'package:intl/intl.dart';
import 'package:log_4_dart_2/log_4_dart_2.dart';

class LogRecordFormatter {
  static String format(LogRecord logRecord, String format) {
    var formatted = format;
    if (formatted.contains('\%d')) {
      var date = DateFormat('yyyy-MM-dd HH:mm:ss').format(logRecord.time);
      formatted = formatted.replaceAll('\%d', date);
    }
    if (formatted.contains('\%t')) {
      formatted = formatted.replaceAll('\%t', logRecord.loggerName);
    }
    if (formatted.contains('\%l')) {
      formatted = formatted.replaceAll('\%l', logRecord.level.name);
    }
    if (formatted.contains('\%m')) {
      formatted = formatted.replaceAll('\%m', logRecord.message);
    }
    return formatted;
  }
}
