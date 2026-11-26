import 'package:idiomer/features/quiz/data/datasources/quiz_local_datasource.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_answer_submission.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_attempt_entity.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_attempt_review_entity.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_question_entity.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_stats_entity.dart';
import 'package:idiomer/features/quiz/domain/repositories/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizLocalDataSource _localDataSource;

  const QuizRepositoryImpl({required QuizLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<List<QuizQuestionEntity>> generateQuiz({
    int questionCount = 8,
    int? flashcardGroupId,
  }) => _localDataSource.generateQuiz(
    questionCount: questionCount,
    flashcardGroupId: flashcardGroupId,
  );

  @override
  Stream<QuizStatsEntity> watchQuizStats() => _localDataSource.watchQuizStats();

  @override
  Future<QuizAttemptEntity> saveQuizAttempt({
    required int totalQuestions,
    required int correctAnswers,
    required int durationSeconds,
    List<QuizAnswerSubmission> answers = const [],
  }) => _localDataSource.saveQuizAttempt(
    totalQuestions: totalQuestions,
    correctAnswers: correctAnswers,
    durationSeconds: durationSeconds,
    answers: answers,
  );

  @override
  Future<QuizAttemptReviewEntity?> getQuizAttemptReview(int attemptId) =>
      _localDataSource.getQuizAttemptReview(attemptId);
}
