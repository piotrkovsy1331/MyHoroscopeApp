import '../entities/birth_place.dart';

abstract interface class PlacesRepository {
  /// Places whose name starts with [query], most populous first.
  Future<List<BirthPlace>> search(String query, {int limit = 15});
}
