import 'dart:io';

import 'package:log_4_dart_2/src/LogRecord.dart';
import 'package:log_4_dart_2/src/LogRecordFormatter.dart';
import 'package:log_4_dart_2/src/appender/Appender.dart';
import 'package:log_4_dart_2/src/appender/AppenderType.dart';
import 'package:log_4_dart_2/src/appender/RotationCycle.dart';

import '../../log_4_dart_2.dart';

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

  File file;

  String _getFullFilename() {
    return path + filePattern + '.' + fileExtension;
  }

  @override
  void append(LogRecord logRecord) async {
    file.writeAsStringSync(LogRecordFormatter.format(logRecord, format) + '\n',
        mode: FileMode.append);
    if (logRecord.stackTrace != null) {
      file.writeAsStringSync(logRecord.stackTrace.toString() + '\n',
          mode: FileMode.append);
    }
  }

  @override
  void init(Map<String, dynamic> config) async {
    created = DateTime.now();
    type = AppenderType.FILE;
    if (config.containsKey('format')) {
      format = config['format'];
    } else {
      format = Appender.defaultFormat;
    }
    if (config.containsKey('filePattern')) {
      filePattern = config['filePattern'];
    } else {
      throw ArgumentError('Missing file argument for file appender');
    }
    if (config.containsKey('fileExtension')) {
      fileExtension = config['fileExtension'];
    }
    if (config.containsKey('rotationCycle')) {
      rotationCycle = config['rotationCycle'].toRotationCycle();
    }
    if (config.containsKey('level')) {
      level = Level.fromString(config['level']);
    } else {
      level = Level.INFO;
    }
    if (config.containsKey('path')) {
      path = config['path'];
    }

    if (FileSystemEntity.typeSync(_getFullFilename()) ==
        FileSystemEntityType.notFound) {
      file = await File(_getFullFilename()).create();
    } else {
      file = File(_getFullFilename());
    }
  }
}
