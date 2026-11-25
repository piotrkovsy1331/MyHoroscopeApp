import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:mystic_horoscope/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:mystic_horoscope/features/favorites/domain/entities/favorite_horoscope.dart';
import 'package:mystic_horoscope/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../../../helpers/sample_data.dart';

void main() {
  final now = DateTime(2026, 11, 25, 12);
  late FavoritesRepositoryImpl repo;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    repo = FavoritesRepositoryImpl(
      FavoritesLocalDataSource(SharedPreferencesAsync()),
    );
  });

  FavoritesCubit build() => FavoritesCubit(repository: repo, clock: () => now);

  blocTest<FavoritesCubit, FavoritesState>(
    'toggle saves a snapshot and toggling again removes it',
    build: build,
    act: (cubit) async {
      await cubit.load();
      await cubit.toggle(sampleHoroscope());
      expect(cubit.state.contains(sampleHoroscope()), isTrue);
      await cubit.toggle(sampleHoroscope());
    },
    verify: (cubit) async {
      expect(cubit.state.items, isEmpty);
      expect(await repo.getAll(), isEmpty);
    },
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'a favorite saved from an offline copy is not marked stale',
    build: build,
    act: (cubit) => cubit.toggle(sampleHoroscope(isStale: true)),
    verify: (cubit) {
      final saved = cubit.state.items.single;
      expect(saved.horoscope.isStale, isFalse);
      expect(saved.savedAt, now);
    },
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'undo restores the original savedAt',
    build: build,
    act: (cubit) async {
      final original = FavoriteHoroscope(
        horoscope: sampleHoroscope(),
        savedAt: DateTime(2026, 1, 1),
      );
      await cubit.restore(original);
      await cubit.remove(original.id);
      await cubit.restore(original);
    },
    verify: (cubit) =>
        expect(cubit.state.items.single.savedAt, DateTime(2026, 1, 1)),
  );
}
