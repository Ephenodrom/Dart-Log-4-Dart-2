import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/appender/AppenderType.dart';
import 'package:log_4_dart_2/src/appender/RotationCycle.dart';
import 'package:test/test.dart';

void main() {
  test('Test init()', () {
    var config = {
      'appenders': [
        {'type': 'CONSOLE', 'format': '%d %t %l %m', 'level': 'INFO'},
        {
          'type': 'FILE',
          'format': '%d %t %l %m',
          'level': 'INFO',
          'filePattern': 'log4dart2_log',
          'fileExtension': 'txt',
          'path': '/path/to/'
        },
      ],
    };
    Logger().init(config);

    expect(Logger().appenders.length, 2);

    var console = Logger().appenders.elementAt(0) as ConsoleAppender;
    expect(console.type, AppenderType.CONSOLE);
    expect(console.format, '%d %t %l %m');
    expect(console.level, Level.INFO);

    var file = Logger().appenders.elementAt(1) as FileAppender;

    expect(file.type, AppenderType.FILE);
    expect(file.format, '%d %t %l %m');
    expect(file.level, Level.INFO);
    expect(file.filePattern, 'log4dart2_log');
    expect(file.rotationCycle, RotationCycle.NEVER);
    expect(file.path, '/path/to/');
  });
}
