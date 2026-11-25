import 'dart:math' as math;

/// The eight traditional phases of the Moon.
enum MoonPhaseName {
  newMoon,
  waxingCrescent,
  firstQuarter,
  waxingGibbous,
  fullMoon,
  waningGibbous,
  lastQuarter,
  waningCrescent,
}

/// Moon phase for a given instant, computed from the mean synodic month.
///
/// Accuracy is about ±0.5 day, which is plenty for showing the current
/// phase; it is not meant for eclipse-grade precision.
class MoonPhase {
  const MoonPhase._(this.fraction);

  factory MoonPhase.at(DateTime instant) {
    final days =
        instant.toUtc().difference(_referenceNewMoon).inSeconds /
        Duration.secondsPerDay;
    final cycles = days / synodicMonthDays;
    return MoonPhase._(cycles - cycles.floorToDouble());
  }

  /// Mean length of a lunation in days.
  static const synodicMonthDays = 29.530588853;

  /// Known new moon: 2000-01-06 18:14 UTC.
  static final _referenceNewMoon = DateTime.utc(2000, 1, 6, 18, 14);

  /// Position in the cycle: 0 = new, 0.25 = first quarter, 0.5 = full,
  /// 0.75 = last quarter.
  final double fraction;

  bool get isWaxing => fraction < 0.5;

  /// Days since the last new moon.
  double get ageInDays => fraction * synodicMonthDays;

  /// Illuminated part of the disc, 0..1.
  double get illumination => (1 - math.cos(2 * math.pi * fraction)) / 2;

  MoonPhaseName get name {
    // Eight equal buckets centred on the principal phases.
    final index = ((fraction * 8) + 0.5).floor() % 8;
    return MoonPhaseName.values[index];
  }
}
