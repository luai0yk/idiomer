import 'package:equatable/equatable.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_attempt_entity.dart';

class QuizStatsEntity extends Equatable {
  final int totalQuizzes;
  final double averagePercentage;
  final List<QuizAttemptEntity> attempts;

  const QuizStatsEntity({
    this.totalQuizzes = 0,
    this.averagePercentage = 0.0,
    this.attempts = const [],
  });

  bool get hasCompletedQuiz => totalQuizzes > 0;

  @override
  List<Object?> get props => [totalQuizzes, averagePercentage, attempts];
}
