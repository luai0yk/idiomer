import 'package:equatable/equatable.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_attempt_entity.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_question_entity.dart';

class QuizReviewItemEntity extends Equatable {
  final QuizQuestionEntity question;
  final int? selectedIdiomId;

  const QuizReviewItemEntity({
    required this.question,
    required this.selectedIdiomId,
  });

  bool get isCorrect => selectedIdiomId == question.correctIdiomId;
  bool get isUnanswered => selectedIdiomId == null;

  @override
  List<Object?> get props => [question, selectedIdiomId];
}

class QuizAttemptReviewEntity extends Equatable {
  final QuizAttemptEntity attempt;
  final List<QuizReviewItemEntity> items;

  const QuizAttemptReviewEntity({required this.attempt, required this.items});

  @override
  List<Object?> get props => [attempt, items];
}
