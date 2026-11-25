import 'package:mystic_horoscope/features/favorites/domain/entities/favorite_horoscope.dart';
import 'package:mystic_horoscope/features/horoscope/domain/entities/horoscope.dart';
import 'package:mystic_horoscope/features/horoscope/domain/entities/horoscope_period.dart';
import 'package:mystic_horoscope/features/zodiac/domain/entities/zodiac_sign.dart';

Horoscope sampleHoroscope({
  ZodiacSign sign = ZodiacSign.leo,
  HoroscopePeriod period = HoroscopePeriod.daily,
  DateTime? periodStart,
  String text = 'A reading from the provider.',
  bool isStale = false,
}) => Horoscope(
  sign: sign,
  period: period,
  periodStart: periodStart ?? DateTime(2026, 11, 25),
  text: text,
  fetchedAt: DateTime(2026, 11, 25, 8),
  isStale: isStale,
);

FavoriteHoroscope sampleFavorite({
  ZodiacSign sign = ZodiacSign.leo,
  HoroscopePeriod period = HoroscopePeriod.daily,
  DateTime? savedAt,
  String text = 'A reading from the provider.',
}) => FavoriteHoroscope(
  horoscope: sampleHoroscope(sign: sign, period: period, text: text),
  savedAt: savedAt ?? DateTime(2026, 11, 25, 9),
);
