import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../horoscope/data/models/horoscope_model.dart';
import '../../domain/entities/favorite_horoscope.dart';

class FavoritesLocalDataSource {
  const FavoritesLocalDataSource(this._prefs);

  final SharedPreferencesAsync _prefs;
  static const _key = 'favorites.v1';

  Future<List<FavoriteHoroscope>> readAll() async {
    final raw = await _prefs.getString(_key);
    if (raw == null) return const [];
    final result = <FavoriteHoroscope>[];
    try {
      for (final item in jsonDecode(raw) as List<dynamic>) {
        final json = item as Map<String, dynamic>;
        // One damaged entry must not wipe the others.
        try {
          result.add(
            FavoriteHoroscope(
              horoscope: HoroscopeModel.fromCacheJson(
                json['horoscope'] as Map<String, dynamic>,
              ),
              savedAt: DateTime.parse(json['savedAt'] as String),
            ),
          );
        } on Object {
          continue;
        }
      }
    } on Object {
      return const [];
    }
    return result;
  }

  Future<void> writeAll(List<FavoriteHoroscope> favorites) => _prefs.setString(
    _key,
    jsonEncode([
      for (final f in favorites)
        {
          'horoscope': HoroscopeModel.toCacheJson(f.horoscope),
          'savedAt': f.savedAt.toIso8601String(),
        },
    ]),
  );
}
