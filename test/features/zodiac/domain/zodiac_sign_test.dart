import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/features/zodiac/domain/entities/zodiac_sign.dart';

void main() {
  group('ZodiacSign.fromDate', () {
    test('every day of a leap year belongs to exactly one sign', () {
      var day = DateTime(2024);
      final seen = <ZodiacSign>{};
      while (day.year == 2024) {
        final matches = ZodiacSign.values.where((s) => s.containsDate(day));
        expect(matches, hasLength(1), reason: '$day');
        seen.add(matches.single);
        day = DateTime(day.year, day.month, day.day + 1);
      }
      expect(seen, ZodiacSign.values.toSet());
    });

    test('respects range boundaries', () {
      expect(ZodiacSign.fromDate(DateTime(2001, 3, 20)), ZodiacSign.pisces);
      expect(ZodiacSign.fromDate(DateTime(2001, 3, 21)), ZodiacSign.aries);
      expect(ZodiacSign.fromDate(DateTime(2001, 7, 23)), ZodiacSign.leo);
      expect(
        ZodiacSign.fromDate(DateTime(2001, 11, 25)),
        ZodiacSign.sagittarius,
      );
    });

    test('handles Capricorn spanning the new year', () {
      expect(ZodiacSign.fromDate(DateTime(2001, 12, 22)), ZodiacSign.capricorn);
      expect(ZodiacSign.fromDate(DateTime(2002, 1, 1)), ZodiacSign.capricorn);
      expect(ZodiacSign.fromDate(DateTime(2002, 1, 19)), ZodiacSign.capricorn);
      expect(ZodiacSign.fromDate(DateTime(2002, 1, 20)), ZodiacSign.aquarius);
    });
  });

  test('tryParse is case-insensitive and rejects unknown ids', () {
    expect(ZodiacSign.tryParse('Leo'), ZodiacSign.leo);
    expect(ZodiacSign.tryParse('ophiuchus'), isNull);
    expect(ZodiacSign.tryParse(null), isNull);
  });

  test('ids match the FreeHoroscopeAPI sign enum', () {
    expect(ZodiacSign.values.map((s) => s.id), [
      'aries',
      'taurus',
      'gemini',
      'cancer',
      'leo',
      'virgo',
      'libra',
      'scorpio',
      'sagittarius',
      'capricorn',
      'aquarius',
      'pisces',
    ]);
  });
}
