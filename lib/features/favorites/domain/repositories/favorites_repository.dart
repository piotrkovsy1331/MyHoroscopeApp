import '../entities/favorite_horoscope.dart';

/// Saved horoscopes. Currently stored on the device only; a synced
/// implementation can replace it without touching the UI.
abstract interface class FavoritesRepository {
  /// Newest first.
  Future<List<FavoriteHoroscope>> getAll();
  Future<void> save(FavoriteHoroscope favorite);
  Future<void> remove(String id);
}
