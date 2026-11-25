import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/core/error/exceptions.dart';
import 'package:mystic_horoscope/features/horoscope/data/models/horoscope_model.dart';
import 'package:mystic_horoscope/features/horoscope/domain/entities/horoscope_period.dart';
import 'package:mystic_horoscope/features/zodiac/domain/entities/zodiac_sign.dart';

import '../../../helpers/fixtures.dart';

void main() {
  final fetchedAt = DateTime(2026, 11, 25, 9);

  group('fromApiJson (recorded FreeHoroscopeAPI payloads)', () {
    test('daily', () {
      final h = HoroscopeModel.fromApiJson(
        fixtureJson('free_horoscope_api_daily_leo.json'),
        period: HoroscopePeriod.daily,
        fetchedAt: fetchedAt,
      );
      expect(h.sign, ZodiacSign.leo);
      expect(h.periodStart, DateTime(2026, 11, 25));
      expect(h.text, isNotEmpty);
      expect(h.isStale, isFalse);
    });

    test('weekly uses the week start date', () {
      final h = HoroscopeModel.fromApiJson(
        fixtureJson('free_horoscope_api_weekly_leo.json'),
        period: HoroscopePeriod.weekly,
        fetchedAt: fetchedAt,
      );
      expect(h.periodStart, DateTime(2026, 11, 23));
    });

    test('monthly parses YYYY-MM', () {
      final h = HoroscopeModel.fromApiJson(
        fixtureJson('free_horoscope_api_monthly_leo.json'),
        period: HoroscopePeriod.monthly,
        fetchedAt: fetchedAt,
      );
      expect(h.periodStart, DateTime(2026, 11));
    });

    test('rejects error payloads and incomplete data', () {
      Object parse(Map<String, dynamic> json) => HoroscopeModel.fromApiJson(
        json,
        period: HoroscopePeriod.daily,
        fetchedAt: fetchedAt,
      );
      expect(
        () => parse({'error': 'Invalid sign', 'code': 'invalid_sign'}),
        throwsA(isA<ParseException>()),
      );
      expect(
        () => parse({
          'data': {'date': '2026-11-25', 'sign': 'Leo', 'horoscope': '  '},
        }),
        throwsA(isA<ParseException>()),
      );
      expect(
        () => parse({
          'data': {'date': 'today', 'sign': 'Leo', 'horoscope': 'x'},
        }),
        throwsA(isA<ParseException>()),
      );
    });
  });

  test('cache JSON round-trips', () {
    final original = HoroscopeModel.fromApiJson(
      fixtureJson('free_horoscope_api_daily_leo.json'),
      period: HoroscopePeriod.daily,
      fetchedAt: fetchedAt,
    );
    final restored = HoroscopeModel.fromCacheJson(
      HoroscopeModel.toCacheJson(original),
    );
    expect(restored, original);
  });
}
