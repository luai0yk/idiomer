import 'package:drift/drift.dart';
import 'package:idiomer/core/database/app_database.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_assignment_result.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/idioms/data/datasources/idioms_local_datasource.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_entity.dart';

class DuplicateFlashcardGroupException implements Exception {
  final String name;

  const DuplicateFlashcardGroupException(this.name);

  @override
  String toString() => 'DuplicateFlashcardGroupException: $name';
}

class EmptyFlashcardGroupNameException implements Exception {
  const EmptyFlashcardGroupNameException();
}

abstract class FlashcardsLocalDataSource {
  Stream<List<FlashcardGroupEntity>> watchGroups();

  Stream<FlashcardGroupEntity?> watchGroup(int groupId);

  Stream<List<IdiomEntity>> watchGroupIdioms(int groupId);

  Future<List<IdiomDetailEntity>> getGroupStudyCards(int groupId);

  Stream<List<FlashcardGroupEntity>> watchGroupsForIdiom(int idiomId);

  Future<FlashcardGroupEntity> createGroup({
    required String name,
    String? categoryId,
  });

  Future<void> renameGroup({required int groupId, required String newName});

  Future<void> deleteGroup(int groupId);

  Future<void> clearAllGroups();

  Future<bool> addIdiomToGroup({required int groupId, required int idiomId});

  Future<FlashcardAssignmentResult> addIdiomToDefaultCategoryGroup({
    required int idiomId,
    required String groupName,
    String? categoryId,
  });

  Future<void> moveIdiomToGroup({
    required int idiomId,
    required int fromGroupId,
    required int toGroupId,
  });

  Future<void> removeIdiomFromGroup({
    required int groupId,
    required int idiomId,
  });
}

class FlashcardsLocalDataSourceImpl implements FlashcardsLocalDataSource {
  final AppDatabase _db;
  final IdiomsLocalDataSource _idiomsLocalDataSource;

  const FlashcardsLocalDataSourceImpl({
    required AppDatabase database,
    required IdiomsLocalDataSource idiomsLocalDataSource,
  }) : _db = database,
       _idiomsLocalDataSource = idiomsLocalDataSource;

