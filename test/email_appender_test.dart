import 'dart:io';
import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:test/test.dart';

void main() {
  test('Test email appender template loading', () async {
    var templateFile = 'email_template.txt';
    var templateText = 'This log entry was created on %d from class %t from thread %i. It has the level %l and the message %m';
    var config = {
      'appenders': [
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
          'toBCC': ['test1@example.com', 'test2@example.com'],
          'templateFile': templateFile,
          'html': true
        }
      ],
    };
    if (FileSystemEntity.typeSync(templateFile) != FileSystemEntityType.notFound) {
      try {
        File(templateFile).deleteSync();
      } on FileSystemException {
        fail('Can not remove file with name "$templateFile"');
      }
    }

    var file = await File(templateFile).create();
    file.writeAsStringSync('This log entry was created on %d from class %t from thread %i. It has the level %l and the message %m', mode: FileMode.append);
    await Logger.init(null);
    Logger.instance.registerAllAppender([EmailAppender()]);
    await Logger.init(config, test: true);
    var appender = Logger.instance.appenders.elementAt(0) as EmailAppender;
    expect(appender.templateFile, templateFile);
    expect(appender.template, templateText);

    try {
      File(templateFile).deleteSync();
    } on FileSystemException {
      fail('Can not remove file with name "$templateFile"');
    }
  });
}
