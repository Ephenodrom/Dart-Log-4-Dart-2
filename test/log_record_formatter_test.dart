import 'package:intl/intl.dart';
import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/LogRecordFormatter.dart';
import 'package:log_4_dart_2/src/LoggerStackTrace.dart';
import 'package:test/test.dart';

void main() {
  test('Test format()', () {
    var contextInfo = LoggerStackTrace.from(StackTrace.current);

    var record = LogRecord(Level.INFO, 'Lorem Ipsum', 'TestClass', contextInfo, loggerName: 'uuid');

    var now = DateTime.now();
    record.time = now;
    var formatted = LogRecordFormatter.format(record, '%d %i %t %l %m');
    expect(formatted, '${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)} uuid TestClass INFO Lorem Ipsum');

    formatted = LogRecordFormatter.format(record, '%d %i %t %l: %m');
    expect(formatted, '${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)} uuid TestClass INFO: Lorem Ipsum');

    formatted = LogRecordFormatter.format(record, '%d %i %t %l: %m', dateFormat: 'yyyy-MM-dd');
    expect(formatted, '${DateFormat('yyyy-MM-dd').format(now)} uuid TestClass INFO: Lorem Ipsum');
  });
}
