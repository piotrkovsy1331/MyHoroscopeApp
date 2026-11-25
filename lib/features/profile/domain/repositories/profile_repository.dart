import '../entities/birth_data.dart';

/// Stores the astrological profile. Currently on-device only.
abstract interface class ProfileRepository {
  Future<BirthData?> load();
  Future<void> save(BirthData data);
  Future<void> clear();
}
