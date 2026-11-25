import '../../../../core/network/api_client.dart';
import '../../../../core/utils/clock.dart';
import '../../../zodiac/domain/entities/zodiac_sign.dart';
import '../../domain/entities/horoscope.dart';
import '../../domain/entities/horoscope_period.dart';
import '../models/horoscope_model.dart';
import 'horoscope_remote_data_source.dart';

/// FreeHoroscopeAPI (https://freehoroscopeapi.com): key-less, English only.
/// Endpoints verified: `GET /api/v1/get-horoscope/{daily|weekly|monthly}?sign=`.
class FreeHoroscopeApiDataSource implements HoroscopeRemoteDataSource {
  FreeHoroscopeApiDataSource(this._client, {this._clock = systemClock});

  final ApiClient _client;
  final Clock _clock;

  @override
  Future<Horoscope> fetch(ZodiacSign sign, HoroscopePeriod period) async {
    final json = await _client.getJson(
      '/api/v1/get-horoscope/${period.name}',
      query: {'sign': sign.id},
    );
    return HoroscopeModel.fromApiJson(
      json,
      period: period,
      fetchedAt: _clock(),
    );
  }
}
