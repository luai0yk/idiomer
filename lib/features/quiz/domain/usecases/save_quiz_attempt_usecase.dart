import 'package:idiomer/features/quiz/domain/entities/quiz_answer_submission.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_attempt_entity.dart';
import 'package:idiomer/features/quiz/domain/repositories/quiz_repository.dart';

class SaveQuizAttemptUseCase {
  final QuizRepository _repository;

  const SaveQuizAttemptUseCase(this._repository);

  Future<QuizAttemptEntity> call({
    required int totalQuestions,
    required int correctAnswers,
    required int durationSeconds,
    List<QuizAnswerSubmission> answers = const [],
  }) => _repository.saveQuizAttempt(
    totalQuestions: totalQuestions,
    correctAnswers: correctAnswers,
    durationSeconds: durationSeconds,
    answers: answers,
  );
}
