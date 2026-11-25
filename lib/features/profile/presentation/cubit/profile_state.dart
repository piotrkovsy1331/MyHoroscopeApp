part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileEmpty extends ProfileState {
  const ProfileEmpty();
}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required this.birthData, required this.chart});

  final BirthData birthData;
  final NatalChart chart;

  /// The Sun sign when it is certain; used to personalise Today.
  ZodiacSign? get sunSign => switch (chart.sun) {
    KnownPlacement(:final sign) => sign,
    _ => null,
  };

  @override
  List<Object?> get props => [birthData, chart];
}
