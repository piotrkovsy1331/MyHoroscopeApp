import '../../domain/entities/birth_data.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._local);

  final ProfileLocalDataSource _local;

  @override
  Future<BirthData?> load() => _local.read();

  @override
  Future<void> save(BirthData data) => _local.write(data);

  @override
  Future<void> clear() => _local.clear();
}
