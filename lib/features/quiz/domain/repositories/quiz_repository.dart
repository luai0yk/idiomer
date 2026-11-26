import 'package:idiomer/features/quiz/domain/entities/quiz_answer_submission.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_attempt_entity.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_attempt_review_entity.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_question_entity.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_stats_entity.dart';

abstract class QuizRepository {
  Future<List<QuizQuestionEntity>> generateQuiz({
    int questionCount = 8,
    int? flashcardGroupId,
  });

  Stream<QuizStatsEntity> watchQuizStats();

  Future<QuizAttemptEntity> saveQuizAttempt({
    required int totalQuestions,
    required int correctAnswers,
    required int durationSeconds,
    List<QuizAnswerSubmission> answers = const [],
  });

  Future<QuizAttemptReviewEntity?> getQuizAttemptReview(int attemptId);
}
