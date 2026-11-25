import 'package:equatable/equatable.dart';

import '../../../horoscope/domain/entities/horoscope.dart';

/// A horoscope the user saved, kept as a snapshot of the provider's text
/// so it stays readable after the period ends and while offline.
class FavoriteHoroscope extends Equatable {
  const FavoriteHoroscope({required this.horoscope, required this.savedAt});

  final Horoscope horoscope;
  final DateTime savedAt;

  /// Stable id: one favorite per sign, period and period start.
  String get id => idFor(horoscope);

  static String idFor(Horoscope h) {
    final d = h.periodStart;
    final date =
        '${d.year}${d.month.toString().padLeft(2, '0')}'
        '${d.day.toString().padLeft(2, '0')}';
    return '${h.sign.id}-${h.period.name}-$date';
  }

  @override
  List<Object?> get props => [horoscope, savedAt];
}
