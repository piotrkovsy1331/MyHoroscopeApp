/// Exceptions thrown by the data layer. Repositories catch them and map
/// them to [Failure]s so that domain and presentation never see them.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The device could not reach the server (offline, DNS, timeout).
final class NetworkException extends AppException {
  const NetworkException([super.message = 'No network connection']);
}

/// The server responded with a non-success status code.
final class ServerException extends AppException {
  const ServerException(this.statusCode, [super.message = 'Server error']);

  final int statusCode;
}

/// The response body did not match the expected format.
final class ParseException extends AppException {
  const ParseException([super.message = 'Unexpected response format']);
}

/// Requested data is not available in the local cache.
final class CacheException extends AppException {
  const CacheException([super.message = 'No cached data']);
}