  @override
  Stream<List<FlashcardGroupEntity>> watchGroups() {
    final countExpr = _db.flashcardGroupItems.id.count();

    final query =
        _db.select(_db.flashcardGroups).join([
            leftOuterJoin(
              _db.flashcardGroupItems,
              _db.flashcardGroupItems.groupId.equalsExp(_db.flashcardGroups.id),
            ),
          ])
          ..addColumns([countExpr])
          ..groupBy([_db.flashcardGroups.id])
          ..orderBy([
            OrderingTerm.desc(_db.flashcardGroups.updatedAt),
            OrderingTerm.asc(_db.flashcardGroups.name),
          ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final group = row.readTable(_db.flashcardGroups);
        final count = row.read(countExpr) ?? 0;
        return _mapGroup(group, count);
      }).toList();
    });
  }

  @override
  Stream<FlashcardGroupEntity?> watchGroup(int groupId) {
    final countExpr = _db.flashcardGroupItems.id.count();

    final query =
        _db.select(_db.flashcardGroups).join([
            leftOuterJoin(
              _db.flashcardGroupItems,
              _db.flashcardGroupItems.groupId.equalsExp(_db.flashcardGroups.id),
            ),
          ])
          ..addColumns([countExpr])
          ..where(_db.flashcardGroups.id.equals(groupId))
          ..groupBy([_db.flashcardGroups.id]);

    return query.watchSingleOrNull().map((row) {
      if (row == null) return null;
      final group = row.readTable(_db.flashcardGroups);
      final count = row.read(countExpr) ?? 0;
      return _mapGroup(group, count);
    });
  }

  @override
  Stream<List<IdiomEntity>> watchGroupIdioms(int groupId) {
    final itEn = _db.alias(_db.idiomTranslations, 'it_en');
    final itAr = _db.alias(_db.idiomTranslations, 'it_ar');
    final exFirst = _db.alias(_db.examples, 'ex_first');
    final etEn = _db.alias(_db.exampleTranslations, 'et_en');
    final etAr = _db.alias(_db.exampleTranslations, 'et_ar');

    final query =
        _db.select(_db.flashcardGroupItems).join([
            innerJoin(
              _db.idioms,
              _db.idioms.id.equalsExp(_db.flashcardGroupItems.idiomId),
            ),
            leftOuterJoin(
              itEn,
              itEn.idiomId.equalsExp(_db.idioms.id) &
                  itEn.languageCode.equals('en'),
            ),
            leftOuterJoin(
              itAr,
              itAr.idiomId.equalsExp(_db.idioms.id) &
                  itAr.languageCode.equals('ar'),
            ),
            leftOuterJoin(
              exFirst,
              exFirst.idiomId.equalsExp(_db.idioms.id) &
                  exFirst.displayOrder.equals(1),
            ),
            leftOuterJoin(
              etEn,
              etEn.exampleId.equalsExp(exFirst.id) &
                  etEn.languageCode.equals('en'),
            ),
            leftOuterJoin(
              etAr,
              etAr.exampleId.equalsExp(exFirst.id) &
                  etAr.languageCode.equals('ar'),
            ),
            leftOuterJoin(
              _db.favoriteIdioms,
              _db.favoriteIdioms.idiomId.equalsExp(_db.idioms.id),
            ),
          ])
          ..where(_db.flashcardGroupItems.groupId.equals(groupId))
          ..orderBy([
            OrderingTerm.desc(_db.flashcardGroupItems.createdAt),
            OrderingTerm.asc(itEn.textValue),
          ]);

    return query.watch().map((rows) {
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
  Future<List<IdiomDetailEntity>> getGroupStudyCards(int groupId) async {
    final items =
        await (_db.select(_db.flashcardGroupItems)
              ..where((t) => t.groupId.equals(groupId))
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
            .get();

    final cards = <IdiomDetailEntity>[];
    for (final item in items) {
      final detail = await _idiomsLocalDataSource
          .watchIdiomDetail(item.idiomId)
          .first;
      if (detail != null) {
        cards.add(detail);
      }
    }
    return cards;
  }

  @override
  Stream<List<FlashcardGroupEntity>> watchGroupsForIdiom(int idiomId) {
    final query =
        _db.select(_db.flashcardGroups).join([
          innerJoin(
            _db.flashcardGroupItems,
            _db.flashcardGroupItems.groupId.equalsExp(_db.flashcardGroups.id) &
                _db.flashcardGroupItems.idiomId.equals(idiomId),
            useColumns: false,
          ),
        ])..orderBy([
          OrderingTerm.desc(_db.flashcardGroups.updatedAt),
          OrderingTerm.asc(_db.flashcardGroups.name),
        ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final group = row.readTable(_db.flashcardGroups);
        return _mapGroup(group, 0);
      }).toList();
    });
  }

  @override
  Future<FlashcardGroupEntity> createGroup({
    required String name,
    String? categoryId,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw const EmptyFlashcardGroupNameException();
    }

    return _db.transaction(() async {
      final existing = await _findGroupByNameIgnoreCase(trimmed);
      if (existing != null) {
        throw DuplicateFlashcardGroupException(trimmed);
      }

      final now = DateTime.now();
      final id = await _db
          .into(_db.flashcardGroups)
          .insert(
            FlashcardGroupsCompanion.insert(
              name: trimmed,
              categoryId: Value(categoryId),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      final created = await (_db.select(
        _db.flashcardGroups,
      )..where((t) => t.id.equals(id))).getSingle();
      return _mapGroup(created, 0);
    });
  }

  @override
  Future<void> renameGroup({
    required int groupId,
    required String newName,
  }) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) {
      throw const EmptyFlashcardGroupNameException();
    }

    await _db.transaction(() async {
      final existing = await _findGroupByNameIgnoreCase(trimmed);
      if (existing != null && existing.id != groupId) {
        throw DuplicateFlashcardGroupException(trimmed);
      }

      await (_db.update(
        _db.flashcardGroups,
      )..where((t) => t.id.equals(groupId))).write(
        FlashcardGroupsCompanion(
          name: Value(trimmed),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  @override
  Future<void> deleteGroup(int groupId) async {
    await (_db.delete(
      _db.flashcardGroups,
    )..where((t) => t.id.equals(groupId))).go();
  }

  @override
  Future<void> clearAllGroups() async {
    await _db.transaction(() async {
      await _db.delete(_db.flashcardGroupItems).go();
      await _db.delete(_db.flashcardGroups).go();
    });
  }

  @override
  Future<bool> addIdiomToGroup({
    required int groupId,
    required int idiomId,
  }) async {
    return _db.transaction(() async {
      final existing =
          await (_db.select(_db.flashcardGroupItems)..where(
                (t) => t.groupId.equals(groupId) & t.idiomId.equals(idiomId),
              ))
              .getSingleOrNull();

      if (existing != null) {
        return false;
      }

      await _db
          .into(_db.flashcardGroupItems)
          .insert(
            FlashcardGroupItemsCompanion.insert(
              groupId: groupId,
              idiomId: idiomId,
            ),
          );
      await _touchGroup(groupId);
      return true;
    });
  }

  @override
  Future<FlashcardAssignmentResult> addIdiomToDefaultCategoryGroup({
    required int idiomId,
    required String groupName,
    String? categoryId,
  }) async {
    final resolvedName = groupName.trim().isEmpty
        ? 'General'
        : groupName.trim();

    return _db.transaction(() async {
      FlashcardGroup? group;

      if (categoryId != null && categoryId.isNotEmpty) {
        group = await (_db.select(
          _db.flashcardGroups,
        )..where((t) => t.categoryId.equals(categoryId))).getSingleOrNull();
      }

      group ??= await _findGroupByNameIgnoreCase(resolvedName);

      if (group == null) {
        final now = DateTime.now();
        final newGroupId = await _db
            .into(_db.flashcardGroups)
            .insert(
              FlashcardGroupsCompanion.insert(
                name: resolvedName,
                categoryId: Value(categoryId),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
        group = await (_db.select(
          _db.flashcardGroups,
        )..where((t) => t.id.equals(newGroupId))).getSingle();
      }

      final existingItem =
          await (_db.select(_db.flashcardGroupItems)..where(
                (t) => t.groupId.equals(group!.id) & t.idiomId.equals(idiomId),
              ))
              .getSingleOrNull();

      var wasAdded = false;
      if (existingItem == null) {
        await _db
            .into(_db.flashcardGroupItems)
            .insert(
              FlashcardGroupItemsCompanion.insert(
                groupId: group.id,
                idiomId: idiomId,
              ),
            );
        await _touchGroup(group.id);
        wasAdded = true;
      }

      final count = await _countGroupItems(group.id);
      return FlashcardAssignmentResult(
        group: _mapGroup(group, count),
        wasAdded: wasAdded,
      );
    });
  }

  @override
  Future<void> moveIdiomToGroup({
    required int idiomId,
    required int fromGroupId,
    required int toGroupId,
  }) async {
    if (fromGroupId == toGroupId) return;

    await _db.transaction(() async {
      final targetExisting =
          await (_db.select(_db.flashcardGroupItems)..where(
                (t) => t.groupId.equals(toGroupId) & t.idiomId.equals(idiomId),
              ))
              .getSingleOrNull();

      if (targetExisting == null) {
        await _db
            .into(_db.flashcardGroupItems)
            .insert(
              FlashcardGroupItemsCompanion.insert(
                groupId: toGroupId,
                idiomId: idiomId,
              ),
            );
      }

      await (_db.delete(_db.flashcardGroupItems)..where(
            (t) => t.groupId.equals(fromGroupId) & t.idiomId.equals(idiomId),
          ))
          .go();

      await _touchGroup(fromGroupId);
      await _touchGroup(toGroupId);
    });
  }

  @override
  Future<void> removeIdiomFromGroup({
    required int groupId,
    required int idiomId,
  }) async {
    await _db.transaction(() async {
      await (_db.delete(_db.flashcardGroupItems)..where(
            (t) => t.groupId.equals(groupId) & t.idiomId.equals(idiomId),
          ))
          .go();
      await _touchGroup(groupId);
    });
  }

  Future<FlashcardGroup?> _findGroupByNameIgnoreCase(String name) {
    final normalized = name.trim().toLowerCase();
    return (_db.select(
      _db.flashcardGroups,
    )..where((t) => t.name.lower().equals(normalized))).getSingleOrNull();
  }

  Future<void> _touchGroup(int groupId) async {
    await (_db.update(_db.flashcardGroups)..where((t) => t.id.equals(groupId)))
        .write(FlashcardGroupsCompanion(updatedAt: Value(DateTime.now())));
  }

  Future<int> _countGroupItems(int groupId) async {
    final countExpr = _db.flashcardGroupItems.id.count();
    final row =
        await (_db.selectOnly(_db.flashcardGroupItems)
              ..addColumns([countExpr])
              ..where(_db.flashcardGroupItems.groupId.equals(groupId)))
            .getSingle();
    return row.read(countExpr) ?? 0;
  }

  FlashcardGroupEntity _mapGroup(FlashcardGroup row, int count) {
    return FlashcardGroupEntity(
      id: row.id,
      name: row.name,
      categoryId: row.categoryId,
      idiomCount: count,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
