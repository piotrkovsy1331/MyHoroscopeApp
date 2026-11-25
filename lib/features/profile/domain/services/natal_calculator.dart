import '../../../../core/astronomy/ephemeris.dart';
import '../../../zodiac/domain/entities/zodiac_sign.dart';
import '../entities/birth_data.dart';
import '../entities/natal_chart.dart';
import 'time_zone_resolver.dart';

/// Computes Sun, Moon and Ascendant signs, honest about uncertainty.
///
/// The birth instant is only known exactly with both time and place.
/// Otherwise every instant the birth could have happened at is scanned
/// and all signs a body passed through are reported:
/// - no time, place known: the whole local day in the place's zone;
/// - time known, no place: that wall-clock time in any zone (UTC−12…+14);
/// - neither: the whole day in any zone.
class NatalCalculator {
  const NatalCalculator(this._timeZones);

  final TimeZoneResolver _timeZones;

  static const _step = Duration(minutes: 30);

  NatalChart calculate(BirthData data) {
    final (start, end, exact) = _utcWindow(data);
    final place = data.place;

    final Placement ascendant;
    if (place == null || !exact) {
      ascendant = const UnavailablePlacement(
        UnavailableReason.needsTimeAndPlace,
      );
    } else {
      final lon = Ephemeris.ascendant(
        start,
        latitude: place.latitude,
        longitude: place.longitude,
      );
      ascendant = lon == null
          ? const UnavailablePlacement(UnavailableReason.polarLatitude)
          : KnownPlacement(ZodiacSign.fromLongitude(lon));
    }

    return NatalChart(
      sun: _scan(start, end, Ephemeris.sunLongitude),
      moon: _scan(start, end, Ephemeris.moonLongitude),
      ascendant: ascendant,
    );
  }

  /// Possible UTC birth instants; `exact` when the instant is certain.
  (DateTime, DateTime, bool) _utcWindow(BirthData data) {
    final d = data.date;
    final time = data.time;
    final zone = data.place?.timeZoneId;

    if (zone != null) {
      try {
        if (time != null) {
          final utc = _timeZones.toUtc(
            zone,
            DateTime(d.year, d.month, d.day, time.hour, time.minute),
          );
          return (utc, utc, true);
        }
        return (
          _timeZones.toUtc(zone, DateTime(d.year, d.month, d.day)),
          _timeZones.toUtc(zone, DateTime(d.year, d.month, d.day, 23, 59)),
          false,
        );
      } on ArgumentError {
        // Unknown zone: fall through to the zone-independent window.
      }
    }

    // Wall clock read as UTC, then widened by every possible UTC offset.
    final wall = time == null
        ? (
            DateTime.utc(d.year, d.month, d.day),
            DateTime.utc(d.year, d.month, d.day, 23, 59),
          )
        : (
            DateTime.utc(d.year, d.month, d.day, time.hour, time.minute),
            DateTime.utc(d.year, d.month, d.day, time.hour, time.minute),
          );
    return (
      wall.$1.subtract(const Duration(hours: 14)),
      wall.$2.add(const Duration(hours: 12)),
      false,
    );
  }

  Placement _scan(
    DateTime start,
    DateTime end,
    double Function(DateTime) longitude,
  ) {
    final signs = <ZodiacSign>[];
    void add(DateTime t) {
      final sign = ZodiacSign.fromLongitude(longitude(t));
      if (!signs.contains(sign)) signs.add(sign);
    }

    for (var t = start; t.isBefore(end); t = t.add(_step)) {
      add(t);
    }
    add(end);
    return signs.length == 1
        ? KnownPlacement(signs.single)
        : AmbiguousPlacement(List.unmodifiable(signs));
  }
}
