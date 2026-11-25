import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/birth_data.dart';
import '../../domain/entities/birth_place.dart';

/// Persists the profile on the device only.
class ProfileLocalDataSource {
  const ProfileLocalDataSource(this._prefs);

  final SharedPreferencesAsync _prefs;
  static const _key = 'profile.birth_data.v1';

  Future<BirthData?> read() async {
    final raw = await _prefs.getString(_key);
    if (raw == null) return null;
    try {
      return _fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      await _prefs.remove(_key);
      return null;
    }
  }

  Future<void> write(BirthData data) =>
      _prefs.setString(_key, jsonEncode(_toJson(data)));

  Future<void> clear() => _prefs.remove(_key);

  static Map<String, dynamic> _toJson(BirthData d) => {
    'date': '${d.date.year}-${d.date.month}-${d.date.day}',
    if (d.time case final t?) 'time': {'h': t.hour, 'm': t.minute},
    if (d.place case final p?)
      'place': {
        'name': p.name,
        'region': p.region,
        'country': p.country,
        'lat': p.latitude,
        'lon': p.longitude,
        'tz': p.timeZoneId,
      },
  };

  static BirthData _fromJson(Map<String, dynamic> json) {
    final [y, m, d] = (json['date'] as String)
        .split('-')
        .map(int.parse)
        .toList();
    final time = json['time'] as Map<String, dynamic>?;
    final place = json['place'] as Map<String, dynamic>?;
    return BirthData(
      date: DateTime(y, m, d),
      time: time == null
          ? null
          : (hour: time['h'] as int, minute: time['m'] as int),
      place: place == null
          ? null
          : BirthPlace(
              name: place['name'] as String,
              region: place['region'] as String,
              country: place['country'] as String,
              latitude: (place['lat'] as num).toDouble(),
              longitude: (place['lon'] as num).toDouble(),
              timeZoneId: place['tz'] as String,
            ),
    );
  }
}
