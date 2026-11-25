import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:mystic_horoscope/features/profile/domain/entities/birth_data.dart';
import 'package:mystic_horoscope/features/profile/domain/entities/birth_place.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late ProfileLocalDataSource source;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    source = ProfileLocalDataSource(SharedPreferencesAsync());
  });

  test('round-trips full birth data', () async {
    final data = BirthData(
      date: DateTime(1990, 7, 15),
      time: (hour: 16, minute: 30),
      place: const BirthPlace(
        name: 'Kraków',
        region: 'Lesser Poland',
        country: 'Poland',
        latitude: 50.0614,
        longitude: 19.9366,
        timeZoneId: 'Europe/Warsaw',
      ),
    );
    await source.write(data);
    expect(await source.read(), data);
  });

  test('round-trips date-only data and clears', () async {
    final data = BirthData(date: DateTime(2001, 2, 3));
    await source.write(data);
    expect(await source.read(), data);
    await source.clear();
    expect(await source.read(), isNull);
  });
}
