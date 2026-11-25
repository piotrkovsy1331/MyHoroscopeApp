import '../../../../core/utils/result.dart';
import '../../../zodiac/domain/entities/zodiac_sign.dart';
import '../entities/horoscope.dart';
import '../entities/horoscope_period.dart';

/// Provider-agnostic access to horoscopes. Swapping the data provider means
/// writing a new remote data source; nothing above this interface changes.
abstract interface class HoroscopeRepository {
  Future<Result<Horoscope>> getHoroscope(
    ZodiacSign sign,
    HoroscopePeriod period, {
    bool forceRefresh = false,
  });
}
