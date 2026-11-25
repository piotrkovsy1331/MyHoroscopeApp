import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../error/exceptions.dart';

/// Thin JSON-over-HTTP wrapper that converts transport problems into
/// [AppException]s. Data sources depend on this, never on `http` directly.
class ApiClient {
  ApiClient({
    required http.Client httpClient,
    required String baseUrl,
    this.timeout = const Duration(seconds: 15),
  }) : _http = httpClient,
       _baseUri = Uri.parse(baseUrl);

  final http.Client _http;
  final Uri _baseUri;
  final Duration timeout;

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? query,
  }) async {
    final uri = _baseUri.replace(path: path, queryParameters: query);
    final http.Response response;
    try {
      response = await _http
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(timeout);
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on TimeoutException {
      throw const NetworkException('Request timed out');
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ServerException(response.statusCode);
    }

    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map<String, dynamic>) return decoded;
      throw const ParseException('Expected a JSON object');
    } on FormatException catch (e) {
      throw ParseException(e.message);
    }
  }
}
