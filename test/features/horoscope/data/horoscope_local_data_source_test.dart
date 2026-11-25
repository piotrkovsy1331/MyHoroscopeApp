import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/features/horoscope/data/datasources/horoscope_local_data_source.dart';
import 'package:mystic_horoscope/features/horoscope/domain/entities/horoscope.dart';
import 'package:mystic_horoscope/features/horoscope/domain/entities/horoscope_period.dart';
import 'package:mystic_horoscope/features/zodiac/domain/entities/zodiac_sign.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late SharedPreferencesAsync prefs;
  late HoroscopeLocalDataSource source;

  final horoscope = Horoscope(
    sign: ZodiacSign.virgo,
    period: HoroscopePeriod.monthly,
    periodStart: DateTime(2026, 11),
    text: 'Recorded text',
    fetchedAt: DateTime(2026, 11, 25, 8),
  );

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    prefs = SharedPreferencesAsync();
    source = HoroscopeLocalDataSource(prefs);
  });

  test('returns null when nothing is cached', () async {
    expect(await source.read(ZodiacSign.virgo, HoroscopePeriod.daily), isNull);
  });

  test('writes and reads back per sign and period', () async {
    await source.write(horoscope);
    expect(
      await source.read(ZodiacSign.virgo, HoroscopePeriod.monthly),
      horoscope,
    );
    expect(await source.read(ZodiacSign.virgo, HoroscopePeriod.daily), isNull);
  });

  test('drops corrupted entries', () async {
    const key = 'horoscope_cache.virgo.daily';
    await prefs.setString(key, '{not json');
    expect(await source.read(ZodiacSign.virgo, HoroscopePeriod.daily), isNull);
    expect(await prefs.getString(key), isNull);
  });
}
