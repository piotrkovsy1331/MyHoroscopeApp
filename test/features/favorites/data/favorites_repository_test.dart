import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:mystic_horoscope/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:mystic_horoscope/features/horoscope/domain/entities/horoscope_period.dart';
import 'package:mystic_horoscope/features/zodiac/domain/entities/zodiac_sign.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../../../helpers/sample_data.dart';

void main() {
  late SharedPreferencesAsync prefs;
  late FavoritesRepositoryImpl repo;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    prefs = SharedPreferencesAsync();
    repo = FavoritesRepositoryImpl(FavoritesLocalDataSource(prefs));
  });

  test('saves, lists newest first and removes', () async {
    final older = sampleFavorite(savedAt: DateTime(2026, 11, 1));
    final newer = sampleFavorite(
      sign: ZodiacSign.pisces,
      period: HoroscopePeriod.monthly,
      savedAt: DateTime(2026, 11, 20),
    );
    await repo.save(older);
    await repo.save(newer);

    expect(await repo.getAll(), [newer, older]);

    await repo.remove(older.id);
    expect(await repo.getAll(), [newer]);
  });

  test('saving the same reading twice keeps a single entry', () async {
    await repo.save(sampleFavorite(savedAt: DateTime(2026, 11, 1)));
    await repo.save(sampleFavorite(savedAt: DateTime(2026, 11, 2)));
    final all = await repo.getAll();
    expect(all, hasLength(1));
    expect(all.single.savedAt, DateTime(2026, 11, 2));
  });

  test('a damaged entry does not wipe the others', () async {
    await repo.save(sampleFavorite());
    final raw = (await prefs.getString('favorites.v1'))!;
    await prefs.setString(
      'favorites.v1',
      raw.replaceFirst('[', '[{"horoscope":{},"savedAt":"x"},'),
    );
    expect(await repo.getAll(), hasLength(1));
  });

  test('id is stable per sign, period and period start', () {
    expect(sampleFavorite().id, 'leo-daily-20261125');
  });
}
