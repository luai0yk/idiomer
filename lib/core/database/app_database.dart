import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:idiomer/core/database/database_paths.dart';
import 'package:idiomer/core/database/tables/idiom_tables.dart';

part 'app_database.g.dart';

/// Main Drift database managing the pre-populated English–Arabic idioms
/// schema alongside user-local tables such as [FavoriteIdioms].
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
  int get schemaVersion => 1;

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

      final existingFavTable = await customSelect(
        "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'favorite_idioms'",
      ).get();
      if (existingFavTable.isEmpty) {
        await m.createTable(favoriteIdioms);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Verifies that the database is readable, contains the core schema,
  /// and has at least one idiom record.
  Future<bool> verifyReady() async {
    try {
      final tables = await customSelect(
        "SELECT name FROM sqlite_master WHERE type = 'table' AND name IN "
        "('idioms', 'idiom_translations', 'categories', 'category_translations', "
        "'definitions', 'definition_translations', 'examples', 'example_translations', "
        "'idiom_categories', 'favorite_idioms')",
      ).get();

      if (tables.length < 10) return false;

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
