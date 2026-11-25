import 'package:equatable/equatable.dart';

import '../../../zodiac/domain/entities/zodiac_sign.dart';
import 'horoscope_period.dart';

/// A horoscope reading as delivered by the data provider.
class Horoscope extends Equatable {
  const Horoscope({
    required this.sign,
    required this.period,
    required this.periodStart,
    required this.text,
    required this.fetchedAt,
    this.isStale = false,
  });

  final ZodiacSign sign;
  final HoroscopePeriod period;

  /// First day the reading applies to (the day, week start or month).
  final DateTime periodStart;
  final String text;

  /// When the text was downloaded from the provider.
  final DateTime fetchedAt;

  /// True when the provider could not be reached and an older cached
  /// reading is shown instead.
  final bool isStale;

  Horoscope copyWith({bool? isStale}) => Horoscope(
    sign: sign,
    period: period,
    periodStart: periodStart,
    text: text,
    fetchedAt: fetchedAt,
    isStale: isStale ?? this.isStale,
  );

  @override
  List<Object?> get props => [
    sign,
    period,
    periodStart,
    text,
    fetchedAt,
    isStale,
  ];
}
