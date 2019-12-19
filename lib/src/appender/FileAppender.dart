import 'dart:io';

import 'package:log_4_dart_2/src/LogRecord.dart';
import 'package:log_4_dart_2/src/LogRecordFormatter.dart';
import 'package:log_4_dart_2/src/appender/Appender.dart';
import 'package:log_4_dart_2/src/appender/AppenderType.dart';
import 'package:log_4_dart_2/src/appender/RotationCycle.dart';

///
/// A appender for writing logs to a logfile
///
class FileAppender extends Appender {
  /// The logfile pattern
  String filePattern;

  /// The logfile file extension. Default is .log
  String fileExtension = 'log';

  /// The path where the file(s) is/are stored
  String path = '';

  RotationCycle rotationCycle = RotationCycle.NEVER;

  FileAppender() {
    created = DateTime.now();
    type = AppenderType.FILE;
  }

  String _getFullFilename() {
    return path + filePattern + '.' + fileExtension;
  }

  @override
  void append(LogRecord logRecord) async {
    File file;
    if (FileSystemEntity.typeSync(_getFullFilename()) ==
        FileSystemEntityType.notFound) {
      file = await File(_getFullFilename()).create();
    } else {
      file = File(_getFullFilename());
    }
    file.writeAsStringSync(LogRecordFormatter.format(logRecord, format) + '\n',
        mode: FileMode.append);
    if (logRecord.stackTrace != null) {
      file.writeAsStringSync(logRecord.stackTrace.toString() + '\n',
          mode: FileMode.append);
    }
  }
}
