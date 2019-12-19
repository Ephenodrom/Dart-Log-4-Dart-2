# Log 4 Dart 2

A dart package for logging, with multiple and configurable appenders.

## Table of Contents

1. [Preamble](#preamble)
2. [Install](#install)
   * [pubspec.yaml](#pubspec.yaml)
3. [Import](#import)
4. [Usage](#usage)
   * [StringUtils](#stringutils)
5. [Appender And Configuration](#appender-and-configuration)
6. [Changelog](#changelog)
7. [Copyright And License](#copyright-and-license)

## Preamble

Lorem Ipsum

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

There are two ways to setup the logger.

1) Store the logger configuration in seperate file and pass the full name of the file to the **initFromFile()** method.
2) Create a **Map** that holds the configuration and pass it to the **init()** method.

```dart
void main(List<String> arguments){
  Logger().initFromFile('/path/to/log4d.json');
  Logger().init(config);
}
```

### Logging

```dart
static String TAG = 'TestClass';
Logger().info(TAG, 'Lorem Ipsum');
```

## Appender And Configuration

### ConsoleAppender

The [ConsoleAppender](/lib/src/appender/ConsoleAppender.dart) is a simple appender that appends every log entry to the console output.

### FileAppender

The [FileAppender](/lib/src/appender/FileAppender.dart) appends every log entry to a certain logfile.

### Log format

The format of the log entrys can be configured for each appender.

* %d = The date
* %t = The tag
* %l = The log level
* %m = The message

Examples :

* "%d %t %l %m"
* "This log entry was created on %d from class %t. It has the level %l and the message %m"

### Example configuration

```dart
var config = {
  'appenders': [
    {'type': 'CONSOLE', 'format': '%d %t %l %m', 'level': 'INFO'},
    {
      'type': 'FILE',
      'format': '%d %t %l %m',
      'level': 'INFO',
      'filePattern': 'log4dart2_log',
      'fileExtension': 'txt'
    },
  ],
};
```

```json
{
  "appenders": [
    {
      "type": "CONSOLE",
      "format": "%d %l %t - %m",
      "level": "INFO"
    },
    {
      "type": "FILE",
      "format": "%d %t %l %m",
      "level": "INFO",
      "filePattern": "log4dart2_log",
      "fileExtension": "txt"
    }
  ]
}
```

## Changelog

For a detailed changelog, see the [CHANGELOG.md](CHANGELOG.md) file

## Copyright And License

MIT License

Copyright (c) 2019 Ephenodrom

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
