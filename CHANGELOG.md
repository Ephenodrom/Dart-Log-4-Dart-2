# Changelog

## 1.0.0 - 2022-05-01

- Static log access: Logger.debug (old: Logger().debug(), to keep, change method signature, change old to Logger().logDebug()
- Log4Dart mixin for easy log access. logDebug('message') vs Logger.debug('message')
- Add MDC
- Add filename, line and number to message (IDE should like to file). Stack frame depth configurable, e.g. when using proxies on the client side.
- Option to send console logs to the developer tools (log function). To be tested.
- Null Safety

## 0.4.0 - 2020-01-14

- Add template feature to EmailAppender (#4)
- Add unit tests

## 0.3.3 - 2020-01-13

- Update dependencies

## 0.3.2 - 2020-01-10

- Improve type safety

## 0.3.1 - 2020-01-07

- Improve initialization of the logger

## 0.3.0 - 2020-01-07

- Add unique identifier to log format (#3)
- Add custom dateformat for appender (#2)
- Simplify use of custom appenders. (#5)

## 0.2.1 - 2020-01-03

- Improve documentation

## 0.2.0 - 2020-01-02

- Add rotation cycle to the FileAppender
- Add custom appender feature
- Add unit tests

## 0.1.0 - 2019-12-21

- Initial release
