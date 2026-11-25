import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/birth_place.dart';

/// Offline city search over GeoNames `cities15000` (CC BY 4.0), bundled as
/// `assets/data/cities.tsv` by `tool/build_cities.py`.
class PlacesLocalDataSource {
  PlacesLocalDataSource({AssetBundle? bundle, this.assetPath = defaultAsset})
    : _bundle = bundle ?? rootBundle;

  static const defaultAsset = 'assets/data/cities.tsv';

  final AssetBundle _bundle;
  final String assetPath;
  Future<List<_City>>? _cities;

  Future<List<BirthPlace>> search(String query, {required int limit}) async {
    final cities = await (_cities ??= _load());
    final q = foldForSearch(query);
    final results = <BirthPlace>[];
    // Rows are sorted by population, so the first matches rank best.
    for (final city in cities) {
      if (city.key.startsWith(q) || city.altKey.startsWith(q)) {
        results.add(city.place);
        if (results.length == limit) break;
      }
    }
    return results;
  }

  Future<List<_City>> _load() async {
    final raw = await _bundle.loadString(assetPath, cache: false);
    // ~34k rows: parse off the UI isolate.
    return compute(_parse, raw);
  }

  /// Lower-case and strip common Latin diacritics so "krakow" finds
  /// "Kraków" and "zurich" finds "Zürich".
  static String foldForSearch(String input) {
    final lower = input.toLowerCase().trim();
    final buffer = StringBuffer();
    for (final rune in lower.runes) {
      final char = String.fromCharCode(rune);
      buffer.write(_fold[char] ?? char);
    }
    return buffer.toString();
  }

  static const _fold = {
    'á': 'a',
    'à': 'a',
    'â': 'a',
    'ä': 'a',
    'ã': 'a',
    'å': 'a',
    'ą': 'a',
    'ć': 'c',
    'č': 'c',
    'ç': 'c',
    'ď': 'd',
    'é': 'e',
    'è': 'e',
    'ê': 'e',
    'ë': 'e',
    'ę': 'e',
    'ě': 'e',
    'í': 'i',
    'ì': 'i',
    'î': 'i',
    'ï': 'i',
    'ł': 'l',
    'ľ': 'l',
    'ń': 'n',
    'ñ': 'n',
    'ň': 'n',
    'ó': 'o',
    'ò': 'o',
    'ô': 'o',
    'ö': 'o',
    'õ': 'o',
    'ø': 'o',
    'ő': 'o',
    'ř': 'r',
    'ś': 's',
    'š': 's',
    'ş': 's',
    'ß': 'ss',
    'ť': 't',
    'ú': 'u',
    'ù': 'u',
    'û': 'u',
    'ü': 'u',
    'ů': 'u',
    'ű': 'u',
    'ý': 'y',
    'ź': 'z',
    'ż': 'z',
    'ž': 'z',
  };
}

class _City {
  const _City(this.key, this.altKey, this.place);

  final String key;
  final String altKey;
  final BirthPlace place;
}

List<_City> _parse(String raw) {
  final lines = raw.split('\n');
  final zones = lines[0].split('\t').sublist(1);
  final countries = {
    for (final entry in lines[1].split('\t').skip(1))
      entry.substring(0, entry.indexOf('=')): entry.substring(
        entry.indexOf('=') + 1,
      ),
  };
  final cities = <_City>[];
  for (final line in lines.skip(2)) {
    if (line.isEmpty) continue;
    final c = line.split('\t');
    final name = c[0];
    final ascii = c[1].isEmpty ? name : c[1];
    cities.add(
      _City(
        PlacesLocalDataSource.foldForSearch(name),
        ascii.toLowerCase(),
        BirthPlace(
          name: name,
          region: c[3],
          country: countries[c[2]] ?? c[2],
          latitude: double.parse(c[4]),
          longitude: double.parse(c[5]),
          timeZoneId: zones[int.parse(c[6])],
        ),
      ),
    );
  }
  return cities;
}
