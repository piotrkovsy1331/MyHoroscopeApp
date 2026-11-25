part of 'horoscope_bloc.dart';

enum HoroscopeStatus { loading, success, failure }

final class HoroscopeState extends Equatable {
  const HoroscopeState({
    required this.period,
    this.status = HoroscopeStatus.loading,
    this.horoscope,
    this.failure,
  });

  final HoroscopePeriod period;
  final HoroscopeStatus status;
  final Horoscope? horoscope;
  final Failure? failure;

  @override
  List<Object?> get props => [period, status, horoscope, failure];
}
