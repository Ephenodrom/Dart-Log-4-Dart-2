import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:test/test.dart';

void main() {
  const kLog4DartConfig = {
    'appenders': [
      {
        'type': 'CONSOLE',
        'format': '%d%i%t%l%c %m %f',
        'level': 'TRACE',
        'dateFormat': 'yyyy-MM-dd HH:mm:ss.SSS',
        'brackets': true,
      },
    ]
  };

  test('Test', () async {
    await Logger.init(kLog4DartConfig);
    var client = Client();
    client.doStuff();
  });
}

class Client with Log4Dart {
  void doStuff() {
    logDebug(() => [1, 2, 3, 4, 5].map((e) => e * 4).join("-"));
  }
}
