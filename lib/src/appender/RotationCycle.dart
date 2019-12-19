///
/// The rotation cycle used for file logging
///
enum RotationCycle {
  /// Never rotate
  NEVER,

  /// Rotate on a daily basis
  DAY,

  /// Rotate on weekly basis
  WEEK,

  /// Rotate on monthly basis every first day of the month
  MONTH,

  /// Rotate on a yearly basis every first january
  YEAR
}

extension RotationCycleFromStringParser on String {
  ///
  /// Converts the string to a RotationCycle value. If no value matches the string it will return [RotationCycle.NEVER].
  ///
  RotationCycle toRotationCycle() {
    return RotationCycle.values.firstWhere(
        (e) => e.toString().toLowerCase() == toLowerCase(),
        orElse: () => RotationCycle.NEVER);
  }
}
