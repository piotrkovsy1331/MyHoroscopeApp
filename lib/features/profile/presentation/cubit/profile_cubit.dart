import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../zodiac/domain/entities/zodiac_sign.dart';
import '../../domain/entities/birth_data.dart';
import '../../domain/entities/natal_chart.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/services/natal_calculator.dart';

part 'profile_state.dart';

/// Cubit: profile actions are simple, sequential commands (load, save,
/// clear) with no overlapping event streams.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this._repository, required this._calculator})
    : super(const ProfileLoading());

  final ProfileRepository _repository;
  final NatalCalculator _calculator;

  Future<void> load() async {
    final data = await _repository.load();
    emit(data == null ? const ProfileEmpty() : _loaded(data));
  }

  Future<void> save(BirthData data) async {
    await _repository.save(data);
    emit(_loaded(data));
  }

  Future<void> clear() async {
    await _repository.clear();
    emit(const ProfileEmpty());
  }

  ProfileLoaded _loaded(BirthData data) =>
      ProfileLoaded(birthData: data, chart: _calculator.calculate(data));
}
