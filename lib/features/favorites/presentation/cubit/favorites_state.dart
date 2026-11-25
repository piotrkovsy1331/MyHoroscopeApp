part of 'favorites_cubit.dart';

final class FavoritesState extends Equatable {
  const FavoritesState({this.items = const [], this.loaded = false});

  /// Newest first.
  final List<FavoriteHoroscope> items;
  final bool loaded;

  bool contains(Horoscope h) {
    final id = FavoriteHoroscope.idFor(h);
    return items.any((f) => f.id == id);
  }

  FavoriteHoroscope? byId(String id) {
    for (final f in items) {
      if (f.id == id) return f;
    }
    return null;
  }

  @override
  List<Object?> get props => [items, loaded];
}
