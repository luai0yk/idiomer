import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/flashcards/domain/usecases/watch_flashcard_groups_usecase.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/domain/usecases/toggle_favorite_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_categories_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_idiom_of_the_day_usecase.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_stats_entity.dart';
import 'package:idiomer/features/quiz/domain/usecases/watch_quiz_stats_usecase.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final WatchIdiomOfTheDayUseCase _watchIdiomOfTheDay;
  final WatchQuizStatsUseCase _watchQuizStats;
  final WatchFlashcardGroupsUseCase _watchFlashcardGroups;
  final WatchCategoriesUseCase _watchCategories;
  final ToggleFavoriteUseCase _toggleFavorite;

  StreamSubscription<IdiomDetailEntity?>? _idiomSub;
  StreamSubscription<QuizStatsEntity>? _quizStatsSub;
  StreamSubscription<List<FlashcardGroupEntity>>? _groupsSub;
  StreamSubscription<List<CategoryEntity>>? _categoriesSub;

  HomeCubit({
    required WatchIdiomOfTheDayUseCase watchIdiomOfTheDay,
    required WatchQuizStatsUseCase watchQuizStats,
    required WatchFlashcardGroupsUseCase watchFlashcardGroups,
    required WatchCategoriesUseCase watchCategories,
    required ToggleFavoriteUseCase toggleFavorite,
  }) : _watchIdiomOfTheDay = watchIdiomOfTheDay,
       _watchQuizStats = watchQuizStats,
       _watchFlashcardGroups = watchFlashcardGroups,
       _watchCategories = watchCategories,
       _toggleFavorite = toggleFavorite,
       super(const HomeState());

  Future<void> watchHome() async {
    await _idiomSub?.cancel();
    await _quizStatsSub?.cancel();
    await _groupsSub?.cancel();
    await _categoriesSub?.cancel();
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

    _groupsSub = _watchFlashcardGroups().listen(
      (groups) {
        if (!isClosed) {
          emit(state.copyWith(flashcardGroups: groups));
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

    _categoriesSub = _watchCategories().listen(
      (categories) {
        if (!isClosed) {
          emit(state.copyWith(categories: categories));
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
    await _groupsSub?.cancel();
    await _categoriesSub?.cancel();
    return super.close();
  }
}
