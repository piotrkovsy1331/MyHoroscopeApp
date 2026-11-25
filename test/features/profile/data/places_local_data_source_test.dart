import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/features/profile/data/datasources/places_local_data_source.dart';
import 'package:mystic_horoscope/features/profile/data/services/tz_time_zone_resolver.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final source = PlacesLocalDataSource();

  test(
    'finds cities with and without diacritics, most populous first',
    () async {
      final krakow = await source.search('krakow', limit: 5);
      expect(krakow.first.name, 'Kraków');
      expect(krakow.first.country, 'Poland');
      expect(krakow.first.timeZoneId, 'Europe/Warsaw');

      final zurich = await source.search('Zür', limit: 5);
      expect(zurich.first.name, 'Zürich');

      final london = await source.search('London', limit: 5);
      expect(london.first.country, 'United Kingdom');
    },
  );

  test('respects the limit and returns nothing for unknown names', () async {
    expect(await source.search('San', limit: 3), hasLength(3));
    expect(await source.search('qqqxyz', limit: 5), isEmpty);
  });

  test('every bundled time zone exists in the IANA database', () async {
    final raw = await rootBundle.loadString(PlacesLocalDataSource.defaultAsset);
    final zones = raw.split('\n').first.split('\t').skip(1);
    final resolver = TzTimeZoneResolver();
    final unknown = zones.where((z) => !resolver.isKnown(z)).toList();
    expect(unknown, isEmpty);
  });

  test('foldForSearch strips Polish and German diacritics', () {
    expect(PlacesLocalDataSource.foldForSearch(' Łódź '), 'lodz');
    expect(PlacesLocalDataSource.foldForSearch('Straße'), 'strasse');
  });
}
