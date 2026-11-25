import 'dart:math' as math;

/// Low-precision geocentric positions after Jean Meeus, "Astronomical
/// Algorithms" (2nd ed.): Sun ch. 25, Moon ch. 47 (main periodic terms),
/// sidereal time ch. 12. All longitudes are tropical ecliptic degrees
/// 0..360 for the mean equinox of date.
///
/// Verified against Swiss Ephemeris (see tests): Sun < 0.01°,
/// Moon < 0.05°, Ascendant < 0.1°. ΔT (TT−UT, ~1 min) is ignored, which
/// is far below the precision needed to determine zodiac signs.
abstract final class Ephemeris {
  static double sunLongitude(DateTime utc) {
    final t = _centuries(utc);
    final l0 = 280.46646 + 36000.76983 * t + 0.0003032 * t * t;
    final m = _rad(357.52911 + 35999.05029 * t - 0.0001537 * t * t);
    final c =
        (1.914602 - 0.004817 * t - 0.000014 * t * t) * math.sin(m) +
        (0.019993 - 0.000101 * t) * math.sin(2 * m) +
        0.000289 * math.sin(3 * m);
    final omega = _rad(125.04 - 1934.136 * t);
    // Apparent longitude: aberration and nutation in longitude.
    return _norm(l0 + c - 0.00569 - 0.00478 * math.sin(omega));
  }

  static double moonLongitude(DateTime utc) {
    final t = _centuries(utc);
    final t2 = t * t, t3 = t2 * t, t4 = t3 * t;
    final lp =
        218.3164477 +
        481267.88123421 * t -
        0.0015786 * t2 +
        t3 / 538841 -
        t4 / 65194000;
    final d =
        297.8501921 +
        445267.1114034 * t -
        0.0018819 * t2 +
        t3 / 545868 -
        t4 / 113065000;
    final m = 357.5291092 + 35999.0502909 * t - 0.0001536 * t2 + t3 / 24490000;
    final mp =
        134.9633964 +
        477198.8675055 * t +
        0.0087414 * t2 +
        t3 / 69699 -
        t4 / 14712000;
    final f =
        93.2720950 +
        483202.0175233 * t -
        0.0036539 * t2 -
        t3 / 3526000 +
        t4 / 863310000;
    final e = 1 - 0.002516 * t - 0.0000074 * t2;

    var sum = 0.0;
    for (final (cd, cm, cmp, cf, coeff) in _moonTerms) {
      final arg = _rad(cd * d + cm * m + cmp * mp + cf * f);
      final eFactor = switch (cm.abs()) {
        1 => e,
        2 => e * e,
        _ => 1.0,
      };
      sum += coeff * eFactor * math.sin(arg);
    }
    final a1 = _rad(119.75 + 131.849 * t);
    final a2 = _rad(53.09 + 479264.290 * t);
    sum +=
        3958 * math.sin(a1) +
        1962 * math.sin(_rad(lp - f)) +
        318 * math.sin(a2);

    final omega = _rad(125.04452 - 1934.136261 * t);
    // Geometric longitude + nutation in longitude (main term).
    return _norm(lp + sum / 1e6 - 0.00478 * math.sin(omega));
  }

  /// Ecliptic longitude of the Ascendant for an observer at
  /// [latitude]/[longitude] (degrees, east positive).
  ///
  /// Returns null above the polar circles, where the Ascendant is not
  /// well defined for part of the day.
  static double? ascendant(
    DateTime utc, {
    required double latitude,
    required double longitude,
  }) {
    if (latitude.abs() >= 66) return null;
    final t = _centuries(utc);
    final eps = _rad(23.4392911 - 0.0130042 * t);
    final ramc = _rad(_norm(greenwichSiderealTime(utc) + longitude));
    final phi = _rad(latitude);
    final asc = math.atan2(
      math.cos(ramc),
      -(math.sin(ramc) * math.cos(eps) + math.tan(phi) * math.sin(eps)),
    );
    return _norm(_deg(asc));
  }

  /// Greenwich mean sidereal time in degrees.
  static double greenwichSiderealTime(DateTime utc) {
    final jd = julianDay(utc);
    final t = (jd - 2451545.0) / 36525;
    return _norm(
      280.46061837 +
          360.98564736629 * (jd - 2451545.0) +
          0.000387933 * t * t -
          t * t * t / 38710000,
    );
  }

  static double julianDay(DateTime utc) =>
      utc.toUtc().millisecondsSinceEpoch / Duration.millisecondsPerDay +
      2440587.5;

  static double _centuries(DateTime utc) =>
      (julianDay(utc) - 2451545.0) / 36525;

  static double _rad(double deg) => deg * math.pi / 180;
  static double _deg(double rad) => rad * 180 / math.pi;
  static double _norm(double deg) => ((deg % 360) + 360) % 360;

  /// Meeus Table 47.A: multiples of D, M, M', F and the longitude
  /// coefficient in 10^-6 degrees.
  static const List<(int, int, int, int, int)> _moonTerms = [
    (0, 0, 1, 0, 6288774),
    (2, 0, -1, 0, 1274027),
    (2, 0, 0, 0, 658314),
    (0, 0, 2, 0, 213618),
    (0, 1, 0, 0, -185116),
    (0, 0, 0, 2, -114332),
    (2, 0, -2, 0, 58793),
    (2, -1, -1, 0, 57066),
    (2, 0, 1, 0, 53322),
    (2, -1, 0, 0, 45758),
    (0, 1, -1, 0, -40923),
    (1, 0, 0, 0, -34720),
    (0, 1, 1, 0, -30383),
    (2, 0, 0, -2, 15327),
    (0, 0, 1, 2, -12528),
    (0, 0, 1, -2, 10980),
    (4, 0, -1, 0, 10675),
    (0, 0, 3, 0, 10034),
    (4, 0, -2, 0, 8548),
    (2, 1, -1, 0, -7888),
    (2, 1, 0, 0, -6766),
    (1, 0, -1, 0, -5163),
    (1, 1, 0, 0, 4987),
    (2, -1, 1, 0, 4036),
    (2, 0, 2, 0, 3994),
    (4, 0, 0, 0, 3861),
    (2, 0, -3, 0, 3665),
    (0, 1, -2, 0, -2689),
    (2, 0, -1, 2, -2602),
    (2, -1, -2, 0, 2390),
    (1, 0, 1, 0, -2348),
    (2, -2, 0, 0, 2236),
    (0, 1, 2, 0, -2120),
    (0, 2, 0, 0, -2069),
    (2, -2, -1, 0, 2048),
    (2, 0, 1, -2, -1773),
    (2, 0, 0, 2, -1595),
    (4, -1, -1, 0, 1215),
    (0, 0, 2, 2, -1110),
    (3, 0, -1, 0, -892),
    (2, 1, 1, 0, -810),
    (4, -1, -2, 0, 759),
    (0, 2, -1, 0, -713),
    (2, 2, -1, 0, -700),
    (2, 1, -2, 0, 691),
    (2, -1, 0, -2, 596),
    (4, 0, 1, 0, 549),
    (0, 0, 4, 0, 537),
    (4, -1, 0, 0, 520),
    (1, 0, -2, 0, -487),
    (2, 1, 0, -2, -399),
    (0, 0, 2, -2, -381),
    (1, 1, 1, 0, 351),
    (3, 0, -2, 0, -340),
    (4, 0, -3, 0, 330),
    (2, -1, 2, 0, 327),
    (0, 2, 1, 0, -323),
    (1, 1, -1, 0, 299),
    (2, 0, 3, 0, 294),
  ];
}
