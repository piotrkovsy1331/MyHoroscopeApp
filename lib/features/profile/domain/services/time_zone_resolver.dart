/// Converts a historical local wall-clock time to UTC using the rules of
/// an IANA time zone in force at that date (incl. daylight saving time).
abstract interface class TimeZoneResolver {
  /// Throws [ArgumentError] for an unknown [zoneId].
  DateTime toUtc(String zoneId, DateTime localWallClock);
}
