import 'package:equatable/equatable.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_attempt_review_entity.dart';

enum QuizReviewStatus { initial, loading, loaded, notFound, error }

class QuizReviewState extends Equatable {
  final QuizReviewStatus status;
  final QuizAttemptReviewEntity? review;
  final String? errorMessage;

  const QuizReviewState({
    this.status = QuizReviewStatus.initial,
    this.review,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, review, errorMessage];
}
