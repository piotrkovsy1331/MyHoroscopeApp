import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/core/astronomy/ephemeris.dart';

/// Reference values generated with Swiss Ephemeris 2.10.03 (Moshier mode,
/// Placidus Ascendant) – used only to produce these test vectors.
final _vectors = [
  (
    'Warsaw 1990-07-15 14:30Z',
    DateTime.utc(1990, 7, 15, 14, 30),
    52.2297,
    21.0122,
    112.8455,
    24.7208,
    236.8650,
  ),
  (
    'New York 1985-01-03 05:10Z',
    DateTime.utc(1985, 1, 3, 5, 10),
    40.7128,
    -74.006,
    282.7742,
    56.4753,
    192.8985,
  ),
  (
    'Sydney 2001-11-20 22:45Z',
    DateTime.utc(2001, 11, 20, 22, 45),
    -33.8688,
    151.2093,
    238.6844,
    306.5082,
    295.4678,
  ),
  (
    'London 1969-07-20 20:17Z',
    DateTime.utc(1969, 7, 20, 20, 17),
    51.5074,
    -0.1278,
    117.9108,
    187.8739,
    304.2509,
  ),
  (
    'Tokyo 2010-03-21 00:00Z',
    DateTime.utc(2010, 3, 21, 0, 0),
    35.6762,
    139.6503,
    0.2676,
    59.7431,
    66.2269,
  ),
  (
    'Reykjavik 1975-12-31 12:00Z',
    DateTime.utc(1975, 12, 31, 12, 0),
    64.1466,
    -21.9426,
    279.1815,
    265.3203,
    288.7368,
  ),
  (
    'Quito 2024-02-29 18:00Z',
    DateTime.utc(2024, 2, 29, 18, 0),
    -0.1807,
    -78.4678,
    340.6386,
    217.4513,
    81.2702,
  ),
];

/// Smallest angular distance between two longitudes.
double _diff(double a, double b) {
  final d = (a - b).abs() % 360;
  return d > 180 ? 360 - d : d;
}

void main() {
  test('Julian Day of J2000.0', () {
    expect(Ephemeris.julianDay(DateTime.utc(2000, 1, 1, 12)), 2451545.0);
  });

  for (final (label, utc, lat, lon, sun, moon, asc) in _vectors) {
    group(label, () {
      test('Sun', () {
        expect(_diff(Ephemeris.sunLongitude(utc), sun), lessThan(0.01));
      });
      test('Moon', () {
        expect(_diff(Ephemeris.moonLongitude(utc), moon), lessThan(0.05));
      });
      test('Ascendant', () {
        final value = Ephemeris.ascendant(utc, latitude: lat, longitude: lon);
        expect(value, isNotNull);
        expect(_diff(value!, asc), lessThan(0.1));
      });
    });
  }

  test('Ascendant is unavailable inside the polar circles', () {
    expect(
      Ephemeris.ascendant(
        DateTime.utc(2000),
        latitude: 69.65,
        longitude: 18.96,
      ),
      isNull,
    );
  });
}
