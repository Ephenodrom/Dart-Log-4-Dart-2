# Log 4 Dart 2

A dart package for advanced logging, with multiple and configurable appenders.

## Table of Contents

1. [Preamble](#preamble)
2. [Install](#install)
   * [pubspec.yaml](#pubspec.yaml)
3. [Import](#import)
4. [Usage](#usage)
   * [Setup Logger](#setup-logger)
   * [Logging](#logging)
5. [Appender And Configuration](#appender-and-configuration)
   * [ConsoleAppender](#consoleappender)
   * [FileAppender](#fileappender)
   * [HttpAppender](#httpappender)
   * [EmailAppender](#emailappender)
   * [MySqlAppender](#mysqlappender)
   * [Adding Custom Appender](#adding-custom-appender)
   * [Log Format](#log-format)
   * [Rotation Cycle](#rotation-cycle)
   * [Example Configuration](#example-configuration)
6. [Changelog](#changelog)
7. [Copyright And License](#copyright-and-license)

## Preamble

The package is under construction and still needs some tweeks and code improvements!

## Install

### pubspec.yaml

Update pubspec.yaml and add the following line to your dependencies.

```yaml
dependencies:
  log_for_dart_2: ^0.2.0
```

## Import

Import the package with :

```dart
import 'package:log_4_dart_2/log_4_dart_2.dart';
```

## Usage

### Setup Logger

There are two ways to setup the [Logger](/lib/src/Logger.dart).

1) Store the logger configuration in seperate json file and pass the full name of the file to the **initFromFile()** method.
2) Create a **Map<String,dynamic>** that holds the configuration and pass it to the **init()** method.

```dart
void main(List<String> arguments){
  // Init the logger from a configuration file
  Logger().initFromFile('/path/to/log4d.json');
  // Or by using a Map<String,dynamic>
  Logger().init(config);
}
```

Take a look at [Example Configuration](#example-configuration) for a full example.

### Logging

The [Logger](/lib/src/Logger.dart) offers multiple methods for logging on different levels.

```dart
static String TAG = 'TestClass';
Logger().debug(TAG, 'Lorem Ipsum');
Logger().trace(TAG, 'Lorem Ipsum');
Logger().info(TAG, 'Lorem Ipsum');
Logger().warning(TAG, 'Lorem Ipsum');
Logger().error(TAG, 'Lorem Ipsum');
Logger().fatal(TAG, 'Lorem Ipsum');
```

## Appender And Configuration

### ConsoleAppender

The [ConsoleAppender](/lib/src/appender/ConsoleAppender.dart) is a simple appender that appends every log entry to the console output.

* type = The type of the appender. This has to be set to **CONSOLE**.
* level = The loglevel for this appender.
* format = The format for the log output. See [Log format](#log-format) for more information

### FileAppender

The [FileAppender](/lib/src/appender/FileAppender.dart) appends every log entry to a logfile.

* type = The type of the appender. This has to be set to **FILE**.
* level = The loglevel for this appender.
* format = The format for the log output. See [Log format](#log-format) for more information
* filePattern = The pattern used for the filename.
* fileExtension = The fileextension. Default is "log".
* path = The path to the file
* rotationCycle = The rotation cycle for the appender. See [Rotation Cycle](#rotation-cycle). Default ist NEVER.

**Note**: If a path was specified, it must also exist!

### HttpAppender

The [HttpAppender](/lib/src/appender/HttpAppender.dart) sends a log entry via **HTTP POST** request to a given url.

* type = The type of the appender. This has to be set to **HTTP**.
* level = The loglevel for this appender.
* url = The url for the POST request.
* headers = A list of headers where the name and value of the header a seperated by a ":". Example "Content-Type:application/json"

### EmailAppender

The [EmailAppender](/lib/src/appender/EmailAppender.dart) sends a log entry via email to a given address.

* type = The type of the appender. This has to be set to **EMAIL**.
* level = The loglevel for this appender.
* host = The smtp server.
* user = The user for this server.
* password = The password for the given user.
* port = The port of the smtp server
* fromMail = The sender email. As a default, the username is used.
* fromName = The sender name.
* to = A list of email addresses to send the email to.
* toCC = A list of email addresses to receive a copy.
* toBCC = A list of email addresses to receive a blind copy.
* ssl = Whether to use ssl or not.

**Note**: Due to the [mailer package](https://pub.dev/packages/mailer) that is used to provide this appender, this works only for mail servers that need authorization by user/password.

### MySqlAppender

The [MySqlAppender](/lib/src/appender/MySqlAppender.dart) appends every log entry to a table in a mysql database.

* type = The type of the appender. This has to be set to **MYSQL**.
* level = The loglevel for this appender.
* host = The host for the mysql database.
* user = The user.
* password = The password of the user.
* port = The port of the host.
* database = The database name.
* table = The table to write to.

Create the table with the given statement. Replace **$table** with your desired table name.

```sql
CREATE TABLE `$table` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tag` VARCHAR(45) NULL,
  `level` VARCHAR(45) NULL,
  `message` VARCHAR(45) NULL,
  `time` VARCHAR(45) NULL,
  PRIMARY KEY (`id`));
```

### Adding Custom Appender

Log4Dart2 supports the usage of custom appenders. Create a class that extends the [Appender](/lib/src/appender/Appender.dart) and implements the **append** and **init** methods.

```dart
import 'package:log_4_dart_2/log_4_dart_2.dart';

class CustomAppender extends Appender {
  @override
  void append(LogRecord logRecord) {
    // TODO: implement append
  }

  @override
  void init(Map<String, dynamic> config, bool test, DateTime date) {
    // TODO: implement init. Not necessary!
  }
}
```

Add the custom appender to the Logger via the **addCustomAppender** method.

```dart
var customAppender = CustomAppender();
Logger().addCustomAppender(customAppender);
```

### Log Format

The format of the log entrys can be configured for some appender.

* %d = The date
* %t = The tag
* %l = The log level
* %m = The message

Examples :

* "%d %t %l %m"
* "This log entry was created on %d from class %t. It has the level %l and the message %m"

### Rotation Cycle

The rotation cycle can be configured for some appender. It defines how offen a new file is created to store the logging data.

* NEVER (Never rotate)
* DAY (Rotate on a daily basis)
* WEEK (Rotate on weekly basis)
* MONTH (Rotate on monthly basis every first day of the month)
* YEAR (Rotate on a yearly basis every first day of the year)

### Example Configuration

Some configuration examples with all possible appenders and their settings.

```dart
var config = {
  'appenders': [
    {
      'type': 'CONSOLE',
      'format': '%d %t %l %m',
      'level': 'INFO'
    },
    {
      'type': 'FILE',
      'format': '%d %t %l %m',
      'level': 'INFO',
      'filePattern': 'log4dart2_log',
      'fileExtension': 'txt',
      'path': '/path/to/'
      'rotationCycle': 'MONTH'
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
      'to': [
        'test1@example.com',
        'test2@example.com'
      ],
      'toCC': [
        'test1@example.com',
        'test2@example.com'
      ],
      'toBCC': [
        'test1@example.com',
        'test2@example.com'
      ],
      'ssl': true
    },
    {
      'type': 'HTTP',
      'level': 'INFO',
      'url': 'api.example.com',
      'headers': [
        'Content-Type:application/json'
      ]
    },
    {
      'type': 'MYSQL',
      'level': 'INFO',
      'host': 'database.example.com',
      'user': 'root',
      'password': 'test',
      'port': 1,
      'database': 'mydatabase',
      'table' : 'log_entries'
    }
  ]
};
```

```json
{
  "appenders": [
    {
      "type": "CONSOLE",
      "format": "%d %t %l %m",
      "level": "INFO"
    },
    {
      "type": "FILE",
      "format": "%d %t %l %m",
      "level": "INFO",
      "filePattern": "log4dart2_log",
      "fileExtension": "txt",
      "path": "/path/to/",
      "rotationCycle": "MONTH"
    },
    {
      "type": "EMAIL",
      "level": "INFO",
      "host": "smtp.test.de",
      "user": "test@test.de",
      "password": "test",
      "port": 1,
      "fromMail": "test@test.de",
      "fromName": "Jon Doe",
      "to": [
        "test1@example.com",
        "test2@example.com"
      ],
      "toCC": [
        "test1@example.com",
        "test2@example.com"
      ],
      "toBCC": [
        "test1@example.com",
        "test2@example.com"
      ],
      "ssl": true
    },
    {
      "type": "HTTP",
      "level": "INFO",
      "url": "api.example.com",
      "headers": [
        "Content-Type:application/json"
      ]
    },
    {
      "type": "MYSQL",
      "level": "INFO",
      "host": "database.example.com",
      "user": "root",
      "password": "test",
      "port": 1,
      "database": "mydatabase",
      "table" : "log_entries"
    }
  ]
}
```

## Changelog

For a detailed changelog, see the [CHANGELOG.md](CHANGELOG.md) file

## Copyright And License

MIT License

Copyright (c) 2020 Ephenodrom

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
