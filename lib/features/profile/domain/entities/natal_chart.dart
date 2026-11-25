import 'package:equatable/equatable.dart';

import '../../../zodiac/domain/entities/zodiac_sign.dart';

/// Result for one point of the chart (Sun, Moon or Ascendant).
sealed class Placement extends Equatable {
  const Placement();

  @override
  List<Object?> get props => [];
}

/// Determined unambiguously from the data provided.
final class KnownPlacement extends Placement {
  const KnownPlacement(this.sign);

  final ZodiacSign sign;

  @override
  List<Object?> get props => [sign];
}

/// Missing time/place leaves several possible signs (in zodiac order of
/// occurrence). Never presented as a single answer.
final class AmbiguousPlacement extends Placement {
  const AmbiguousPlacement(this.candidates);

  final List<ZodiacSign> candidates;

  @override
  List<Object?> get props => [candidates];
}

enum UnavailableReason { needsTimeAndPlace, polarLatitude }

/// Cannot be calculated from the data provided.
final class UnavailablePlacement extends Placement {
  const UnavailablePlacement(this.reason);

  final UnavailableReason reason;

  @override
  List<Object?> get props => [reason];
}

class NatalChart extends Equatable {
  const NatalChart({
    required this.sun,
    required this.moon,
    required this.ascendant,
  });

  final Placement sun;
  final Placement moon;
  final Placement ascendant;

  @override
  List<Object?> get props => [sun, moon, ascendant];
}
