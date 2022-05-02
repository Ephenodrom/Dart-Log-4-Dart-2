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
  log_for_dart_2: ^1.0.0
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
  Logger.initFromFile('/path/to/log4d.json');
  // Or by using a Map<String,dynamic>
  Logger.init(config);
}
```
Note that Logger.init(...) has to be called only once, preferably in the main method. It configures
an instance internally that can then be accessed statically through Logger (or Logger.instance).

Take a look at [Example Configuration](#example-configuration) for a full example.

### Logging

The [Logger](/lib/src/Logger.dart) offers multiple methods for logging on different levels.

```dart
static String TAG = 'TestClass';
Logger.debug('Lorem Ipsum', tag: TAG);
Logger.trace('Lorem Ipsum', tag: TAG);
Logger.info('Lorem Ipsum', tag: TAG);
Logger.warn('Lorem Ipsum', tag: TAG);
Logger.error('Lorem Ipsum', tag: TAG);
Logger.fatal('Lorem Ipsum', tag: TAG);
```
Note that as of version 1.0.0, the old way has to be slightly adapted: the methods ```Logger().debug(...)```
are now called ```Logger().logDebug(...)``` (respectively per level).

There are two ways that are considered best for logging from a client context:

1) Directly through the static log methods on the Logger class:

```dart
class PlainClient {
  void doStuff() {
    Logger.debug('message', tag: 'some tag');
  }
}
```

2) Through the mixin Log4Dart. Note that the log methods are here called e.g. logDebug(...) to 
make their origin within the client code clear.
   
```dart
class Client with Log4Dart {
  void doStuff() {
    logDebug('message', tag: 'some tag');
  }
}
```
Note that in both cases, the Logger has to be initialized, e.g in main:

```dart
void main() async {
   await Logger.init(kLog4DartConfig);
   ...
}
```

## Appender And Configuration

### ConsoleAppender

The [ConsoleAppender](/lib/src/appender/ConsoleAppender.dart) is a simple appender that appends every log entry to the console output.

* type = The type of the appender. This has to be set to **CONSOLE**.
* dateFormat = The date format used for the appender. Default = yyyy-MM-dd HH:mm:ss.
* level = The loglevel for this appender.
* format = The format for the log output. See [Log format](#log-format) for more information.
* brackets = bool to wrap all message blocks with brackets: [%d]. Message is excluded from this.

### FileAppender

The [FileAppender](/lib/src/appender/FileAppender.dart) appends every log entry to a logfile.

* type = The type of the appender. This has to be set to **FILE**.
* level = The loglevel for this appender.
* format = The format for the log output. See [Log format](#log-format) for more information
* dateFormat = The date format used for the appender. Default = yyyy-MM-dd HH:mm:ss.
* filePattern = The pattern used for the filename.
* fileExtension = The fileextension. Default is "log".
* path = The path to the file
* rotationCycle = The rotation cycle for the appender. See [Rotation Cycle](#rotation-cycle). Default ist NEVER.

**Note**: If a path was specified, it must also exist!

### HttpAppender

The [HttpAppender](/lib/src/appender/HttpAppender.dart) sends a log entry via **HTTP POST** request to a given url.

* type = The type of the appender. This has to be set to **HTTP**.
* dateFormat = The date format used for the appender. Default = yyyy-MM-dd HH:mm:ss.
* level = The loglevel for this appender.
* url = The url for the POST request.
* headers = A list of headers where the name and value of the header a seperated by a ":". Example "Content-Type:application/json"

### EmailAppender

The [EmailAppender](/lib/src/appender/EmailAppender.dart) sends a log entry via email to a given address.

* type = The type of the appender. This has to be set to **EMAIL**.
* dateFormat = The date format used for the appender. Default = yyyy-MM-dd HH:mm:ss.
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
* templateFile = Full path to a file containing the template to use to send via email. If no template is given the appender will send the LogRecord as JSON. You can use the same placeholders within your template that are used for the format setting. See [Log format](#log-format) for more information.
* html = Whether the given template is plaintext or html. Default is false.

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
    // TODO: implement init.
  }

  @override
  Appender getInstance(){
    return CustomAppender();
  }

  @override
  String getType(){
    return 'CustomAppender';
  }
}
```

Register the custom appender in the Logger via the **registerAppender()** method before the logger is initialized.

