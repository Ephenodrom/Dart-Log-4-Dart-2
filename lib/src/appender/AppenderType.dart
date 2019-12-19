enum AppenderType { CONSOLE, FILE }

extension AppenderTypeToString on AppenderType {
  String valueAsString() {
    return toString().split('.')[1];
  }
}
