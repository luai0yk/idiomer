import 'package:equatable/equatable.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_attempt_entity.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_question_entity.dart';

enum QuizSessionStatus { initial, loading, inProgress, completed, empty, error }

class QuizSessionState extends Equatable {
  static const int totalQuestionsLimit = 8;
  static const int timeLimitSeconds = 120;

  final QuizSessionStatus status;
  final List<QuizQuestionEntity> questions;
  final int currentIndex;
  final Map<int, int> selectedAnswers;
  final int remainingSeconds;
  final bool timedOut;
  final bool isSubmitting;
  final QuizAttemptEntity? savedAttempt;
  final String? errorMessage;

  const QuizSessionState({
    this.status = QuizSessionStatus.initial,
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedAnswers = const {},
    this.remainingSeconds = timeLimitSeconds,
    this.timedOut = false,
    this.isSubmitting = false,
    this.savedAttempt,
    this.errorMessage,
  });

  int get totalQuestions => questions.length;
  int get answeredCount => selectedAnswers.length;
  bool get allAnswered =>
      questions.isNotEmpty && selectedAnswers.length == questions.length;
  bool get canGoPrevious => currentIndex > 0;
  bool get canGoNext => currentIndex < questions.length - 1;

  QuizQuestionEntity? get currentQuestion =>
      (currentIndex >= 0 && currentIndex < questions.length)
      ? questions[currentIndex]
      : null;

  int? get currentSelectedOptionId => selectedAnswers[currentIndex];

  int get correctAnswersCount {
    var count = 0;
    for (var i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i].correctIdiomId) {
        count++;
      }
    }
    return count;
  }

  static const Object _unset = Object();

  QuizSessionState copyWith({
    QuizSessionStatus? status,
    List<QuizQuestionEntity>? questions,
    int? currentIndex,
    Map<int, int>? selectedAnswers,
    int? remainingSeconds,
    bool? timedOut,
    bool? isSubmitting,
    Object? savedAttempt = _unset,
    Object? errorMessage = _unset,
  }) {
    return QuizSessionState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      timedOut: timedOut ?? this.timedOut,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      savedAttempt: savedAttempt == _unset
          ? this.savedAttempt
          : savedAttempt as QuizAttemptEntity?,
      errorMessage: errorMessage == _unset
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    questions,
    currentIndex,
    selectedAnswers,
    remainingSeconds,
    timedOut,
    isSubmitting,
    savedAttempt,
    errorMessage,
  ];
}