```dart
Logger.instance.registerAppender(CustomAppender());
```

### Log Format

The format of the log entrys can be configured for some appender.

* %d = The date.
* %i = The identifier.
* %t = The tag.
* %l = The log level.
* %m = The message.
* %f = The file name with line and column number (e.g. package:my_project/chat_screen.dart(42:7))
* %c = The class and method name with line number (e.g. ChatScreenState.getCurrentUser:42)

Additionally you can add MDC (Mapped Diagnostic Context) placeholders when the app is run in a Zone:

* %X{<key-name>}

Best shown in an example:

```dart
void main() async {
   await Logger.init(kLog4DartConfig);
  
   // We define values to zone as 3rd param: zoneValues
   // This cannot run within the test callback, for the moment this works directly or further down the line...
   await runZonedGuarded(() async {
      // App running, we set some vars somewhere down the line to zone:
      if (Zone.current['LOG_SESSION_HASH_KEY'] != null) {
         // sets LOG_SESSION_HASH_KEY to 865a15
         Zone.current['LOG_SESSION_HASH_KEY'].add(generateMd5Fingerprint('Some data like app start timestamp'));
      }
      // Then we log and hand off to the logging library
      Logger.debug('hello world');
      }, (Object error, StackTrace stackTrace) {
         print(error);
      }, zoneValues: {
         // sets LOG_DEVICE_HASH_KEY to 8634e3c65a15
         'LOG_DEVICE_HASH_KEY': [generateMd5Fingerprint('Data that is consistent per platform like values delivered by device_info_plus')],
         vLOG_SESSION_HASH_KEY': [], // yet empty, set further down the line
      });
   }
   
   // Just an idea...
   String generateMd5Fingerprint(String input) {
      return md5.convert(utf8.encode(input)).toString().substring(0, 6);
   }
}
```

With this format setup

```
'format': '%d%i%X{logging.device-hash}%X{logging.session-hash}%t%l%c %m %f'
```

It should print something like this, where the two parts [634e3c] and [865a15] can be useful for log analysis:  

```
 [2022-04-28 14:44:26.934][CONSOLE][634e3c][865a15][tag-512][DEBUG][ClientWithLogEx.logStuff:60] hello world [package:my_project/chat_screen.dart(60:5)]
```

Examples :

* "%d %i %t %l %m"
* "This log entry was created on %d from class %t from thread %i. It has the level %l and the message %m"

Example for an html template :

```html
<h1>Log Event</h1>
<p>Message: %m</p>
<p>Class: %t</p>
<p>Time: %d</p>
<p>Level: %l</p>
```

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
      'format': '%d%i%t%l%c %m %f',
      'level': 'TRACE',
      'dateFormat': 'yyyy-MM-dd HH:mm:ss.SSS',
      'brackets': true,
      'mode': 'stdout'
    },
    {
      'type': 'FILE',
      'dateFormat' : 'yyyy-MM-dd HH:mm:ss',
      'format': '%d %i %t %l %m',
      'level': 'INFO',
      'filePattern': 'log4dart2_log',
      'fileExtension': 'txt',
      'path': '/path/to/'
      'rotationCycle': 'MONTH'
    },
    {
      'type': 'EMAIL',
      'dateFormat' : 'yyyy-MM-dd HH:mm:ss',
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
      'ssl': true,
      'templateFile': '/path/to/template.txt',
      'html': false
    },
    {
      'type': 'HTTP',
      'dateFormat' : 'yyyy-MM-dd HH:mm:ss',
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
      "dateFormat" : "yyyy-MM-dd HH:mm:ss",
      "format": "%d %i %t %l %m",
      "level": "INFO"
    },
    {
      "type": "FILE",
      "dateFormat" : "yyyy-MM-dd HH:mm:ss",
      "format": "%d %i %t %l %m",
      "level": "INFO",
      "filePattern": "log4dart2_log",
      "fileExtension": "txt",
      "path": "/path/to/",
      "rotationCycle": "MONTH"
    },
    {
      "type": "EMAIL",
      "dateFormat" : "yyyy-MM-dd HH:mm:ss",
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
      "ssl": true,
      "templateFile": "/path/to/template.txt",
      "html": false
    },
    {
      "type": "HTTP",
      "dateFormat" : "yyyy-MM-dd HH:mm:ss",
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
