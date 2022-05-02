import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:intl/intl.dart';
import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:test/test.dart';

void main() {
  test('Test FileAppender daily rotating', () async {
    var config = {
      'appenders': [
        {'type': 'FILE', 'format': '%d %t %l %m', 'level': 'INFO', 'filePattern': 'unittest', 'fileExtension': 'txt', 'path': '', 'rotationCycle': 'DAY'}
      ],
    };
    var yesterDay = DateTime.now().subtract(Duration(days: 1));
    var now = DateTime.now();
    var yesterDayAsString = DateFormat('yyyy-MM-dd').format(yesterDay);
    var nowAsString = DateFormat('yyyy-MM-dd').format(now);
    await Logger.init(null);
    Logger.instance.registerAllAppender([FileAppender()]);
    await Logger.init(config, date: yesterDay);
    if (FileSystemEntity.typeSync('unittest_$yesterDayAsString.txt') == FileSystemEntityType.notFound) {
      fail('Initial file not found!');
    }
    try {
      File('unittest_$yesterDayAsString.txt').deleteSync();
    } on FileSystemException {
      fail('Can not remove file with name "unittest_$yesterDayAsString.txt"');
    }
    Logger.instance.logInfo('UnitTest', 'Hello World');
    await Future.delayed(Duration(seconds: 2));
    if (FileSystemEntity.typeSync('unittest_$nowAsString.txt') == FileSystemEntityType.notFound) {
      fail('New file "unittest_$nowAsString.txt" not found!');
    }
    try {
      File('unittest_$nowAsString.txt').deleteSync();
    } on FileSystemException {
      fail('Can not remove file with name "unittest_$nowAsString.txt"');
    }
  });

  test('Test FileAppender weekly rotating', () async {
    var config = {
      'appenders': [
        {'type': 'FILE', 'format': '%d %t %l %m', 'level': 'INFO', 'filePattern': 'unittest', 'fileExtension': 'txt', 'path': '', 'rotationCycle': 'WEEK'}
      ],
    };
    var lastWeek = DateTime.now().subtract(Duration(days: 7));
    var now = DateTime.now();
    var lastWeekAsString = lastWeek.year.toString() + '-CW' + DateUtils.getCalendarWeek(lastWeek).toString();
    var nowAsString = now.year.toString() + '-CW' + DateUtils.getCalendarWeek(now).toString();
    Logger.instance.registerAllAppender([FileAppender()]);
    await Logger.init(config, date: lastWeek);
    if (FileSystemEntity.typeSync('unittest_$lastWeekAsString.txt') == FileSystemEntityType.notFound) {
      fail('Initial file not found!');
    }
    try {
      File('unittest_$lastWeekAsString.txt').deleteSync();
    } on FileSystemException {
      fail('Can not remove file with name "unittest_$lastWeekAsString.txt"');
    }
    Logger.instance.logInfo('UnitTest', 'Hello World');
    await Future.delayed(Duration(seconds: 2));
    if (FileSystemEntity.typeSync('unittest_$nowAsString.txt') == FileSystemEntityType.notFound) {
      fail('New file "unittest_$nowAsString.txt" not found!');
    }
    try {
      File('unittest_$nowAsString.txt').deleteSync();
    } on FileSystemException {
      fail('Can not remove file with name "unittest_$nowAsString.txt"');
    }
  });

  test('Test FileAppender monthly rotating', () async {
    var config = {
      'appenders': [
        {'type': 'FILE', 'format': '%d %t %l %m', 'level': 'INFO', 'filePattern': 'unittest', 'fileExtension': 'txt', 'path': '', 'rotationCycle': 'MONTH'}
      ],
    };

    var now = DateTime.now();
    var lastMonth = DateTime(now.year, now.month - 1, now.day, now.hour, now.minute, now.second);
    var lastMonthAsString = DateFormat('yyyy-MM').format(lastMonth);
    var nowAsString = DateFormat('yyyy-MM').format(now);
    Logger.instance.registerAllAppender([FileAppender()]);
    await Logger.init(config, date: lastMonth);
    if (FileSystemEntity.typeSync('unittest_$lastMonthAsString.txt') == FileSystemEntityType.notFound) {
      fail('Initial file not found!');
    }
    try {
      File('unittest_$lastMonthAsString.txt').deleteSync();
    } on FileSystemException {
      fail('Can not remove file with name "unittest_$lastMonthAsString.txt"');
    }
    Logger.instance.logInfo('UnitTest', 'Hello World');
    await Future.delayed(Duration(seconds: 2));
    if (FileSystemEntity.typeSync('unittest_$nowAsString.txt') == FileSystemEntityType.notFound) {
      fail('New file "unittest_$nowAsString.txt" not found!');
    }
    try {
      File('unittest_$nowAsString.txt').deleteSync();
    } on FileSystemException {
      fail('Can not remove file with name "unittest_$nowAsString.txt"');
    }
  });

  test('Test FileAppender yearly rotating', () async {
    var config = {
      'appenders': [
        {'type': 'FILE', 'format': '%d %t %l %m', 'level': 'INFO', 'filePattern': 'unittest', 'fileExtension': 'txt', 'path': '', 'rotationCycle': 'YEAR'}
      ],
    };

    var now = DateTime.now();
    var lastYear = DateTime(now.year - 1, now.month, now.day, now.hour, now.minute, now.second);
    var lastYearAsString = DateFormat('yyyy').format(lastYear);
    var nowAsString = DateFormat('yyyy').format(now);
    Logger.instance.registerAllAppender([FileAppender()]);
    await Logger.init(config, date: lastYear);
    if (FileSystemEntity.typeSync('unittest_$lastYearAsString.txt') == FileSystemEntityType.notFound) {
      fail('Initial file not found!');
    }
    try {
      File('unittest_$lastYearAsString.txt').deleteSync();
    } on FileSystemException {
      fail('Can not remove file with name "unittest_$lastYearAsString.txt"');
    }
    Logger.instance.logInfo('UnitTest', 'Hello World');
    await Future.delayed(Duration(seconds: 2));
    if (FileSystemEntity.typeSync('unittest_$nowAsString.txt') == FileSystemEntityType.notFound) {
      fail('New file "unittest_$nowAsString.txt" not found!');
    }
    try {
      File('unittest_$nowAsString.txt').deleteSync();
    } on FileSystemException {
      fail('Can not remove file with name "unittest_$nowAsString.txt"');
    }
  });
}
