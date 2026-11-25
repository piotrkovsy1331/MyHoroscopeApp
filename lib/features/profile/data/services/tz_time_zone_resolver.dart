import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/services/time_zone_resolver.dart';

/// [TimeZoneResolver] backed by the full IANA history bundled in
/// `package:timezone` (needed for births long before today).
class TzTimeZoneResolver implements TimeZoneResolver {
  TzTimeZoneResolver() {
    if (!_initialized) {
      tz_data.initializeTimeZones();
      _initialized = true;
    }
  }

  static bool _initialized = false;

  @override
  DateTime toUtc(String zoneId, DateTime localWallClock) {
    final tz.Location location;
    try {
      location = tz.getLocation(zoneId);
    } on tz.LocationNotFoundException {
      throw ArgumentError.value(zoneId, 'zoneId', 'Unknown time zone');
    }
    final w = localWallClock;
    return tz.TZDateTime(
      location,
      w.year,
      w.month,
      w.day,
      w.hour,
      w.minute,
    ).toUtc();
  }

  /// Whether [zoneId] is known (used to validate the bundled city data).
  bool isKnown(String zoneId) =>
      tz.timeZoneDatabase.locations.containsKey(zoneId);
}
