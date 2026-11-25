part of 'horoscope_bloc.dart';

sealed class HoroscopeEvent extends Equatable {
  const HoroscopeEvent();

  @override
  List<Object?> get props => [];
}

/// Load (from cache or network) the reading for [period].
final class HoroscopePeriodSelected extends HoroscopeEvent {
  const HoroscopePeriodSelected(this.period);

  final HoroscopePeriod period;

  @override
  List<Object?> get props => [period];
}

/// Pull-to-refresh / retry: always ask the provider.
final class HoroscopeRefreshRequested extends HoroscopeEvent {
  const HoroscopeRefreshRequested();
}
