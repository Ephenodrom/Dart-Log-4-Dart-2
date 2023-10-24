import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:test/test.dart';

void main() {
  test('Test init()', () async {
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
        {
          'type': 'EMAIL',
          'level': 'INFO',
          'host': 'smtp.test.de',
          'user': 'test@test.de',
          'password': 'test',
          'port': 1,
          'fromMail': 'test@test.de',
          'fromName': 'Jon Doe',
          'to': ['test1@example.com', 'test2@example.com'],
          'toCC': ['test1@example.com', 'test2@example.com'],
          'toBCC': ['test1@example.com', 'test2@example.com']
        },
        {
          'type': 'HTTP',
          'level': 'INFO',
          'url': 'api.example.com',
          'headers': ['Content-Type:application/json']
        },
        {
          'type': 'MYSQL',
          'level': 'INFO',
          'host': 'database.example.com',
          'user': 'root',
          'password': 'test',
          'port': 1,
          'database': 'mydatabase',
          'table': 'log_entries'
        }
      ],
    };
    await Logger.init(null);
    Logger.instance.registerAllAppender([
      ConsoleAppender(),
      FileAppender(),
      HttpAppender(),
      EmailAppender(),
      MySqlAppender()
    ]);
    await Logger.init(config, test: true);

    expect(Logger.instance.appenders.length, 5);

    var console = Logger.instance.appenders.elementAt(0) as ConsoleAppender;
    expect(console.type, AppenderType.CONSOLE);
    expect(console.format, '%d %t %l %m');
    expect(console.level, Level.INFO);

    var file = Logger.instance.appenders.elementAt(1) as FileAppender;

    expect(file.type, AppenderType.FILE);
    expect(file.format, '%d %t %l %m');
    expect(file.level, Level.INFO);
    expect(file.filePattern, 'log4dart2_log');
    expect(file.rotationCycle, RotationCycle.NEVER);
    expect(file.path, '/path/to/');

    var email = Logger.instance.appenders.elementAt(2) as EmailAppender;

    expect(email.type, AppenderType.EMAIL);
    expect(email.level, Level.INFO);
    expect(email.host, 'smtp.test.de');
    expect(email.user, 'test@test.de');
    expect(email.password, 'test');
    expect(email.port, 1);
    expect(email.fromMail, 'test@test.de');
    expect(email.fromName, 'Jon Doe');
    expect(email.to.length, 2);
    expect(email.toCC!.length, 2);
    expect(email.toBCC!.length, 2);

    var http = Logger.instance.appenders.elementAt(3) as HttpAppender;

    expect(http.type, AppenderType.HTTP);
    expect(http.level, Level.INFO);
    expect(http.url, 'api.example.com');
    expect(http.headers!.length, 1);
    expect(http.headers!['Content-Type'], 'application/json');

    var mysql = Logger.instance.appenders.elementAt(4) as MySqlAppender;

    expect(mysql.type, AppenderType.MYSQL);
    expect(mysql.level, Level.INFO);
    expect(mysql.host, 'database.example.com');
    expect(mysql.user, 'root');
    expect(mysql.password, 'test');
    expect(mysql.port, 1);
    expect(mysql.database, 'mydatabase');
  });
}
