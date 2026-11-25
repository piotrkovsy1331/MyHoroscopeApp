import '../../domain/entities/favorite_horoscope.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl(this._local);

  final FavoritesLocalDataSource _local;

  @override
  Future<List<FavoriteHoroscope>> getAll() async {
    final all = [...await _local.readAll()]
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return all;
  }

  @override
  Future<void> save(FavoriteHoroscope favorite) async {
    final all = await _local.readAll();
    await _local.writeAll([favorite, ...all.where((f) => f.id != favorite.id)]);
  }

  @override
  Future<void> remove(String id) async {
    final all = await _local.readAll();
    await _local.writeAll(all.where((f) => f.id != id).toList());
  }
}
