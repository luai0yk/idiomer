import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/core/database/app_database.dart';
import 'package:idiomer/features/idioms/data/datasources/idioms_local_datasource.dart';

Future<void> seedTestDatabase(AppDatabase db) async {
  await db
      .into(db.languages)
      .insert(
        LanguagesCompanion.insert(
          code: 'en',
          name: 'English',
          direction: 'ltr',
        ),
      );
  await db
      .into(db.languages)
      .insert(
        LanguagesCompanion.insert(code: 'ar', name: 'Arabic', direction: 'rtl'),
      );

  await db
      .into(db.categories)
      .insert(CategoriesCompanion.insert(id: 'daily_life', displayOrder: 1));
  await db
      .into(db.categories)
      .insert(CategoriesCompanion.insert(id: 'business', displayOrder: 2));

  await db
      .into(db.categoryTranslations)
      .insert(
        CategoryTranslationsCompanion.insert(
          categoryId: 'daily_life',
          languageCode: 'en',
          name: 'Daily Life',
        ),
      );
  await db
      .into(db.categoryTranslations)
      .insert(
        CategoryTranslationsCompanion.insert(
          categoryId: 'daily_life',
          languageCode: 'ar',
          name: 'الحياة اليومية',
        ),
      );
  await db
      .into(db.categoryTranslations)
      .insert(
        CategoryTranslationsCompanion.insert(
          categoryId: 'business',
          languageCode: 'en',
          name: 'Business',
        ),
      );
  await db
      .into(db.categoryTranslations)
      .insert(
        CategoryTranslationsCompanion.insert(
          categoryId: 'business',
          languageCode: 'ar',
          name: 'الأعمال والتجارة',
        ),
      );

  await db
      .into(db.idioms)
      .insert(
        IdiomsCompanion.insert(
          id: const Value(1),
          slug: const Value('break-the-ice'),
        ),
      );
  await db
      .into(db.idioms)
      .insert(
        IdiomsCompanion.insert(
          id: const Value(2),
          slug: const Value('call-it-a-day'),
        ),
      );

  await db
      .into(db.idiomTranslations)
      .insert(
        IdiomTranslationsCompanion.insert(
          idiomId: 1,
          languageCode: 'en',
          textValue: 'Break the ice',
          notes: const Value('Often used at social gatherings.'),
        ),
      );
  await db
      .into(db.idiomTranslations)
      .insert(
        IdiomTranslationsCompanion.insert(
          idiomId: 1,
          languageCode: 'ar',
          textValue: 'يكسر الجليد',
          notes: const Value('يُستخدم غالباً في اللقاءات الأولى.'),
        ),
      );
  await db
      .into(db.idiomTranslations)
      .insert(
        IdiomTranslationsCompanion.insert(
          idiomId: 2,
          languageCode: 'en',
          textValue: 'Call it a day',
        ),
      );
  await db
      .into(db.idiomTranslations)
      .insert(
        IdiomTranslationsCompanion.insert(
          idiomId: 2,
          languageCode: 'ar',
          textValue: 'ينهي العمل لهذا اليوم',
        ),
      );

  final def1 = await db
      .into(db.definitions)
      .insert(DefinitionsCompanion.insert(idiomId: 1));
  final def2 = await db
      .into(db.definitions)
      .insert(DefinitionsCompanion.insert(idiomId: 2));

  await db
      .into(db.definitionTranslations)
      .insert(
        DefinitionTranslationsCompanion.insert(
          definitionId: def1,
          languageCode: 'en',
          meaning: 'To start a friendly conversation and relieve tension.',
        ),
      );
  await db
      .into(db.definitionTranslations)
      .insert(
        DefinitionTranslationsCompanion.insert(
          definitionId: def1,
          languageCode: 'ar',
          meaning: 'بدء حديث ودّي وإزالة التوتر.',
        ),
      );
  await db
      .into(db.definitionTranslations)
      .insert(
        DefinitionTranslationsCompanion.insert(
          definitionId: def2,
          languageCode: 'en',
          meaning: 'To stop working for the rest of the day.',
        ),
      );
  await db
      .into(db.definitionTranslations)
      .insert(
        DefinitionTranslationsCompanion.insert(
          definitionId: def2,
          languageCode: 'ar',
          meaning: 'التوقف عن العمل لبقية اليوم.',
        ),
      );

  final ex1 = await db
      .into(db.examples)
      .insert(ExamplesCompanion.insert(idiomId: 1, definitionId: Value(def1)));
  final ex2 = await db
      .into(db.examples)
      .insert(ExamplesCompanion.insert(idiomId: 2, definitionId: Value(def2)));

  await db
      .into(db.exampleTranslations)
      .insert(
        ExampleTranslationsCompanion.insert(
          exampleId: ex1,
          languageCode: 'en',
          sentence: 'She told a joke to break the ice.',
        ),
      );
  await db
      .into(db.exampleTranslations)
      .insert(
        ExampleTranslationsCompanion.insert(
          exampleId: ex1,
          languageCode: 'ar',
          sentence: 'ألقت مزحة لكسر الجليد.',
        ),
      );
  await db
      .into(db.exampleTranslations)
      .insert(
        ExampleTranslationsCompanion.insert(
          exampleId: ex2,
          languageCode: 'en',
          sentence: 'We finished the report and decided to call it a day.',
        ),
      );
  await db
      .into(db.exampleTranslations)
      .insert(
        ExampleTranslationsCompanion.insert(
          exampleId: ex2,
          languageCode: 'ar',
          sentence: 'أنهينا التقرير وقررنا إنهاء العمل لهذا اليوم.',
        ),
      );

  await db
      .into(db.idiomCategories)
      .insert(
        IdiomCategoriesCompanion.insert(idiomId: 1, categoryId: 'daily_life'),
      );
  await db
      .into(db.idiomCategories)
      .insert(
        IdiomCategoriesCompanion.insert(idiomId: 2, categoryId: 'business'),
      );
}

