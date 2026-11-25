import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/core/error/exceptions.dart';
import 'package:mystic_horoscope/core/error/failure_mapper.dart';
import 'package:mystic_horoscope/core/error/failures.dart';

void main() {
  test('maps every AppException to its Failure', () {
    expect(
      mapExceptionToFailure(const NetworkException()),
      const NetworkFailure(),
    );
    expect(
      mapExceptionToFailure(const ServerException(503)),
      const ServerFailure(statusCode: 503),
    );
    expect(
      mapExceptionToFailure(const ParseException()),
      const DataFormatFailure(),
    );
    expect(mapExceptionToFailure(const CacheException()), const CacheFailure());
  });

  test('maps unknown errors to UnexpectedFailure', () {
    expect(mapExceptionToFailure(StateError('x')), const UnexpectedFailure());
  });
}
