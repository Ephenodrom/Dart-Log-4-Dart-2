/// [Level]s to control logging output. Logging can be enabled to include all
/// levels above certain [Level]. [Level]s are ordered using an integer
/// value [Level.value]. The predefined [Level] constants below are sorted as
/// follows (in descending order): [Level.SHOUT], [Level.SEVERE],
/// [Level.WARNING], [Level.INFO], [Level.CONFIG], [Level.FINE], [Level.FINER],
/// [Level.FINEST], and [Level.ALL].
///
/// We recommend using one of the predefined logging levels. If you define your
/// own level, make sure you use a value between those used in [Level.ALL] and
/// [Level.OFF].
class Level implements Comparable<Level> {
  /// The name of the level
  final String name;

  /// Unique value for this level.
  final int value;

  const Level(this.name, this.value);

  /// Special key to turn on logging for all levels ([value] = 0).
  static const Level ALL = Level('ALL', 0);

  /// Special key to turn on logging for trace levels ([value] = 100).
  static const Level TRACE = Level('TRACE', 100);

  /// Special key to turn on logging for trace levels ([value] = 200).
  static const Level DEBUG = Level('DEBUG', 200);

  /// Key for informational messages ([value] = 300).
  static const Level INFO = Level('INFO', 300);

  /// Key for potential problems ([value] = 400).
  static const Level WARNING = Level('WARNING', 400);

  /// Key for serious failures ([value] = 500).
  static const Level ERROR = Level('ERROR', 500);

  /// Key for fatal failures ([value] = 600).
  static const Level FATAL = Level('FATAL', 600);

  /// Special key to turn off all logging ([value] = 700).
  static const Level OFF = Level('OFF', 700);

  static const List<Level> LEVELS = [
    ALL,
    TRACE,
    DEBUG,
    INFO,
    WARNING,
    ERROR,
    FATAL,
    OFF
  ];

  @override
  bool operator ==(Object other) => other is Level && value == other.value;

  bool operator <(Level other) => value < other.value;

  bool operator <=(Level other) => value <= other.value;

  bool operator >(Level other) => value > other.value;

  bool operator >=(Level other) => value >= other.value;

  @override
  int compareTo(Level other) => value - other.value;

  @override
  int get hashCode => value;

  @override
  String toString() => name;

  ///
  /// Converts the given String [s] to the log level.
  ///
  /// Returns null if no log level was found.
  ///
  static Level fromString(String s) {
    for (var l in LEVELS) {
      if (l.name.toLowerCase() == s.toLowerCase()) {
        return l;
      }
    }
    return null;
  }
}
