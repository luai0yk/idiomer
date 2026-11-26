import 'package:idiomer/features/quiz/domain/entities/quiz_attempt_review_entity.dart';
import 'package:idiomer/features/quiz/domain/repositories/quiz_repository.dart';

class GetQuizAttemptReviewUseCase {
  final QuizRepository _repository;

  const GetQuizAttemptReviewUseCase(this._repository);

  Future<QuizAttemptReviewEntity?> call(int attemptId) =>
      _repository.getQuizAttemptReview(attemptId);
}
