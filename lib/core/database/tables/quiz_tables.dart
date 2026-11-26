import 'package:drift/drift.dart';
import 'package:idiomer/core/database/tables/idiom_tables.dart';

/// Stores completed idiom quiz attempts for overview stats and history.
@TableIndex(
  name: 'quiz_attempts_completed_at_idx',
  columns: {IndexedColumn(#completedAt, orderBy: OrderingMode.desc)},
)
class QuizAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get totalQuestions => integer()();

  IntColumn get correctAnswers => integer()();

  IntColumn get durationSeconds => integer()();

  DateTimeColumn get completedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => [
    'CHECK (total_questions > 0)',
    'CHECK (correct_answers >= 0 AND correct_answers <= total_questions)',
    'CHECK (duration_seconds >= 0)',
  ];
}

/// Stores each question and user answer for a completed [QuizAttempts] record
/// so users can review taken exams in read-only mode.
@TableIndex(name: 'quiz_attempt_answers_attempt_idx', columns: {#attemptId})
class QuizAttemptAnswers extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get attemptId => integer().references(
    QuizAttempts,
    #id,
    onDelete: KeyAction.cascade,
    onUpdate: KeyAction.cascade,
  )();

  IntColumn get questionOrder => integer()();

  IntColumn get idiomId => integer().references(
    Idioms,
    #id,
    onDelete: KeyAction.cascade,
    onUpdate: KeyAction.cascade,
  )();

  IntColumn get selectedIdiomId => integer().nullable().references(
    Idioms,
    #id,
    onDelete: KeyAction.setNull,
    onUpdate: KeyAction.cascade,
  )();

  IntColumn get correctIdiomId => integer().references(
    Idioms,
    #id,
    onDelete: KeyAction.cascade,
    onUpdate: KeyAction.cascade,
  )();

  /// JSON-encoded list of option idiom IDs preserving the original option order.
  TextColumn get optionIdiomIds => text()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {attemptId, questionOrder},
  ];
}
