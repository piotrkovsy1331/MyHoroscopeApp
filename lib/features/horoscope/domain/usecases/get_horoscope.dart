import '../../../../core/utils/result.dart';
import '../../../zodiac/domain/entities/zodiac_sign.dart';
import '../entities/horoscope.dart';
import '../entities/horoscope_period.dart';
import '../repositories/horoscope_repository.dart';

class GetHoroscope {
  const GetHoroscope(this._repository);

  final HoroscopeRepository _repository;

  Future<Result<Horoscope>> call(
    ZodiacSign sign,
    HoroscopePeriod period, {
    bool forceRefresh = false,
  }) => _repository.getHoroscope(sign, period, forceRefresh: forceRefresh);
}
