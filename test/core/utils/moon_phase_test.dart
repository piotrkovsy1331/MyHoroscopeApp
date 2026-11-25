import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/core/utils/moon_phase.dart';

void main() {
  // Reference lunations (UTC) from published almanac data.
  test('is near new moon on 2024-01-11 11:57 UTC', () {
    final phase = MoonPhase.at(DateTime.utc(2024, 1, 11, 11, 57));
    final distanceFromNew = phase.fraction < 0.5
        ? phase.fraction
        : 1 - phase.fraction;
    expect(distanceFromNew, lessThan(0.03));
    expect(phase.name, MoonPhaseName.newMoon);
    expect(phase.illumination, lessThan(0.02));
  });

  test('is near full moon on 2024-01-25 17:54 UTC', () {
    final phase = MoonPhase.at(DateTime.utc(2024, 1, 25, 17, 54));
    expect(phase.fraction, closeTo(0.5, 0.03));
    expect(phase.name, MoonPhaseName.fullMoon);
    expect(phase.illumination, greaterThan(0.98));
  });

  test('is a waxing first quarter on 2024-01-18 03:53 UTC', () {
    final phase = MoonPhase.at(DateTime.utc(2024, 1, 18, 3, 53));
    expect(phase.name, MoonPhaseName.firstQuarter);
    expect(phase.isWaxing, isTrue);
  });

  test('is a waning last quarter on 2024-02-02 23:18 UTC', () {
    final phase = MoonPhase.at(DateTime.utc(2024, 2, 2, 23, 18));
    expect(phase.name, MoonPhaseName.lastQuarter);
    expect(phase.isWaxing, isFalse);
  });
}
