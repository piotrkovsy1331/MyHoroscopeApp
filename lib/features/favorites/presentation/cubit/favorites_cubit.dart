import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/clock.dart';
import '../../../horoscope/domain/entities/horoscope.dart';
import '../../domain/entities/favorite_horoscope.dart';
import '../../domain/repositories/favorites_repository.dart';

part 'favorites_state.dart';

/// Cubit: simple commands; the UI updates optimistically and the list is
/// re-read from storage after each write so state always matches disk.
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({required this._repository, this._clock = systemClock})
    : super(const FavoritesState());

  final FavoritesRepository _repository;
  final Clock _clock;

  Future<void> load() async {
    emit(FavoritesState(items: await _repository.getAll(), loaded: true));
  }

  Future<void> toggle(Horoscope horoscope) => state.contains(horoscope)
      ? remove(FavoriteHoroscope.idFor(horoscope))
      : restore(
          FavoriteHoroscope(
            // A favorite is a snapshot, never flagged as an offline copy.
            horoscope: horoscope.copyWith(isStale: false),
            savedAt: _clock(),
          ),
        );

  Future<void> remove(String id) async {
    emit(
      FavoritesState(
        items: state.items.where((f) => f.id != id).toList(),
        loaded: true,
      ),
    );
    await _repository.remove(id);
    await load();
  }

  /// Adds [favorite] as-is (also used by "Undo" to keep its savedAt).
  Future<void> restore(FavoriteHoroscope favorite) async {
    emit(
      FavoritesState(
        items: [favorite, ...state.items.where((f) => f.id != favorite.id)]
          ..sort((a, b) => b.savedAt.compareTo(a.savedAt)),
        loaded: true,
      ),
    );
    await _repository.save(favorite);
    await load();
  }
}
