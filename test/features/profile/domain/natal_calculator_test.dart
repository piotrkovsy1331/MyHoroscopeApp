import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/features/profile/data/services/tz_time_zone_resolver.dart';
import 'package:mystic_horoscope/features/profile/domain/entities/birth_data.dart';
import 'package:mystic_horoscope/features/profile/domain/entities/birth_place.dart';
import 'package:mystic_horoscope/features/profile/domain/entities/natal_chart.dart';
import 'package:mystic_horoscope/features/profile/domain/services/natal_calculator.dart';
import 'package:mystic_horoscope/features/zodiac/domain/entities/zodiac_sign.dart';

const _warsaw = BirthPlace(
  name: 'Warsaw',
  region: 'Mazovia',
  country: 'Poland',
  latitude: 52.2297,
  longitude: 21.0122,
  timeZoneId: 'Europe/Warsaw',
);

const _tromso = BirthPlace(
  name: 'Tromsø',
  region: 'Troms',
  country: 'Norway',
  latitude: 69.6496,
  longitude: 18.956,
  timeZoneId: 'Europe/Oslo',
);

void main() {
  final calculator = NatalCalculator(TzTimeZoneResolver());

  test('full data: exact Sun, Moon and Ascendant', () {
    // 16:30 CEST = 14:30 UTC; Swiss Ephemeris: Sun 112.8° (Cancer),
    // Moon 24.7° (Aries), Ascendant 236.9° (Scorpio).
    final chart = calculator.calculate(
      BirthData(
        date: DateTime(1990, 7, 15),
        time: (hour: 16, minute: 30),
        place: _warsaw,
      ),
    );
    expect(chart.sun, const KnownPlacement(ZodiacSign.cancer));
    expect(chart.moon, const KnownPlacement(ZodiacSign.aries));
    expect(chart.ascendant, const KnownPlacement(ZodiacSign.scorpio));
  });

  test('no time: Moon still known when it stays in one sign all day', () {
    final chart = calculator.calculate(
      BirthData(date: DateTime(1990, 7, 15), place: _warsaw),
    );
    expect(chart.moon, const KnownPlacement(ZodiacSign.aries));
    expect(
      chart.ascendant,
      const UnavailablePlacement(UnavailableReason.needsTimeAndPlace),
    );
  });

  test('Sun on a cusp day without time is reported as ambiguous', () {
    // March equinox 2024 was 03:06 UTC on March 20.
    final chart = calculator.calculate(BirthData(date: DateTime(2024, 3, 20)));
    expect(
      chart.sun,
      const AmbiguousPlacement([ZodiacSign.pisces, ZodiacSign.aries]),
    );
  });

  test('time without place widens the window to all UTC offsets', () {
    // Swiss Ephemeris: Moon enters Taurus 1990-07-15 ~23:00 UTC, inside
    // the 12:00 wall-clock window (22:00Z on the 14th to 00:00Z on 16th).
    final chart = calculator.calculate(
      BirthData(date: DateTime(1990, 7, 15), time: (hour: 12, minute: 0)),
    );
    expect(
      chart.moon,
      const AmbiguousPlacement([ZodiacSign.aries, ZodiacSign.taurus]),
    );
    expect(
      chart.ascendant,
      const UnavailablePlacement(UnavailableReason.needsTimeAndPlace),
    );
  });

  test('Ascendant is unavailable above the polar circle', () {
    final chart = calculator.calculate(
      BirthData(
        date: DateTime(1995, 1, 10),
        time: (hour: 9, minute: 0),
        place: _tromso,
      ),
    );
    expect(
      chart.ascendant,
      const UnavailablePlacement(UnavailableReason.polarLatitude),
    );
  });

  test('unknown time zone never yields a fake exact Ascendant', () {
    const broken = BirthPlace(
      name: 'Nowhere',
      region: '',
      country: '',
      latitude: 10,
      longitude: 10,
      timeZoneId: 'Mars/Olympus_Mons',
    );
    final chart = calculator.calculate(
      BirthData(
        date: DateTime(2000, 6, 1),
        time: (hour: 12, minute: 0),
        place: broken,
      ),
    );
    expect(chart.ascendant, isA<UnavailablePlacement>());
  });
}
