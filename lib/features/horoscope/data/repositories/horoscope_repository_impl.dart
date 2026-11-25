import '../../../../core/error/failure_mapper.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/result.dart';
import '../../../zodiac/domain/entities/zodiac_sign.dart';
import '../../domain/entities/horoscope.dart';
import '../../domain/entities/horoscope_period.dart';
import '../../domain/repositories/horoscope_repository.dart';
import '../datasources/horoscope_local_data_source.dart';
import '../datasources/horoscope_remote_data_source.dart';

/// Cache policy:
/// 1. A cached reading fetched in the current day/week/month is returned
///    without a network call (unless [forceRefresh]).
/// 2. Otherwise the provider is asked and the result cached.
/// 3. If the provider fails, the last cached reading is returned marked
///    `isStale`; with no cache the failure is returned.
class HoroscopeRepositoryImpl implements HoroscopeRepository {
  HoroscopeRepositoryImpl({
    required this._remote,
    required this._local,
    this._clock = systemClock,
  });

  final HoroscopeRemoteDataSource _remote;
  final HoroscopeLocalDataSource _local;
  final Clock _clock;

  @override
  Future<Result<Horoscope>> getHoroscope(
    ZodiacSign sign,
    HoroscopePeriod period, {
    bool forceRefresh = false,
  }) async {
    final cached = await _local.read(sign, period);
    if (!forceRefresh && cached != null && _isCurrent(cached)) {
      return Success(cached);
    }

    try {
      final fresh = await _remote.fetch(sign, period);
      await _local.write(fresh);
      return Success(fresh);
    } catch (e) {
      // Includes unexpected errors (e.g. a malformed payload type).
      if (cached != null) return Success(cached.copyWith(isStale: true));
      return Error(mapExceptionToFailure(e));
    }
  }

  bool _isCurrent(Horoscope h) {
    final now = _clock();
    final f = h.fetchedAt;
    return switch (h.period) {
      HoroscopePeriod.daily =>
        f.year == now.year && f.month == now.month && f.day == now.day,
      HoroscopePeriod.weekly => _weekStart(f) == _weekStart(now),
      HoroscopePeriod.monthly => f.year == now.year && f.month == now.month,
    };
  }

  /// Monday of the week containing [d] (date only).
  static DateTime _weekStart(DateTime d) =>
      DateTime(d.year, d.month, d.day - (d.weekday - DateTime.monday));
}
