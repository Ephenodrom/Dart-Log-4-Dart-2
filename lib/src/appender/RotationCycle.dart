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

  /// Rotate on a yearly basis every first day of the year
  YEAR
}
