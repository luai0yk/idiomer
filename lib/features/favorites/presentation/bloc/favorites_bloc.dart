import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/features/idioms/domain/usecases/clear_all_favorites_usecase.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_bloc.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_event.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_state.dart';

final class FavoritesClearedRequested extends IdiomsEvent {
  const FavoritesClearedRequested();
}

class FavoritesBloc extends IdiomsBloc {
  final ClearAllFavoritesUseCase _clearAllFavorites;

  FavoritesBloc({
    required super.watchIdioms,
    required super.watchCategories,
    required super.toggleFavorite,
    required ClearAllFavoritesUseCase clearAllFavorites,
  }) : _clearAllFavorites = clearAllFavorites,
       super(favoritesOnly: true) {
    on<FavoritesClearedRequested>(_onClearAllFavorites);
  }

  Future<void> _onClearAllFavorites(
    FavoritesClearedRequested event,
    Emitter<IdiomsState> emit,
  ) async {
    try {
      await _clearAllFavorites();
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    }
  }
}
