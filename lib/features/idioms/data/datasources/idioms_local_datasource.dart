import 'package:drift/drift.dart';
import 'package:idiomer/core/database/app_database.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_entity.dart';

abstract class IdiomsLocalDataSource {
  Stream<List<CategoryEntity>> watchCategories();

  Stream<List<IdiomEntity>> watchIdioms({
    String query = '',
    String? categoryId,
    int limit = 50,
    bool favoritesOnly = false,
  });

  Stream<IdiomDetailEntity?> watchIdiomDetail(int idiomId);

  Future<void> toggleFavorite(int idiomId);

  Future<void> setFavorite(int idiomId, {required bool isFavorite});

  Future<void> clearAllFavorites();
}

class IdiomsLocalDataSourceImpl implements IdiomsLocalDataSource {
  final AppDatabase _db;

  const IdiomsLocalDataSourceImpl({required AppDatabase database})
    : _db = database;

  @override
  Stream<List<CategoryEntity>> watchCategories() {
    final ctEn = _db.alias(_db.categoryTranslations, 'ct_en');
    final ctAr = _db.alias(_db.categoryTranslations, 'ct_ar');

    final query = _db.select(_db.categories).join([
      leftOuterJoin(
        ctEn,
        ctEn.categoryId.equalsExp(_db.categories.id) &
            ctEn.languageCode.equals('en'),
      ),
      leftOuterJoin(
        ctAr,
        ctAr.categoryId.equalsExp(_db.categories.id) &
            ctAr.languageCode.equals('ar'),
      ),
    ])..orderBy([OrderingTerm.asc(_db.categories.displayOrder)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final cat = row.readTable(_db.categories);
        final en = row.readTableOrNull(ctEn);
        final ar = row.readTableOrNull(ctAr);
        return CategoryEntity(
          id: cat.id,
          displayOrder: cat.displayOrder,
          englishName: en?.name ?? cat.id,
          arabicName: ar?.name ?? en?.name ?? cat.id,
          englishDescription: en?.description,
          arabicDescription: ar?.description,
        );
      }).toList();
    });
  }

  @override
  Stream<List<IdiomEntity>> watchIdioms({
    String query = '',
    String? categoryId,
    int limit = 50,
    bool favoritesOnly = false,
  }) {
    final itEn = _db.alias(_db.idiomTranslations, 'it_en');
    final itAr = _db.alias(_db.idiomTranslations, 'it_ar');
    final exFirst = _db.alias(_db.examples, 'ex_first');
    final etEn = _db.alias(_db.exampleTranslations, 'et_en');
    final etAr = _db.alias(_db.exampleTranslations, 'et_ar');

    final joins = <Join>[
      leftOuterJoin(
        itEn,
        itEn.idiomId.equalsExp(_db.idioms.id) & itEn.languageCode.equals('en'),
      ),
      leftOuterJoin(
        itAr,
        itAr.idiomId.equalsExp(_db.idioms.id) & itAr.languageCode.equals('ar'),
      ),
      leftOuterJoin(
        exFirst,
        exFirst.idiomId.equalsExp(_db.idioms.id) &
            exFirst.displayOrder.equals(1),
      ),
      leftOuterJoin(
        etEn,
        etEn.exampleId.equalsExp(exFirst.id) & etEn.languageCode.equals('en'),
      ),
      leftOuterJoin(
        etAr,
        etAr.exampleId.equalsExp(exFirst.id) & etAr.languageCode.equals('ar'),
      ),
      if (favoritesOnly)
        innerJoin(
          _db.favoriteIdioms,
          _db.favoriteIdioms.idiomId.equalsExp(_db.idioms.id),
        )
      else
        leftOuterJoin(
          _db.favoriteIdioms,
          _db.favoriteIdioms.idiomId.equalsExp(_db.idioms.id),
        ),
      if (categoryId != null && categoryId.isNotEmpty)
        innerJoin(
          _db.idiomCategories,
          _db.idiomCategories.idiomId.equalsExp(_db.idioms.id) &
              _db.idiomCategories.categoryId.equals(categoryId),
          useColumns: false,
        ),
    ];

    final statement = _db.select(_db.idioms).join(joins);

    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      statement.where(
        itEn.textValue.contains(trimmed) |
            itAr.textValue.contains(trimmed) |
            etEn.sentence.contains(trimmed) |
            etAr.sentence.contains(trimmed),
      );
    }

    statement.orderBy([
      if (favoritesOnly) OrderingTerm.desc(_db.favoriteIdioms.createdAt),
      OrderingTerm.asc(itEn.textValue),
    ]);
    statement.limit(limit);

    return statement.watch().map((rows) {
      return rows.map((row) {
        final idiom = row.readTable(_db.idioms);
        final en = row.readTableOrNull(itEn);
        final ar = row.readTableOrNull(itAr);
        final exEn = row.readTableOrNull(etEn);
        final exAr = row.readTableOrNull(etAr);
        final fav = row.readTableOrNull(_db.favoriteIdioms);

        return IdiomEntity(
          id: idiom.id,
          slug: idiom.slug,
          englishText: en?.textValue ?? '',
          arabicText: ar?.textValue ?? '',
          englishExample: exEn?.sentence,
          arabicExample: exAr?.sentence,
          isFavorite: fav != null,
        );
      }).toList();
    });
  }

  @override
  Stream<IdiomDetailEntity?> watchIdiomDetail(int idiomId) {
    final itEn = _db.alias(_db.idiomTranslations, 'it_en');
    final itAr = _db.alias(_db.idiomTranslations, 'it_ar');

    final baseQuery = _db.select(_db.idioms).join([
      leftOuterJoin(
        itEn,
        itEn.idiomId.equalsExp(_db.idioms.id) & itEn.languageCode.equals('en'),
      ),
      leftOuterJoin(
        itAr,
        itAr.idiomId.equalsExp(_db.idioms.id) & itAr.languageCode.equals('ar'),
      ),
      leftOuterJoin(
        _db.favoriteIdioms,
        _db.favoriteIdioms.idiomId.equalsExp(_db.idioms.id),
      ),
    ])..where(_db.idioms.id.equals(idiomId));

    return baseQuery.watchSingleOrNull().asyncMap((baseRow) async {
      if (baseRow == null) return null;

      final idiom = baseRow.readTable(_db.idioms);
      final en = baseRow.readTableOrNull(itEn);
      final ar = baseRow.readTableOrNull(itAr);
      final fav = baseRow.readTableOrNull(_db.favoriteIdioms);

      final definitions = await _fetchDefinitions(idiomId);
      final examples = await _fetchExamples(idiomId);
      final categories = await _fetchIdiomCategories(idiomId);

      return IdiomDetailEntity(
        id: idiom.id,
        slug: idiom.slug,
        englishText: en?.textValue ?? '',
        arabicText: ar?.textValue ?? '',
        englishNotes: en?.notes,
        arabicNotes: ar?.notes,
        definitions: definitions,
        examples: examples,
        categories: categories,
        isFavorite: fav != null,
      );
    });
  }

  Future<List<IdiomDefinitionEntity>> _fetchDefinitions(int idiomId) async {
    final dtEn = _db.alias(_db.definitionTranslations, 'dt_en');
    final dtAr = _db.alias(_db.definitionTranslations, 'dt_ar');

    final query =
        _db.select(_db.definitions).join([
            leftOuterJoin(
              dtEn,
              dtEn.definitionId.equalsExp(_db.definitions.id) &
                  dtEn.languageCode.equals('en'),
            ),
            leftOuterJoin(
              dtAr,
              dtAr.definitionId.equalsExp(_db.definitions.id) &
                  dtAr.languageCode.equals('ar'),
            ),
          ])
          ..where(_db.definitions.idiomId.equals(idiomId))
          ..orderBy([OrderingTerm.asc(_db.definitions.displayOrder)]);

    final rows = await query.get();
    return rows.map((row) {
      final def = row.readTable(_db.definitions);
      final en = row.readTableOrNull(dtEn);
      final ar = row.readTableOrNull(dtAr);
      return IdiomDefinitionEntity(
        id: def.id,
        displayOrder: def.displayOrder,
        englishMeaning: en?.meaning ?? '',
        arabicMeaning: ar?.meaning ?? '',
      );
    }).toList();
  }

  Future<List<IdiomExampleEntity>> _fetchExamples(int idiomId) async {
    final etEn = _db.alias(_db.exampleTranslations, 'et_en');
    final etAr = _db.alias(_db.exampleTranslations, 'et_ar');

    final query =
        _db.select(_db.examples).join([
            leftOuterJoin(
              etEn,
              etEn.exampleId.equalsExp(_db.examples.id) &
                  etEn.languageCode.equals('en'),
            ),
            leftOuterJoin(
              etAr,
              etAr.exampleId.equalsExp(_db.examples.id) &
                  etAr.languageCode.equals('ar'),
            ),
          ])
          ..where(_db.examples.idiomId.equals(idiomId))
          ..orderBy([OrderingTerm.asc(_db.examples.displayOrder)]);

    final rows = await query.get();
    return rows.map((row) {
      final ex = row.readTable(_db.examples);
      final en = row.readTableOrNull(etEn);
      final ar = row.readTableOrNull(etAr);
      return IdiomExampleEntity(
        id: ex.id,
        definitionId: ex.definitionId,
        displayOrder: ex.displayOrder,
        englishSentence: en?.sentence ?? '',
        arabicSentence: ar?.sentence ?? '',
      );
    }).toList();
  }

  Future<List<CategoryEntity>> _fetchIdiomCategories(int idiomId) async {
    final ctEn = _db.alias(_db.categoryTranslations, 'ct_en');
    final ctAr = _db.alias(_db.categoryTranslations, 'ct_ar');

    final query = _db.select(_db.categories).join([
      innerJoin(
        _db.idiomCategories,
        _db.idiomCategories.categoryId.equalsExp(_db.categories.id) &
            _db.idiomCategories.idiomId.equals(idiomId),
        useColumns: false,
      ),
      leftOuterJoin(
        ctEn,
        ctEn.categoryId.equalsExp(_db.categories.id) &
            ctEn.languageCode.equals('en'),
      ),
      leftOuterJoin(
        ctAr,
        ctAr.categoryId.equalsExp(_db.categories.id) &
            ctAr.languageCode.equals('ar'),
      ),
    ])..orderBy([OrderingTerm.asc(_db.categories.displayOrder)]);

    final rows = await query.get();
    return rows.map((row) {
      final cat = row.readTable(_db.categories);
      final en = row.readTableOrNull(ctEn);
      final ar = row.readTableOrNull(ctAr);
      return CategoryEntity(
        id: cat.id,
        displayOrder: cat.displayOrder,
        englishName: en?.name ?? cat.id,
        arabicName: ar?.name ?? en?.name ?? cat.id,
        englishDescription: en?.description,
        arabicDescription: ar?.description,
      );
    }).toList();
  }

  @override
  Future<void> toggleFavorite(int idiomId) async {
    await _db.transaction(() async {
      final existing = await (_db.select(
        _db.favoriteIdioms,
      )..where((t) => t.idiomId.equals(idiomId))).getSingleOrNull();

      if (existing != null) {
        await (_db.delete(
          _db.favoriteIdioms,
        )..where((t) => t.idiomId.equals(idiomId))).go();
      } else {
        await _db
            .into(_db.favoriteIdioms)
            .insertOnConflictUpdate(
              FavoriteIdiomsCompanion.insert(idiomId: Value(idiomId)),
            );
      }
    });
  }

  @override
  Future<void> setFavorite(int idiomId, {required bool isFavorite}) async {
    if (isFavorite) {
      await _db
          .into(_db.favoriteIdioms)
          .insertOnConflictUpdate(
            FavoriteIdiomsCompanion.insert(idiomId: Value(idiomId)),
          );
    } else {
      await (_db.delete(
        _db.favoriteIdioms,
      )..where((t) => t.idiomId.equals(idiomId))).go();
    }
  }

  @override
  Future<void> clearAllFavorites() async {
    await _db.delete(_db.favoriteIdioms).go();
  }
}
