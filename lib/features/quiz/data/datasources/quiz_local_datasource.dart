import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:idiomer/core/database/app_database.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_answer_submission.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_attempt_entity.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_attempt_review_entity.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_question_entity.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_stats_entity.dart';

abstract class QuizLocalDataSource {
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

class QuizLocalDataSourceImpl implements QuizLocalDataSource {
  final AppDatabase _db;
  final Random _random;

  QuizLocalDataSourceImpl({required AppDatabase database, Random? random})
    : _db = database,
      _random = random ?? Random();

  @override
  Future<List<QuizQuestionEntity>> generateQuiz({
    int questionCount = 8,
    int? flashcardGroupId,
  }) async {
    final List<QuizOptionEntity> targetPool;
    List<QuizOptionEntity>? fullPool;

    if (flashcardGroupId != null) {
      final groupItems = await (_db.select(
        _db.flashcardGroupItems,
      )..where((t) => t.groupId.equals(flashcardGroupId))).get();
      final groupIdiomIds = groupItems.map((e) => e.idiomId).toSet().toList();
      if (groupIdiomIds.length < questionCount) return const [];

      targetPool = (await _loadOptionPool(idiomIds: groupIdiomIds)).pool;
    } else {
      fullPool = (await _loadOptionPool()).pool;
      targetPool = fullPool;
    }

    final validTargets = targetPool
        .where((o) => o.englishMeaning.isNotEmpty)
        .toList();
    if (flashcardGroupId != null && validTargets.length < questionCount) {
      return const [];
    }
    if (validTargets.isEmpty) return const [];

    final shuffledTargets = List<QuizOptionEntity>.from(validTargets)
      ..shuffle(_random);
    final selectedTargets = shuffledTargets
        .take(min(questionCount, shuffledTargets.length))
        .toList();

    final questions = <QuizQuestionEntity>[];
    for (final target in selectedTargets) {
      var distractorCandidates =
          targetPool
              .where(
                (candidate) =>
                    candidate.idiomId != target.idiomId &&
                    candidate.englishText != target.englishText &&
                    candidate.englishMeaning != target.englishMeaning,
              )
              .toList()
            ..shuffle(_random);

      if (distractorCandidates.length < 3 && flashcardGroupId != null) {
        fullPool ??= (await _loadOptionPool()).pool;
        distractorCandidates =
            fullPool
                .where(
                  (candidate) =>
                      candidate.idiomId != target.idiomId &&
                      candidate.englishText != target.englishText &&
                      candidate.englishMeaning != target.englishMeaning,
                )
                .toList()
              ..shuffle(_random);
      }

      if (distractorCandidates.isEmpty) return const [];

      final options = <QuizOptionEntity>[
        target,
        ...distractorCandidates.take(3),
      ]..shuffle(_random);

      questions.add(
        QuizQuestionEntity(
          idiomId: target.idiomId,
          englishText: target.englishText,
          englishMeaning: target.englishMeaning,
          arabicText: target.arabicText,
          options: options,
          correctIdiomId: target.idiomId,
        ),
      );
    }

    return questions;
  }

  @override
  Stream<QuizStatsEntity> watchQuizStats() {
    final query = _db.select(_db.quizAttempts)
      ..orderBy([
        (t) => OrderingTerm.desc(t.completedAt),
        (t) => OrderingTerm.desc(t.id),
      ]);

    return query.watch().map((rows) {
      final attempts = rows.map(_mapAttempt).toList();
      if (attempts.isEmpty) {
        return const QuizStatsEntity();
      }
      final totalPct = attempts.fold<double>(
        0.0,
        (sum, attempt) => sum + attempt.percentage,
      );
      return QuizStatsEntity(
        totalQuizzes: attempts.length,
        averagePercentage: totalPct / attempts.length,
        attempts: attempts,
      );
    });
  }

  @override
  Future<QuizAttemptEntity> saveQuizAttempt({
    required int totalQuestions,
    required int correctAnswers,
    required int durationSeconds,
    List<QuizAnswerSubmission> answers = const [],
  }) async {
    return _db.transaction(() async {
      final now = DateTime.now();
      final id = await _db
          .into(_db.quizAttempts)
          .insert(
            QuizAttemptsCompanion.insert(
              totalQuestions: totalQuestions,
              correctAnswers: correctAnswers,
              durationSeconds: durationSeconds,
              completedAt: Value(now),
            ),
          );

      for (var i = 0; i < answers.length; i++) {
        final answer = answers[i];
        await _db
            .into(_db.quizAttemptAnswers)
            .insert(
              QuizAttemptAnswersCompanion.insert(
                attemptId: id,
                questionOrder: i,
                idiomId: answer.idiomId,
                selectedIdiomId: Value(answer.selectedIdiomId),
                correctIdiomId: answer.correctIdiomId,
                optionIdiomIds: jsonEncode(answer.optionIdiomIds),
              ),
            );
      }

      final row = await (_db.select(
        _db.quizAttempts,
      )..where((t) => t.id.equals(id))).getSingle();
      return _mapAttempt(row);
    });
  }