void main() {
  late AppDatabase db;
  late IdiomsLocalDataSourceImpl dataSource;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await seedTestDatabase(db);
    dataSource = IdiomsLocalDataSourceImpl(database: db);
  });

  tearDown(() async {
    await db.close();
  });

  test('verifyReady returns true for seeded database', () async {
    expect(await db.verifyReady(), isTrue);
  });

  test(
    'watchCategories returns localized categories in displayOrder',
    () async {
      final categories = await dataSource.watchCategories().first;

      expect(categories.length, 2);
      expect(categories[0].id, 'daily_life');
      expect(categories[0].englishName, 'Daily Life');
      expect(categories[0].arabicName, 'الحياة اليومية');
      expect(categories[1].id, 'business');
    },
  );

  test('watchIdioms filters by search query and category', () async {
    final all = await dataSource.watchIdioms().first;
    expect(all.length, 2);

    final searchedEn = await dataSource.watchIdioms(query: 'joke').first;
    expect(searchedEn.length, 1);
    expect(searchedEn.first.englishText, 'Break the ice');

    final searchedAr = await dataSource.watchIdioms(query: 'الجليد').first;
    expect(searchedAr.length, 1);
    expect(searchedAr.first.id, 1);

    final byCategory = await dataSource
        .watchIdioms(categoryId: 'business')
        .first;
    expect(byCategory.length, 1);
    expect(byCategory.first.id, 2);
  });

  test('favorite mutations update reactive streams immediately', () async {
    final initialFavs = await dataSource.watchIdioms(favoritesOnly: true).first;
    expect(initialFavs, isEmpty);

    await dataSource.toggleFavorite(1);
    final afterAdd = await dataSource.watchIdioms(favoritesOnly: true).first;
    expect(afterAdd.length, 1);
    expect(afterAdd.first.id, 1);
    expect(afterAdd.first.isFavorite, isTrue);

    final detail = await dataSource.watchIdiomDetail(1).first;
    expect(detail, isNotNull);
    expect(detail!.isFavorite, isTrue);
    expect(detail.definitions.length, 1);
    expect(detail.examples.length, 1);
    expect(detail.categories.length, 1);
    expect(detail.englishNotes, isNotNull);

    await dataSource.clearAllFavorites();
    final afterClear = await dataSource.watchIdioms(favoritesOnly: true).first;
    expect(afterClear, isEmpty);
  });

  test(
    'watchIdiomOfTheDay returns deterministic idiom and updates favorite',
    () async {
      final day1 = DateTime(2026, 11, 25);
      final first = await dataSource.watchIdiomOfTheDay(date: day1).first;
      final repeat = await dataSource.watchIdiomOfTheDay(date: day1).first;
      expect(first, isNotNull);
      expect(first!.id, repeat!.id);

      await dataSource.toggleFavorite(first.id);
      final updated = await dataSource.watchIdiomOfTheDay(date: day1).first;
      expect(updated?.isFavorite, isTrue);
    },
  );
}
