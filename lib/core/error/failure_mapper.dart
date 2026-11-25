import 'exceptions.dart';
import 'failures.dart';

/// Translates data-layer exceptions into domain failures.
Failure mapExceptionToFailure(Object error) => switch (error) {
  NetworkException() => const NetworkFailure(),
  ServerException(:final statusCode) => ServerFailure(statusCode: statusCode),
  ParseException() => const DataFormatFailure(),
  CacheException() => const CacheFailure(),
  _ => const UnexpectedFailure(),
};
