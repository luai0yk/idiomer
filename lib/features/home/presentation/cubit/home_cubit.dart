import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/domain/usecases/toggle_favorite_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_idiom_of_the_day_usecase.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_stats_entity.dart';
import 'package:idiomer/features/quiz/domain/usecases/watch_quiz_stats_usecase.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final WatchIdiomOfTheDayUseCase _watchIdiomOfTheDay;
  final WatchQuizStatsUseCase _watchQuizStats;
  final ToggleFavoriteUseCase _toggleFavorite;

  StreamSubscription<IdiomDetailEntity?>? _idiomSub;
  StreamSubscription<QuizStatsEntity>? _quizStatsSub;

  HomeCubit({
    required WatchIdiomOfTheDayUseCase watchIdiomOfTheDay,
    required WatchQuizStatsUseCase watchQuizStats,
    required ToggleFavoriteUseCase toggleFavorite,
  }) : _watchIdiomOfTheDay = watchIdiomOfTheDay,
       _watchQuizStats = watchQuizStats,
       _toggleFavorite = toggleFavorite,
       super(const HomeState());

  Future<void> watchHome() async {
    await _idiomSub?.cancel();
    await _quizStatsSub?.cancel();
    if (isClosed) return;

    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));

    _idiomSub = _watchIdiomOfTheDay().listen(
      (idiom) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: HomeStatus.loaded,
              idiomOfTheDay: idiom,
              errorMessage: null,
            ),
          );
        }
      },
      onError: (Object error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: HomeStatus.error,
              errorMessage: error.toString(),
            ),
          );
        }
      },
    );

    _quizStatsSub = _watchQuizStats().listen(
      (stats) {
        if (!isClosed) {
          emit(state.copyWith(quizStats: stats));
        }
      },
      onError: (Object error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: HomeStatus.error,
              errorMessage: error.toString(),
            ),
          );
        }
      },
    );
  }

  Future<void> toggleIdiomOfTheDayFavorite() async {
    final idiom = state.idiomOfTheDay;
    if (idiom == null) return;
    await _toggleFavorite(idiom.id);
  }

  @override
  Future<void> close() async {
    await _idiomSub?.cancel();
    await _quizStatsSub?.cancel();
    return super.close();
  }
}
