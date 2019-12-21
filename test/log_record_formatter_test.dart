import 'package:intl/intl.dart';
import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/LogRecordFormatter.dart';
import 'package:test/test.dart';

void main() {
  test('Test format()', () {
    var record = LogRecord(Level.INFO, 'Lorem Ipsum', 'TestClass');
    var now = DateTime.now();
    record.time = now;
    var formatted = LogRecordFormatter.format(record, '%d %t %l %m');
    expect(formatted,
        '${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)} TestClass INFO Lorem Ipsum');

    formatted = LogRecordFormatter.format(record, '%d %t %l: %m');
    expect(formatted,
        '${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)} TestClass INFO: Lorem Ipsum');
  });
}
