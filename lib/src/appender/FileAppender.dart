import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:intl/intl.dart';
import 'package:log_4_dart_2/src/LogRecord.dart';
import 'package:log_4_dart_2/src/LogRecordFormatter.dart';
import 'package:log_4_dart_2/src/appender/Appender.dart';
import 'package:log_4_dart_2/src/appender/AppenderType.dart';
import 'package:log_4_dart_2/src/appender/RotationCycle.dart';

import '../../log_4_dart_2.dart';
import '../Utils.dart';

///
/// A appender for writing logs to a logfile
///
class FileAppender extends Appender {
  /// The logfile pattern
  String? filePattern;

  /// The logfile file extension. Default is .log
  String? fileExtension = 'log';

  /// The path where the file(s) is/are stored
  String? path = '';

  /// The rotation cycle
  RotationCycle rotationCycle = RotationCycle.NEVER;

  /// The current file for the appender
  late File _file;

  ///
  /// Returns the full file name of the current logfile
  ///
  String _getFullFilename() {
    switch (rotationCycle) {
      case RotationCycle.NEVER:
        return path! + filePattern! + '.' + fileExtension!;
      case RotationCycle.DAY:
        return path! + filePattern! + '_' + DateFormat('yyyy-MM-dd').format(created) + '.' + fileExtension!;
      case RotationCycle.WEEK:
        return path! + filePattern! + '_' + created.year.toString() + '-CW' + DateUtils.getCalendarWeek(created).toString() + '.' + fileExtension!;

      case RotationCycle.MONTH:
        return path! + filePattern! + '_' + DateFormat('yyyy-MM').format(created) + '.' + fileExtension!;
      case RotationCycle.YEAR:
        return path! + filePattern! + '_' + DateFormat('yyyy').format(created) + '.' + fileExtension!;
    }
    return '';
  }

  @override
  void append(LogRecord logRecord) async {
    switch (rotationCycle) {
      case RotationCycle.NEVER:
        // Do nothing
        break;
      case RotationCycle.DAY:
      case RotationCycle.WEEK:
      case RotationCycle.MONTH:
      case RotationCycle.YEAR:
        await checkForFileChange();
        break;
    }
    _file.writeAsStringSync(LogRecordFormatter.format(logRecord, format!, dateFormat: dateFormat) + '\n', mode: FileMode.append);
    if (logRecord.stackTrace != null) {
      _file.writeAsStringSync(logRecord.stackTrace.toString() + '\n', mode: FileMode.append);
    }
  }

  @override
  Future<void>? init(Map<String, dynamic> config, bool test, DateTime? date) async {
    created = date ?? DateTime.now();
    type = AppenderType.FILE;
    if (config.containsKey('format')) {
      format = config['format'];
    } else {
      format = Appender.defaultFormat;
    }
    if (config.containsKey('dateFormat')) {
      dateFormat = config['dateFormat'];
    } else {
      dateFormat = Appender.defaultDateFormat;
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
      rotationCycle = Utils.getRotationCycleFromString(config['rotationCycle']);
    }
    if (config.containsKey('level')) {
      level = Level.fromString(config['level']);
    } else {
      level = Level.INFO;
    }
    if (config.containsKey('path')) {
      path = config['path'];
    }
    if (!test) {
      if (FileSystemEntity.typeSync(_getFullFilename()) == FileSystemEntityType.notFound) {
        _file = await File(_getFullFilename()).create();
      } else {
        _file = File(_getFullFilename());
      }
    }
    return null;
  }

  ///
  /// Check whether to create a new logfile depending on the [RotationCycle].
  ///
  Future<void>? checkForFileChange() async {
    var now = DateTime.now();
    var create = false;
    switch (rotationCycle) {
      case RotationCycle.NEVER:
        return;
      case RotationCycle.DAY:
        if (now.year > created.year || now.month > created.month) {
          create = true;
        } else if (now.day > created.day) {
          create = true;
        }
        break;
      case RotationCycle.WEEK:
        if (now.year > created.year) {
          create = true;
        } else if (DateUtils.getCalendarWeek(now) > DateUtils.getCalendarWeek(created)) {
          create = true;
        }
        break;
      case RotationCycle.MONTH:
        if (now.year > created.year) {
          create = true;
        } else if (now.month > created.month) {
          create = true;
        }
        break;
      case RotationCycle.YEAR:
        if (now.year > created.year) {
          create = true;
        }
        break;
    }
    if (create) {
      created = now;
      _file = await File(_getFullFilename()).create();
    }
    return null;
  }

  @override
  Appender getInstance() {
    return FileAppender();
  }

  @override
  String getType() {
    return 'FILE';
  }
}
