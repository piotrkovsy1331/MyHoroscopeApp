import '../error/failures.dart';

/// Outcome of a repository/use-case call: either [Success] or [Error].
///
/// A minimal sealed type instead of an extra FP dependency; use Dart's
/// pattern matching (`switch`) to handle both cases exhaustively.
sealed class Result<T> {
  const Result();

  R fold<R>(R Function(Failure failure) onError, R Function(T value) onOk) =>
      switch (this) {
        Success<T>(:final value) => onOk(value),
        Error<T>(:final failure) => onError(failure),
      };
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;
}
