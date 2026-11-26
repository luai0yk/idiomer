import 'package:drift/drift.dart';
import 'package:idiomer/core/database/tables/idiom_tables.dart';

/// User-created or category-backed flashcard decks.
class FlashcardGroups extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 100).unique()();

  /// Optional link to the idiom category that auto-created this group.
  TextColumn get categoryId => text().nullable().references(
    Categories,
    #id,
    onDelete: KeyAction.setNull,
    onUpdate: KeyAction.cascade,
  )();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Join table assigning idioms to flashcard groups without duplicates per group.
@TableIndex(name: 'flashcard_group_items_group_idx', columns: {#groupId})
@TableIndex(name: 'flashcard_group_items_idiom_idx', columns: {#idiomId})
class FlashcardGroupItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get groupId => integer().references(
    FlashcardGroups,
    #id,
    onDelete: KeyAction.cascade,
    onUpdate: KeyAction.cascade,
  )();

  IntColumn get idiomId => integer().references(
    Idioms,
    #id,
    onDelete: KeyAction.cascade,
    onUpdate: KeyAction.cascade,
  )();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {groupId, idiomId},
  ];
}
