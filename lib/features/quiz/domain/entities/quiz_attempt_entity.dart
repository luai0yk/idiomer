import 'package:equatable/equatable.dart';

class QuizAttemptEntity extends Equatable {
  final int id;
  final int totalQuestions;
  final int correctAnswers;
  final int durationSeconds;
  final DateTime completedAt;

  const QuizAttemptEntity({
    required this.id,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.durationSeconds,
    required this.completedAt,
  });

  double get percentage =>
      totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100.0 : 0.0;

  @override
  List<Object?> get props => [
    id,
    totalQuestions,
    correctAnswers,
    durationSeconds,
    completedAt,
  ];
}
