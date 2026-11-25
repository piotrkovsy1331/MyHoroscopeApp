import '../../../../core/error/exceptions.dart';
import '../../../zodiac/domain/entities/zodiac_sign.dart';
import '../../domain/entities/horoscope.dart';
import '../../domain/entities/horoscope_period.dart';

/// JSON mapping for both the FreeHoroscopeAPI payload and the local cache.
///
/// Provider payload (verified 2026-11-25):
/// `{"data":{"date":"2026-11-25","period":"daily","sign":"Aries","horoscope":"..."}}`
/// where `date` is `YYYY-MM-DD` for daily/weekly (week start) and
/// `YYYY-MM` for monthly.
abstract final class HoroscopeModel {
  static Horoscope fromApiJson(
    Map<String, dynamic> json, {
    required HoroscopePeriod period,
    required DateTime fetchedAt,
  }) {
    final data = json['data'];
    if (data is! Map<String, dynamic>) {
      throw const ParseException('Missing "data" object');
    }
    final sign = ZodiacSign.tryParse(data['sign'] as String?);
    final text = (data['horoscope'] as String?)?.trim();
    final start = _parsePeriodStart(data['date']);
    if (sign == null || text == null || text.isEmpty || start == null) {
      throw const ParseException('Incomplete horoscope payload');
    }
    return Horoscope(
      sign: sign,
      period: period,
      periodStart: start,
      text: text,
      fetchedAt: fetchedAt,
    );
  }

  static Map<String, dynamic> toCacheJson(Horoscope h) => {
    'sign': h.sign.id,
    'period': h.period.name,
    'periodStart': h.periodStart.toIso8601String(),
    'text': h.text,
    'fetchedAt': h.fetchedAt.toIso8601String(),
  };

  static Horoscope fromCacheJson(Map<String, dynamic> json) {
    try {
      return Horoscope(
        sign: ZodiacSign.tryParse(json['sign'] as String)!,
        period: HoroscopePeriod.values.byName(json['period'] as String),
        periodStart: DateTime.parse(json['periodStart'] as String),
        text: json['text'] as String,
        fetchedAt: DateTime.parse(json['fetchedAt'] as String),
      );
    } on Object {
      throw const CacheException('Corrupted cache entry');
    }
  }

  static DateTime? _parsePeriodStart(Object? raw) {
    if (raw is! String) return null;
    final parts = raw.split('-').map(int.tryParse).toList();
    if (parts.length < 2 || parts.contains(null)) return null;
    return DateTime(parts[0]!, parts[1]!, parts.length > 2 ? parts[2]! : 1);
  }
}
