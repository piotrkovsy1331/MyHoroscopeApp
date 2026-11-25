import '../../domain/entities/birth_place.dart';
import '../../domain/repositories/places_repository.dart';
import '../datasources/places_local_data_source.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  const PlacesRepositoryImpl(this._local);

  final PlacesLocalDataSource _local;

  @override
  Future<List<BirthPlace>> search(String query, {int limit = 15}) =>
      _local.search(query, limit: limit);
}
