import '../../../zodiac/domain/entities/zodiac_sign.dart';
import '../../domain/entities/horoscope.dart';
import '../../domain/entities/horoscope_period.dart';

/// Contract every horoscope provider implements.
abstract interface class HoroscopeRemoteDataSource {
  /// Throws an `AppException` on failure.
  Future<Horoscope> fetch(ZodiacSign sign, HoroscopePeriod period);
}
