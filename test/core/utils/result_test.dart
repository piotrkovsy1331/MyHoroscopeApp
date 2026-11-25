import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/core/error/failures.dart';
import 'package:mystic_horoscope/core/utils/result.dart';

void main() {
  test('fold calls onOk for Success', () {
    const Result<int> result = Success(42);
    expect(result.fold((_) => -1, (v) => v), 42);
  });

  test('fold calls onError for Error', () {
    const Result<int> result = Error(NetworkFailure());
    expect(result.fold((f) => f, (_) => null), const NetworkFailure());
  });
}
