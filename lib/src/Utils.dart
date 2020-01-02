import 'appender/RotationCycle.dart';

class Utils {
  static RotationCycle getRotationCycleFromString(String s) {
    return RotationCycle.values.firstWhere(
        (e) => e.toString().split('.')[1].toLowerCase() == s.toLowerCase(),
        orElse: () => RotationCycle.NEVER);
  }
}
