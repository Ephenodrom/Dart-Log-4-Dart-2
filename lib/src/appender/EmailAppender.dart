import 'package:basic_utils/basic_utils.dart';
import 'package:log_4_dart_2/log_4_dart_2.dart';
import 'package:log_4_dart_2/src/LogRecord.dart';
import 'package:log_4_dart_2/src/LogRecordFormatter.dart';
import 'package:log_4_dart_2/src/appender/Appender.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

///
/// A appender for sending log entries via email
///
class EmailAppender extends Appender {
  String host;
  String user;
  String password;
  int port;
  String fromMail;
  String fromName;
  List<Address> to;
  List<Address> toCC;
  List<Address> toBCC;
  bool ssl = false;
  SmtpServer smtpServer;
  PersistentConnection connection;

  @override
  void append(LogRecord logRecord) async {
    final message = Message()
      ..from = Address(fromMail, fromName)
      ..recipients.addAll(to)
      ..subject = 'Logger ${logRecord.level} at ${logRecord.getFormattedTime()}'
      ..text = LogRecordFormatter.formatJson(logRecord);
    if (IterableUtils.isNotNullOrEmpty(toCC)) {
      message.ccRecipients.addAll(toCC);
    }
    if (IterableUtils.isNotNullOrEmpty(toBCC)) {
      message.bccRecipients.addAll(toBCC);
    }

    try {
      await connection.send(message);
    } catch (e) {
      print(e);
      return;
    }
  }

  @override
  String toString() {
    return '$type $host $port $user $level';
  }

  @override
  void init(Map<String, dynamic> config, bool test) {
    created = DateTime.now();
    type = AppenderType.EMAIL;
    if (config.containsKey('level')) {
      level = Level.fromString(config['level']);
    } else {
      level = Level.INFO;
    }
    if (config.containsKey('host')) {
      host = config['host'];
    } else {
      throw ArgumentError('Missing host argument for EmailAppender');
    }
    if (config.containsKey('user')) {
      user = config['user'];
    }
    if (config.containsKey('password')) {
      password = config['password'];
    }
    if (config.containsKey('port')) {
      port = config['port'];
    } else {
      throw ArgumentError('Missing port argument for EmailAppender');
    }
    if (config.containsKey('fromMail')) {
      fromMail = config['fromMail'];
    } else {
      fromMail = user;
    }
    if (config.containsKey('fromName')) {
      fromName = config['fromName'];
    } else {
      fromName = user;
    }
    if (config.containsKey('to')) {
      to = [];
      for (String s in config['to']) {
        to.add(Address(s));
      }
    } else {
      throw ArgumentError('Missing to argument for EmailAppender');
    }
    if (config.containsKey('toCC')) {
      toCC = [];
      for (String s in config['toCC']) {
        toCC.add(Address(s));
      }
    }
    if (config.containsKey('toBCC')) {
      toBCC = [];
      for (String s in config['toBCC']) {
        toBCC.add(Address(s));
      }
    }
    if (config.containsKey('ssl')) {
      ssl = config['ssl'];
    }
    if (!test) {
      smtpServer = SmtpServer(host,
          port: port, username: user, password: password, ssl: ssl);
      connection = PersistentConnection(smtpServer);
    }
  }
}
