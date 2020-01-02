///
/// The appender type
///
enum AppenderType { CONSOLE, FILE, HTTP, EMAIL, MYSQL }

extension AppenderTypeToString on AppenderType {
  String valueAsString() {
    return toString().split('.')[1];
  }
}
