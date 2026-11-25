import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mystic_horoscope/core/error/exceptions.dart';
import 'package:mystic_horoscope/core/network/api_client.dart';

ApiClient _client(MockClientHandler handler, {Duration? timeout}) => ApiClient(
  httpClient: MockClient(handler),
  baseUrl: 'https://example.test',
  timeout: timeout ?? const Duration(seconds: 1),
);

void main() {
  test('builds the URL from path and query and decodes JSON', () async {
    late Uri requested;
    final client = _client((request) async {
      requested = request.url;
      return http.Response('{"data":{"sign":"Leo"}}', 200);
    });

    final json = await client.getJson('/api/v1/x', query: {'sign': 'leo'});

    expect(requested.toString(), 'https://example.test/api/v1/x?sign=leo');
    expect(json['data'], {'sign': 'Leo'});
  });

  test('throws ServerException on non-2xx status', () {
    final client = _client((_) async => http.Response('{}', 404));
    expect(
      client.getJson('/x'),
      throwsA(isA<ServerException>().having((e) => e.statusCode, 'code', 404)),
    );
  });

  test('throws ParseException on invalid JSON', () {
    final client = _client((_) async => http.Response('<html>', 200));
    expect(client.getJson('/x'), throwsA(isA<ParseException>()));
  });

  test('throws ParseException when body is not a JSON object', () {
    final client = _client((_) async => http.Response('[1,2]', 200));
    expect(client.getJson('/x'), throwsA(isA<ParseException>()));
  });

  test('throws NetworkException when offline', () {
    final client = _client((_) => throw const SocketException('offline'));
    expect(client.getJson('/x'), throwsA(isA<NetworkException>()));
  });

  test('throws NetworkException on timeout', () {
    final client = _client(
      (_) => Completer<http.Response>().future,
      timeout: const Duration(milliseconds: 10),
    );
    expect(client.getJson('/x'), throwsA(isA<NetworkException>()));
  });
}
