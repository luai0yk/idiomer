import 'dart:math';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/core/database/app_database.dart';
import 'package:idiomer/features/quiz/data/datasources/quiz_local_datasource.dart';
import 'package:idiomer/features/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:idiomer/features/quiz/domain/usecases/generate_quiz_usecase.dart';
import 'package:idiomer/features/quiz/domain/usecases/save_quiz_attempt_usecase.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_session_cubit.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_session_state.dart';

import '../idioms/idioms_local_datasource_test.dart';

Future<void> seedQuizIdioms(AppDatabase db, {int total = 10}) async {
  await seedTestDatabase(db);
  for (int i = 3; i <= total; i++) {
    await db
        .into(db.idioms)
        .insert(IdiomsCompanion.insert(id: Value(i), slug: Value('idiom-$i')));
    await db
        .into(db.idiomTranslations)
        .insert(
          IdiomTranslationsCompanion.insert(
            idiomId: i,
            languageCode: 'en',
            textValue: 'Idiom $i',
          ),
        );
    await db
        .into(db.idiomTranslations)
        .insert(
          IdiomTranslationsCompanion.insert(
            idiomId: i,
            languageCode: 'ar',
            textValue: 'تعبير $i',
          ),
        );
    final defId = await db
        .into(db.definitions)
        .insert(DefinitionsCompanion.insert(idiomId: i));
    await db
        .into(db.definitionTranslations)
        .insert(
          DefinitionTranslationsCompanion.insert(
            definitionId: defId,
            languageCode: 'en',
            meaning: 'English meaning $i',
          ),
        );
    await db
        .into(db.definitionTranslations)
        .insert(
          DefinitionTranslationsCompanion.insert(
            definitionId: defId,
            languageCode: 'ar',
            meaning: 'المعنى العربي $i',
          ),
        );
  }
}

