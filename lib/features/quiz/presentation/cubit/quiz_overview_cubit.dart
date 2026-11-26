import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_stats_entity.dart';
import 'package:idiomer/features/quiz/domain/usecases/watch_quiz_stats_usecase.dart';

import 'quiz_overview_state.dart';

class QuizOverviewCubit extends Cubit<QuizOverviewState> {
  final WatchQuizStatsUseCase _watchQuizStats;
  StreamSubscription<QuizStatsEntity>? _subscription;

  QuizOverviewCubit({required WatchQuizStatsUseCase watchQuizStats})
    : _watchQuizStats = watchQuizStats,
      super(const QuizOverviewState());

  Future<void> watchStats() async {
    await _subscription?.cancel();
    if (isClosed) return;

    emit(
      state.copyWith(status: QuizOverviewStatus.loading, errorMessage: null),
    );

    _subscription = _watchQuizStats().listen(
      (stats) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: QuizOverviewStatus.loaded,
              stats: stats,
              errorMessage: null,
            ),
          );
        }
      },
      onError: (Object error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: QuizOverviewStatus.error,
              errorMessage: error.toString(),
            ),
          );
        }
      },
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
