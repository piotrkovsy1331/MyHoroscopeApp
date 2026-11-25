import 'package:equatable/equatable.dart';

import 'birth_place.dart';

/// Wall-clock time of birth.
typedef BirthTime = ({int hour, int minute});

/// What the user told us about their birth. Only the date is required.
class BirthData extends Equatable {
  BirthData({required DateTime date, this.time, this.place})
    : date = DateTime(date.year, date.month, date.day);

  /// Calendar date of birth (time part is always midnight).
  final DateTime date;
  final BirthTime? time;
  final BirthPlace? place;

  @override
  List<Object?> get props => [date, time, place];
}
