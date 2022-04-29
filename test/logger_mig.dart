import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:test/test.dart';

const kLog4DartConfig = {
  'appenders': [
    {
      'type': 'CONSOLE',
      'format': '%d%i%t%l%c %m %f',
      'level': 'TRACE',
      'dateFormat': 'yyyy-MM-dd HH:mm:ss.SSS',
      'brackets': true,
      'mode': 'stdout', // see ConsoleLoggerMode
    },
  ]
};

void main() {
  test('Demo', () async {
    await Logger.init(kLog4DartConfig);
    var plainClient = PlainClient();
    plainClient.doStuff();
    var clientWith = ClientWith();
    clientWith.doStuff();
  });
}

class PlainClient {
  void doStuff() {
    Logger.instance.logDebug('tag', 'message');
    Logger().logDebug('tag', 'message');
    Logger.debug('message', tag: 'tag');
  }
}

class ClientWith with Log4Dart {
  void doStuff() {
    logDebug('debug', tag: 'tag');
  }
}
