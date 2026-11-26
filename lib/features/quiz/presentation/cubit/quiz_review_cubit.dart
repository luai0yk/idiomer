import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/features/quiz/domain/usecases/get_quiz_attempt_review_usecase.dart';

import 'quiz_review_state.dart';

class QuizReviewCubit extends Cubit<QuizReviewState> {
  final GetQuizAttemptReviewUseCase _getQuizAttemptReview;
  int? _attemptId;

  QuizReviewCubit({required GetQuizAttemptReviewUseCase getQuizAttemptReview})
    : _getQuizAttemptReview = getQuizAttemptReview,
      super(const QuizReviewState());

  Future<void> loadReview(int attemptId) async {
    _attemptId = attemptId;
    emit(const QuizReviewState(status: QuizReviewStatus.loading));

    try {
      final review = await _getQuizAttemptReview(attemptId);
      if (isClosed) return;

      if (review == null) {
        emit(const QuizReviewState(status: QuizReviewStatus.notFound));
      } else {
        emit(QuizReviewState(status: QuizReviewStatus.loaded, review: review));
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          QuizReviewState(
            status: QuizReviewStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  void retry() {
    final attemptId = _attemptId;
    if (attemptId != null) {
      loadReview(attemptId);
    }
  }
}
