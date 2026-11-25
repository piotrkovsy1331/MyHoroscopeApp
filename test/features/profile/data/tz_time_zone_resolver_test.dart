import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/features/profile/data/services/tz_time_zone_resolver.dart';

void main() {
  final resolver = TzTimeZoneResolver();

  test('applies historical summer time (Warsaw, July 1990: UTC+2)', () {
    expect(
      resolver.toUtc('Europe/Warsaw', DateTime(1990, 7, 15, 16, 30)),
      DateTime.utc(1990, 7, 15, 14, 30),
    );
  });

  test('applies standard time (Warsaw, January 1990: UTC+1)', () {
    expect(
      resolver.toUtc('Europe/Warsaw', DateTime(1990, 1, 15, 12)),
      DateTime.utc(1990, 1, 15, 11),
    );
  });

  test('handles negative offsets (New York, July 1985: UTC-4)', () {
    expect(
      resolver.toUtc('America/New_York', DateTime(1985, 7, 4, 20)),
      DateTime.utc(1985, 7, 5, 0),
    );
  });

  test('rejects unknown zones', () {
    expect(
      () => resolver.toUtc('Mars/Olympus_Mons', DateTime(2000)),
      throwsArgumentError,
    );
  });
}
