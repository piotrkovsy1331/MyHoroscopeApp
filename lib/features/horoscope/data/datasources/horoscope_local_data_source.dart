import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../zodiac/domain/entities/zodiac_sign.dart';
import '../../domain/entities/horoscope.dart';
import '../../domain/entities/horoscope_period.dart';
import '../models/horoscope_model.dart';

/// Keeps the latest reading per sign and period (36 entries at most), so
/// horoscopes stay readable offline.
class HoroscopeLocalDataSource {
  const HoroscopeLocalDataSource(this._prefs);

  final SharedPreferencesAsync _prefs;

  static String _key(ZodiacSign sign, HoroscopePeriod period) =>
      'horoscope_cache.${sign.id}.${period.name}';

  /// Returns null when nothing (valid) is cached.
  Future<Horoscope?> read(ZodiacSign sign, HoroscopePeriod period) async {
    final raw = await _prefs.getString(_key(sign, period));
    if (raw == null) return null;
    try {
      return HoroscopeModel.fromCacheJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } on Object {
      await _prefs.remove(_key(sign, period));
      return null;
    }
  }

  Future<void> write(Horoscope horoscope) => _prefs.setString(
    _key(horoscope.sign, horoscope.period),
    jsonEncode(HoroscopeModel.toCacheJson(horoscope)),
  );
}
