import '../entities/birth_place.dart';
import '../repositories/places_repository.dart';

class SearchPlaces {
  const SearchPlaces(this._repository);

  final PlacesRepository _repository;

  Future<List<BirthPlace>> call(String query) {
    final trimmed = query.trim();
    if (trimmed.length < 2) return Future.value(const []);
    return _repository.search(trimmed);
  }
}