  @override
  Future<QuizAttemptReviewEntity?> getQuizAttemptReview(int attemptId) async {
    final attemptRow = await (_db.select(
      _db.quizAttempts,
    )..where((t) => t.id.equals(attemptId))).getSingleOrNull();
    if (attemptRow == null) return null;

    final answerRows =
        await (_db.select(_db.quizAttemptAnswers)
              ..where((t) => t.attemptId.equals(attemptId))
              ..orderBy([(t) => OrderingTerm.asc(t.questionOrder)]))
            .get();

    if (answerRows.isEmpty) {
      return QuizAttemptReviewEntity(
        attempt: _mapAttempt(attemptRow),
        items: const [],
      );
    }

    final neededIds = <int>{};
    final parsedOptionIdsByRow = <int, List<int>>{};

    for (final row in answerRows) {
      neededIds.add(row.idiomId);
      neededIds.add(row.correctIdiomId);
      if (row.selectedIdiomId != null) {
        neededIds.add(row.selectedIdiomId!);
      }
      final decoded = (jsonDecode(row.optionIdiomIds) as List<dynamic>)
          .map((e) => e as int)
          .toList();
      parsedOptionIdsByRow[row.id] = decoded;
      neededIds.addAll(decoded);
    }

    final loaded = await _loadOptionPool(idiomIds: neededIds.toList());
    final optionById = <int, QuizOptionEntity>{
      for (final opt in loaded.pool) opt.idiomId: opt,
    };

    final items = <QuizReviewItemEntity>[];
    for (final row in answerRows) {
      final optionIds = parsedOptionIdsByRow[row.id] ?? const [];
      final options = <QuizOptionEntity>[
        for (final optId in optionIds)
          if (optionById.containsKey(optId)) optionById[optId]!,
      ];

      final question = QuizQuestionEntity(
        idiomId: row.idiomId,
        englishText: loaded.idiomTexts[row.idiomId] ?? '',
        englishMeaning: optionById[row.idiomId]?.englishMeaning ?? '',
        arabicText: optionById[row.idiomId]?.arabicText ?? '',
        options: options,
        correctIdiomId: row.correctIdiomId,
      );

      items.add(
        QuizReviewItemEntity(
          question: question,
          selectedIdiomId: row.selectedIdiomId,
        ),
      );
    }

    return QuizAttemptReviewEntity(
      attempt: _mapAttempt(attemptRow),
      items: items,
    );
  }

  Future<({List<QuizOptionEntity> pool, Map<int, String> idiomTexts})>
  _loadOptionPool({List<int>? idiomIds}) async {
    final itEn = _db.alias(_db.idiomTranslations, 'it_en');
    final itAr = _db.alias(_db.idiomTranslations, 'it_ar');
    final defFirst = _db.alias(_db.definitions, 'def_first');
    final dtEn = _db.alias(_db.definitionTranslations, 'dt_en');
    final dtAr = _db.alias(_db.definitionTranslations, 'dt_ar');

    final query = _db.select(_db.idioms).join([
      innerJoin(
        itEn,
        itEn.idiomId.equalsExp(_db.idioms.id) & itEn.languageCode.equals('en'),
      ),
      leftOuterJoin(
        itAr,
        itAr.idiomId.equalsExp(_db.idioms.id) & itAr.languageCode.equals('ar'),
      ),
      leftOuterJoin(
        defFirst,
        defFirst.idiomId.equalsExp(_db.idioms.id) &
            defFirst.displayOrder.equals(1),
      ),
      leftOuterJoin(
        dtEn,
        dtEn.definitionId.equalsExp(defFirst.id) &
            dtEn.languageCode.equals('en'),
      ),
      leftOuterJoin(
        dtAr,
        dtAr.definitionId.equalsExp(defFirst.id) &
            dtAr.languageCode.equals('ar'),
      ),
    ]);

    if (idiomIds != null) {
      if (idiomIds.isEmpty) {
        return (pool: const <QuizOptionEntity>[], idiomTexts: <int, String>{});
      }
      query.where(_db.idioms.id.isIn(idiomIds));
    }

    final rows = await query.get();
    final pool = <QuizOptionEntity>[];
    final idiomTexts = <int, String>{};

    for (final row in rows) {
      final idiom = row.readTable(_db.idioms);
      final en = row.readTable(itEn);
      final ar = row.readTableOrNull(itAr);
      final enDef = row.readTableOrNull(dtEn);
      final arDef = row.readTableOrNull(dtAr);

      final englishText = en.textValue.trim();
      final arabicText = ar?.textValue.trim() ?? '';
      if (englishText.isEmpty) continue;

      idiomTexts[idiom.id] = englishText;
      pool.add(
        QuizOptionEntity(
          idiomId: idiom.id,
          englishText: englishText,
          englishMeaning: enDef?.meaning.trim() ?? '',
          arabicText: arabicText,
          arabicMeaning: arDef?.meaning.trim() ?? '',
        ),
      );
    }

    return (pool: pool, idiomTexts: idiomTexts);
  }

  QuizAttemptEntity _mapAttempt(QuizAttempt row) {
    return QuizAttemptEntity(
      id: row.id,
      totalQuestions: row.totalQuestions,
      correctAnswers: row.correctAnswers,
      durationSeconds: row.durationSeconds,
      completedAt: row.completedAt,
    );
  }
}