void main() {
  late AppDatabase db;
  late QuizLocalDataSourceImpl dataSource;
  late QuizRepositoryImpl repository;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await seedQuizIdioms(db, total: 10);
    dataSource = QuizLocalDataSourceImpl(database: db, random: Random(42));
    repository = QuizRepositoryImpl(localDataSource: dataSource);
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'generateQuiz builds 8 distinct questions with 4 distinct options',
    () async {
      final questions = await dataSource.generateQuiz(questionCount: 8);

      expect(questions.length, 8);
      expect(questions.map((q) => q.idiomId).toSet().length, 8);
      for (final q in questions) {
        expect(q.englishMeaning, isNotEmpty);
        expect(q.options.length, 4);
        expect(q.options.any((o) => o.idiomId == q.correctIdiomId), isTrue);
        expect(q.options.every((o) => o.englishText.isNotEmpty), isTrue);
        expect(q.options.map((o) => o.idiomId).toSet().length, 4);
      }
    },
  );

  test('saveQuizAttempt updates watchQuizStats totals and averages', () async {
    final initial = await dataSource.watchQuizStats().first;
    expect(initial.hasCompletedQuiz, isFalse);
    expect(initial.totalQuizzes, 0);

    await dataSource.saveQuizAttempt(
      totalQuestions: 8,
      correctAnswers: 6,
      durationSeconds: 45,
    );
    await dataSource.saveQuizAttempt(
      totalQuestions: 8,
      correctAnswers: 8,
      durationSeconds: 30,
    );

    final stats = await dataSource.watchQuizStats().first;
    expect(stats.hasCompletedQuiz, isTrue);
    expect(stats.totalQuizzes, 2);
    expect(stats.averagePercentage, closeTo(87.5, 0.01));
    expect(stats.attempts.first.correctAnswers, 8);
  });

  test(
    'QuizSessionCubit enforces 8 questions, 120s limit, navigation, and all-answered submit',
    () async {
      final cubit = QuizSessionCubit(
        generateQuiz: GenerateQuizUseCase(repository),
        saveQuizAttempt: SaveQuizAttemptUseCase(repository),
      );
      addTearDown(cubit.close);

      await cubit.startQuiz();
      expect(cubit.state.status, QuizSessionStatus.inProgress);
      expect(cubit.state.totalQuestions, 8);
      expect(cubit.state.remainingSeconds, 120);
      expect(cubit.state.allAnswered, isFalse);

      // Submitting before all questions are answered is a no-op.
      await cubit.submitQuiz();
      expect(cubit.state.status, QuizSessionStatus.inProgress);

      for (int i = 0; i < 8; i++) {
        expect(cubit.state.currentIndex, i);
        cubit.selectOption(cubit.state.currentQuestion!.correctIdiomId);
        if (i < 7) {
          cubit.nextQuestion();
        }
      }

      expect(cubit.state.allAnswered, isTrue);
      cubit.previousQuestion();
      expect(cubit.state.currentIndex, 6);
      cubit.nextQuestion();
      expect(cubit.state.currentIndex, 7);

      await cubit.submitQuiz();
      expect(cubit.state.status, QuizSessionStatus.completed);
      expect(cubit.state.savedAttempt?.correctAnswers, 8);
      expect(cubit.state.savedAttempt?.totalQuestions, 8);

      final attemptId = cubit.state.savedAttempt!.id;
      final review = await dataSource.getQuizAttemptReview(attemptId);
      expect(review, isNotNull);
      expect(review!.attempt.id, attemptId);
      expect(review.items.length, 8);
      for (final item in review.items) {
        expect(item.isCorrect, isTrue);
        expect(item.question.englishMeaning, isNotEmpty);
        expect(item.question.options.length, 4);
        expect(
          item.question.options.every((o) => o.englishText.isNotEmpty),
          isTrue,
        );
      }
    },
  );

  test(
    'generateQuiz for flashcardGroupId caps at 8 and returns empty when group has fewer than 8 idioms',
    () async {
      // Seed additional idioms and test both >8 (10 idioms) and <8 (7 idioms).
      await db.close();
      db = AppDatabase(NativeDatabase.memory());
      await seedQuizIdioms(db, total: 12);
      dataSource = QuizLocalDataSourceImpl(database: db, random: Random(7));

      final largeGroupId = await db
          .into(db.flashcardGroups)
          .insert(
            FlashcardGroupsCompanion.insert(
              name: 'Large Group',
              createdAt: Value(DateTime(2026)),
              updatedAt: Value(DateTime(2026)),
            ),
          );
      for (int id = 1; id <= 10; id++) {
        await db
            .into(db.flashcardGroupItems)
            .insert(
              FlashcardGroupItemsCompanion.insert(
                groupId: largeGroupId,
                idiomId: id,
                createdAt: Value(DateTime(2026)),
              ),
            );
      }

      final largeQuestions = await dataSource.generateQuiz(
        questionCount: 8,
        flashcardGroupId: largeGroupId,
      );
      expect(largeQuestions.length, 8);
      for (final q in largeQuestions) {
        expect(q.idiomId, inInclusiveRange(1, 10));
        expect(q.options.length, 4);
      }

      // Group with fewer than 8 idioms is not eligible for a group quiz.
      final smallGroupId = await db
          .into(db.flashcardGroups)
          .insert(
            FlashcardGroupsCompanion.insert(
              name: 'Small Group',
              createdAt: Value(DateTime(2026)),
              updatedAt: Value(DateTime(2026)),
            ),
          );
      for (int id = 1; id <= 7; id++) {
        await db
            .into(db.flashcardGroupItems)
            .insert(
              FlashcardGroupItemsCompanion.insert(
                groupId: smallGroupId,
                idiomId: id,
                createdAt: Value(DateTime(2026)),
              ),
            );
      }

      final smallQuestions = await dataSource.generateQuiz(
        questionCount: 8,
        flashcardGroupId: smallGroupId,
      );
      expect(smallQuestions, isEmpty);
    },
  );
}
