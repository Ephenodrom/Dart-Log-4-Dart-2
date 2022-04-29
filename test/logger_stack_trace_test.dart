import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:test/test.dart';

/// TODO: turn this into actual test. These are simply 'runners'
/// 2021-10-27 13:51:701[INFO ][a.LoggingHelper:24]: New search request from anywhere
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
    ClientWithLogEx().logStuff('this is the message with log ex');
    ClientWithLogEx().logException();

    ClientWithDirectLogger().logStuff('this is the message with original logger');

    await Logger.init(kLog4DartConfig, clientProxyCallDepthOffset: 1);
    ClientBehindOwnProxy().logStuff('this is the message through proxy');
  });
}

class ClientWithLogEx with Log4Dart {
  void logStuff(String s) {
    logTrace(s, tag: 'tag-512');
    logDebug(s, tag: 'tag-512');
    logInfo(s, tag: 'tag-128');
    logWarn(s, tag: 'tag-100');
    logError(s);
    logFatal(s, tag: 'tag-512');
  }

  void logException() {
    try {
      throw Exception('Something went wrong');
    } on Exception catch (exception, stacktrace) {
      logWarn('my code went south...', exception: exception, stackTrace: stacktrace);
      expect(true, true);
    }
  }
}

// Call through client should print line 66, or better line of 'void logStuff(String thisLine)', not
// 'void logDebugProxy(String notThisLine)'. E.g:
//
// [2022-04-28 11:12:39.353][DEBUG	][ClientBehindOwnProxy.logStuff:66]: this is the message through proxy -
// [file:///Users/raoul/dev/udemy/local_workbench/Dart-Log-4-Dart-2/test/logger_stack_trace_test.dart(66:11)]
class ClientLoggingProxyWithLogEx with Log4Dart {
  void logDebugProxy(String notThisLine) {
    logDebug(notThisLine);
  }
}

class ClientBehindOwnProxy {
  final proxy = ClientLoggingProxyWithLogEx();
  void logStuff(String thisLine) {
    // this line should be in log output
    proxy.logDebugProxy(thisLine);
  }
}

class ClientWithDirectLogger {
  void logStuff(String x) {
    Logger.instance.logDebug('Some-Tag', x);
  }
}
