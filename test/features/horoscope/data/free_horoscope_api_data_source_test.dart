import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mystic_horoscope/core/error/exceptions.dart';
import 'package:mystic_horoscope/core/network/api_client.dart';
import 'package:mystic_horoscope/features/horoscope/data/datasources/free_horoscope_api_data_source.dart';
import 'package:mystic_horoscope/features/horoscope/domain/entities/horoscope_period.dart';
import 'package:mystic_horoscope/features/zodiac/domain/entities/zodiac_sign.dart';

import '../../../helpers/fixtures.dart';

void main() {
  test('requests the documented endpoint and maps the payload', () async {
    late Uri requested;
    final source = FreeHoroscopeApiDataSource(
      ApiClient(
        httpClient: MockClient((request) async {
          requested = request.url;
          return http.Response(
            fixtureString('free_horoscope_api_weekly_leo.json'),
            200,
          );
        }),
        baseUrl: 'https://freehoroscopeapi.com',
      ),
      clock: () => DateTime(2026, 11, 25),
    );

    final h = await source.fetch(ZodiacSign.leo, HoroscopePeriod.weekly);

    expect(
      requested.toString(),
      'https://freehoroscopeapi.com/api/v1/get-horoscope/weekly?sign=leo',
    );
    expect(h.period, HoroscopePeriod.weekly);
    expect(h.fetchedAt, DateTime(2026, 11, 25));
  });

  test('propagates provider errors as ServerException', () {
    final source = FreeHoroscopeApiDataSource(
      ApiClient(
        httpClient: MockClient(
          (_) async => http.Response('{"error":"Invalid sign"}', 400),
        ),
        baseUrl: 'https://freehoroscopeapi.com',
      ),
    );
    expect(
      source.fetch(ZodiacSign.leo, HoroscopePeriod.daily),
      throwsA(isA<ServerException>()),
    );
  });
}
