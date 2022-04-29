import 'package:log_4_dart_2/log_4_dart_2.dart';

void main() {
  var config = {
    'appenders': [
      {'type': 'CONSOLE', 'format': '%d %t %l %m', 'level': 'INFO'},
    ]
  };
  Logger.init(config);
  ExampleClass.doSomething();
}

class ExampleClass {
  static String TAG = 'ExampleClass';

  static void doSomething() {
    Logger.instance.logInfo(TAG, 'I am doing something!');
  }
}
