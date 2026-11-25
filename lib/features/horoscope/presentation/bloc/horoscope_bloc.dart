import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../../zodiac/domain/entities/zodiac_sign.dart';
import '../../domain/entities/horoscope.dart';
import '../../domain/entities/horoscope_period.dart';
import '../../domain/usecases/get_horoscope.dart';

part 'horoscope_event.dart';
part 'horoscope_state.dart';

/// BLoC (not Cubit) because period switches and refreshes can overlap:
/// `restartable()` cancels an in-flight load when a newer event arrives,
/// so a slow response for an old period never overwrites the new one.
class HoroscopeBloc extends Bloc<HoroscopeEvent, HoroscopeState> {
  HoroscopeBloc({
    required this.sign,
    required this._getHoroscope,
    HoroscopePeriod initialPeriod = HoroscopePeriod.daily,
  }) : super(HoroscopeState(period: initialPeriod)) {
    on<HoroscopeEvent>(_onEvent, transformer: restartable());
  }

  final ZodiacSign sign;
  final GetHoroscope _getHoroscope;

  Future<void> _onEvent(
    HoroscopeEvent event,
    Emitter<HoroscopeState> emit,
  ) async {
    final (period, force) = switch (event) {
      HoroscopePeriodSelected(:final period) => (period, false),
      HoroscopeRefreshRequested() => (state.period, true),
    };

    // Keep the current text on screen during a refresh of the same period.
    final keep = force && state.horoscope?.period == period;
    emit(
      HoroscopeState(period: period, horoscope: keep ? state.horoscope : null),
    );

    final result = await _getHoroscope(sign, period, forceRefresh: force);
    emit(switch (result) {
      Success(:final value) => HoroscopeState(
        period: period,
        status: HoroscopeStatus.success,
        horoscope: value,
      ),
      Error(:final failure) => HoroscopeState(
        period: period,
        status: HoroscopeStatus.failure,
        failure: failure,
      ),
    });
  }
}
