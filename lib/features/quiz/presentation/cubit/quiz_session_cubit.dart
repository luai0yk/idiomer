import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_answer_submission.dart';
import 'package:idiomer/features/quiz/domain/usecases/generate_quiz_usecase.dart';
import 'package:idiomer/features/quiz/domain/usecases/save_quiz_attempt_usecase.dart';

import 'quiz_session_state.dart';

class QuizSessionCubit extends Cubit<QuizSessionState> {
  final GenerateQuizUseCase _generateQuiz;
  final SaveQuizAttemptUseCase _saveQuizAttempt;
  Timer? _timer;
  int? _activeFlashcardGroupId;

  QuizSessionCubit({
    required GenerateQuizUseCase generateQuiz,
    required SaveQuizAttemptUseCase saveQuizAttempt,
  }) : _generateQuiz = generateQuiz,
       _saveQuizAttempt = saveQuizAttempt,
       super(const QuizSessionState());

  Future<void> startQuiz({int? flashcardGroupId}) async {
    _activeFlashcardGroupId = flashcardGroupId;
    _timer?.cancel();
    emit(
      const QuizSessionState(
        status: QuizSessionStatus.loading,
        remainingSeconds: QuizSessionState.timeLimitSeconds,
      ),
    );

    try {
      final questions = await _generateQuiz(
        questionCount: QuizSessionState.totalQuestionsLimit,
        flashcardGroupId: flashcardGroupId,
      );
      if (isClosed) return;

      if (questions.isEmpty) {
        emit(const QuizSessionState(status: QuizSessionStatus.empty));
        return;
      }

      emit(
        QuizSessionState(
          status: QuizSessionStatus.inProgress,
          questions: questions,
          currentIndex: 0,
          selectedAnswers: const {},
          remainingSeconds: QuizSessionState.timeLimitSeconds,
        ),
      );
      _startTimer();
    } catch (e) {
      if (!isClosed) {
        emit(
          QuizSessionState(
            status: QuizSessionStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isClosed || state.status != QuizSessionStatus.inProgress) {
        _timer?.cancel();
        return;
      }

      final nextRemaining = state.remainingSeconds - 1;
      if (nextRemaining <= 0) {
        _timer?.cancel();
        emit(state.copyWith(remainingSeconds: 0));
        submitQuiz(timedOut: true);
      } else {
        emit(state.copyWith(remainingSeconds: nextRemaining));
      }
    });
  }

  void selectOption(int optionIdiomId, {int? questionIndex}) {
    if (state.status != QuizSessionStatus.inProgress || state.isSubmitting) {
      return;
    }

    final targetIndex = questionIndex ?? state.currentIndex;
    if (targetIndex < 0 || targetIndex >= state.questions.length) {
      return;
    }

    final updated = Map<int, int>.from(state.selectedAnswers)
      ..[targetIndex] = optionIdiomId;
    emit(state.copyWith(selectedAnswers: updated));
  }

  void nextQuestion() {
    if (!state.canGoNext) return;
    emit(state.copyWith(currentIndex: state.currentIndex + 1));
  }

  void previousQuestion() {
    if (!state.canGoPrevious) return;
    emit(state.copyWith(currentIndex: state.currentIndex - 1));
  }

  void jumpToQuestion(int index) {
    if (index < 0 || index >= state.questions.length) return;
    emit(state.copyWith(currentIndex: index));
  }

  Future<void> submitQuiz({bool timedOut = false}) async {
    if (state.status != QuizSessionStatus.inProgress || state.isSubmitting) {
      return;
    }
    if (!timedOut && !state.allAnswered) {
      return;
    }

    _timer?.cancel();
    emit(state.copyWith(isSubmitting: true));

    final elapsedSeconds = timedOut
        ? QuizSessionState.timeLimitSeconds
        : (QuizSessionState.timeLimitSeconds - state.remainingSeconds).clamp(
            0,
            QuizSessionState.timeLimitSeconds,
          );

    try {
      final submissions = <QuizAnswerSubmission>[
        for (var i = 0; i < state.questions.length; i++)
          QuizAnswerSubmission(
            idiomId: state.questions[i].idiomId,
            selectedIdiomId: state.selectedAnswers[i],
            correctIdiomId: state.questions[i].correctIdiomId,
            optionIdiomIds: state.questions[i].options
                .map((o) => o.idiomId)
                .toList(),
          ),
      ];

      final attempt = await _saveQuizAttempt(
        totalQuestions: state.totalQuestions,
        correctAnswers: state.correctAnswersCount,
        durationSeconds: elapsedSeconds,
        answers: submissions,
      );
      if (isClosed) return;

      emit(
        state.copyWith(
          status: QuizSessionStatus.completed,
          timedOut: timedOut,
          isSubmitting: false,
          savedAttempt: attempt,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: QuizSessionStatus.error,
            isSubmitting: false,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> restartQuiz() =>
      startQuiz(flashcardGroupId: _activeFlashcardGroupId);

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
