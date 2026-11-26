import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:idiomer/core/database/database_paths.dart';
import 'package:idiomer/core/database/tables/flashcard_tables.dart';
import 'package:idiomer/core/database/tables/idiom_tables.dart';
import 'package:idiomer/core/database/tables/quiz_tables.dart';

part 'app_database.g.dart';

/// Main Drift database managing the pre-populated English–Arabic idioms
/// schema alongside user-local tables such as [FavoriteIdioms],
/// [FlashcardGroups], [FlashcardGroupItems], and [QuizAttempts].
@DriftDatabase(
  tables: [
    Languages,
    Categories,
    CategoryTranslations,
    Idioms,
    IdiomTranslations,
    Definitions,
    DefinitionTranslations,
    Examples,
    ExampleTranslations,
    IdiomCategories,
    FavoriteIdioms,
    FlashcardGroups,
    FlashcardGroupItems,
    QuizAttempts,
    QuizAttemptAnswers,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor, DatabasePaths? paths])
    : super(executor ?? _openConnection(paths ?? const DatabasePaths()));

  static QueryExecutor _openConnection(DatabasePaths paths) {
    return LazyDatabase(() async {
      final dbFile = await paths.getDatabaseFile();
      if (!await dbFile.exists() || await dbFile.length() == 0) {
        throw StateError(
          'Database file is not ready at ${dbFile.path}. '
          'Complete database setup before opening AppDatabase.',
        );
      }
      return NativeDatabase.createInBackground(dbFile);
    });
  }

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      // Pre-populated databases already have core tables with user_version = 0,
      // whereas fresh test databases need all tables created.
      final existingCoreTable = await customSelect(
        "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'idioms'",
      ).get();

      if (existingCoreTable.isEmpty) {
        await m.createAll();
        return;
      }

      await _ensureLocalTablesCreated(m);
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 3) {
        await _ensureLocalTablesCreated(m);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _ensureLocalTablesCreated(Migrator m) async {
    final existingTables = await customSelect(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name IN "
      "('favorite_idioms', 'flashcard_groups', 'flashcard_group_items', 'quiz_attempts', 'quiz_attempt_answers')",
    ).get();
    final tableNames = existingTables
        .map((row) => row.read<String>('name'))
        .toSet();

    if (!tableNames.contains('favorite_idioms')) {
      await m.createTable(favoriteIdioms);
    }
    if (!tableNames.contains('flashcard_groups')) {
      await m.createTable(flashcardGroups);
    }
    if (!tableNames.contains('flashcard_group_items')) {
      await m.createTable(flashcardGroupItems);
      await m.createIndex(flashcardGroupItemsGroupIdx);
      await m.createIndex(flashcardGroupItemsIdiomIdx);
    }
    if (!tableNames.contains('quiz_attempts')) {
      await m.createTable(quizAttempts);
      await m.createIndex(quizAttemptsCompletedAtIdx);
    }
    if (!tableNames.contains('quiz_attempt_answers')) {
      await m.createTable(quizAttemptAnswers);
      await m.createIndex(quizAttemptAnswersAttemptIdx);
    }
  }

  /// Verifies that the database is readable, contains the core schema,
  /// and has at least one idiom record.
  Future<bool> verifyReady() async {
    try {
      final tables = await customSelect(
        "SELECT name FROM sqlite_master WHERE type = 'table' AND name IN "
        "('idioms', 'idiom_translations', 'categories', 'category_translations', "
        "'definitions', 'definition_translations', 'examples', 'example_translations', "
        "'idiom_categories', 'favorite_idioms', 'flashcard_groups', "
        "'flashcard_group_items', 'quiz_attempts', 'quiz_attempt_answers')",
      ).get();

      if (tables.length < 14) return false;

      final countExpr = idioms.id.count();
      final count = await (selectOnly(idioms)..addColumns([countExpr]))
          .map((row) => row.read(countExpr) ?? 0)
          .getSingle();

      return count > 0;
    } catch (_) {
      return false;
    }
  }
}
