import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/core/database/app_database.dart';
import 'package:idiomer/features/flashcards/data/datasources/flashcards_local_datasource.dart';
import 'package:idiomer/features/idioms/data/datasources/idioms_local_datasource.dart';

import '../idioms/idioms_local_datasource_test.dart';

void main() {
  late AppDatabase db;
  late IdiomsLocalDataSourceImpl idiomsDataSource;
  late FlashcardsLocalDataSourceImpl flashcardsDataSource;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await seedTestDatabase(db);
    idiomsDataSource = IdiomsLocalDataSourceImpl(database: db);
    flashcardsDataSource = FlashcardsLocalDataSourceImpl(
      database: db,
      idiomsLocalDataSource: idiomsDataSource,
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('supports group CRUD and prevents duplicate group names', () async {
    final created = await flashcardsDataSource.createGroup(name: 'Daily Life');
    expect(created.name, 'Daily Life');
    expect(created.idiomCount, 0);

    await expectLater(
      () => flashcardsDataSource.createGroup(name: '  daily life  '),
      throwsA(isA<DuplicateFlashcardGroupException>()),
    );

    await flashcardsDataSource.renameGroup(
      groupId: created.id,
      newName: 'Social Idioms',
    );
    final updated = await flashcardsDataSource.watchGroup(created.id).first;
    expect(updated?.name, 'Social Idioms');

    await flashcardsDataSource.deleteGroup(created.id);
    final afterDelete = await flashcardsDataSource.watchGroups().first;
    expect(afterDelete, isEmpty);
  });

  test(
    'prevents duplicate idiom entries within the same group at both app and DB levels',
    () async {
      final group = await flashcardsDataSource.createGroup(name: 'Work');
      final otherGroup = await flashcardsDataSource.createGroup(name: 'Travel');

      final firstInsert = await flashcardsDataSource.addIdiomToGroup(
        groupId: group.id,
        idiomId: 1,
      );
      expect(firstInsert, isTrue);

      // Datasource ignores duplicate gracefully and keeps count at 1.
      final duplicateInsert = await flashcardsDataSource.addIdiomToGroup(
        groupId: group.id,
        idiomId: 1,
      );
      expect(duplicateInsert, isFalse);

      final idiomsInGroup = await flashcardsDataSource
          .watchGroupIdioms(group.id)
          .first;
      expect(idiomsInGroup.length, 1);

      // Raw Drift insert also fails due to UNIQUE(group_id, idiom_id).
      await expectLater(
        () => db
            .into(db.flashcardGroupItems)
            .insert(
              FlashcardGroupItemsCompanion.insert(
                groupId: group.id,
                idiomId: 1,
              ),
            ),
        throwsException,
      );

      // Same idiom CAN be added to a different group.
      final insertOther = await flashcardsDataSource.addIdiomToGroup(
        groupId: otherGroup.id,
        idiomId: 1,
      );
      expect(insertOther, isTrue);
    },
  );

  test(
    'addIdiomToDefaultCategoryGroup creates category group if missing and avoids duplicates',
    () async {
      final first = await flashcardsDataSource.addIdiomToDefaultCategoryGroup(
        idiomId: 1,
        groupName: 'Daily Life',
        categoryId: 'daily_life',
      );
      expect(first.wasAdded, isTrue);
      expect(first.group.name, 'Daily Life');
      expect(first.group.categoryId, 'daily_life');
      expect(first.group.idiomCount, 1);

      final second = await flashcardsDataSource.addIdiomToDefaultCategoryGroup(
        idiomId: 1,
        groupName: 'Daily Life',
        categoryId: 'daily_life',
      );
      expect(second.wasAdded, isFalse);
      expect(second.group.id, first.group.id);
      expect(second.group.idiomCount, 1);
    },
  );

  test('moveIdiomToGroup moves idiom without creating duplicates', () async {
    final source = await flashcardsDataSource.createGroup(name: 'Source');
    final target = await flashcardsDataSource.createGroup(name: 'Target');

    await flashcardsDataSource.addIdiomToGroup(groupId: source.id, idiomId: 1);
    await flashcardsDataSource.addIdiomToGroup(groupId: source.id, idiomId: 2);
    // Pre-populate target with idiom 2 to verify deduplication on move.
    await flashcardsDataSource.addIdiomToGroup(groupId: target.id, idiomId: 2);

    await flashcardsDataSource.moveIdiomToGroup(
      idiomId: 2,
      fromGroupId: source.id,
      toGroupId: target.id,
    );

    final sourceIdioms = await flashcardsDataSource
        .watchGroupIdioms(source.id)
        .first;
    final targetIdioms = await flashcardsDataSource
        .watchGroupIdioms(target.id)
        .first;

    expect(sourceIdioms.map((e) => e.id).toList(), [1]);
    expect(targetIdioms.map((e) => e.id).toList(), [2]);
  });

  test('clearAllGroups removes all flashcard groups and items', () async {
    final g1 = await flashcardsDataSource.createGroup(name: 'Group 1');
    final g2 = await flashcardsDataSource.createGroup(name: 'Group 2');
    await flashcardsDataSource.addIdiomToGroup(groupId: g1.id, idiomId: 1);
    await flashcardsDataSource.addIdiomToGroup(groupId: g2.id, idiomId: 2);

    await flashcardsDataSource.clearAllGroups();

    expect(await flashcardsDataSource.watchGroups().first, isEmpty);
    expect(await flashcardsDataSource.watchGroupIdioms(g1.id).first, isEmpty);
  });
}
