import 'dart:async';
import 'dart:convert';
import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:test/test.dart';
import 'package:crypto/crypto.dart';

const kLog4DartConfigWithMDC = {
  'appenders': [
    {
      'type': 'CONSOLE',
      'format': '%d%i%X{logging.device-hash}%X{logging.session-hash}%t%l%c %m %f',
      'level': 'TRACE',
      'dateFormat': 'yyyy-MM-dd HH:mm:ss.SSS',
      'brackets': true
    },
  ]
};

// This is setup on the clinet side. The logger picks the values up from the appender configs
const LOG_DEVICE_HASH_KEY = 'logging.device-hash';
const LOG_SESSION_HASH_KEY = 'logging.session-hash';

void main() async {
  // Make test runner happy
  test('Test', () async {
    expect(true, true);
  });

  final myApp = MyApp();
  await myApp.runMDC();
}

/// Set values throughout app and add them to the log, e.g: logged in user.
/// Helps to analyze logs, especially when multiple client threads are at
/// work, like in a webapp.
///
/// Add to log format in appender config:
/// %X{your-key}, e.g. 'format': '%d%i%X{your-key}%t%l%c %m %f'
/// Run main app in zone: await runZonedGuarded(() async { ...
/// and define zone keys (fixed) for Map<String, List<dynamic>>:
/// ...), zoneValues: {
///    your-key: [],
///    your-other-key: ['preset-value'], // yet empty, set further down the line
/// });
///
/// See: https://logging.apache.org/log4j/2.x/manual/thread-context.html
class MyApp {
  MyApp();

  Future<void> runMDC() async {
    await Logger.init(kLog4DartConfigWithMDC);

    // We define values to zone as 3rd param: zoneValues
    // This cannot run within the test callback, for the moment this works directly or further down the line...
    await runZonedGuarded(() async {
      // App running, we set some vars somewhere down the line to zone:
      if (Zone.current[LOG_SESSION_HASH_KEY] != null) {
        // sets LOG_SESSION_HASH_KEY to 865a15
        Zone.current[LOG_SESSION_HASH_KEY].add(generateMd5Fingerprint('Some data like app start timestamp'));
      }
      // Then we log and hand off to the logging library
      ClientWithLogEx().logStuff('this is the message with log ex');
      // Log should be something like:
      // [2022-04-28 14:44:26.934][CONSOLE][634e3c][865a15][tag-512][TRACE][ClientWithLogEx.logStuff:60] this is the message with log ex [file:///<path>>/Dart-Log-4-Dart-2/test/logger_mdc_zoned.dart(60:5)]
    }, (Object error, StackTrace stackTrace) {
      print(error);
    }, zoneValues: {
      // sets LOG_DEVICE_HASH_KEY to 8634e3c65a15
      LOG_DEVICE_HASH_KEY: [generateMd5Fingerprint('Data that is consistent per platform like values delivered by device_info_plus')],
      LOG_SESSION_HASH_KEY: [], // yet empty, set further down the line
    });
  }

  // Just an idea...
  String generateMd5Fingerprint(String input) {
    return md5.convert(utf8.encode(input)).toString().substring(0, 6);
  }
}

class ClientWithLogEx with LoggingExposure {
  void logStuff(String s) {
    logTrace(s, tag: 'tag-512');
  }
}
