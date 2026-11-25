import 'package:drift/drift.dart';

/// Supported UI/content languages stored in `languages`.
class Languages extends Table {
  TextColumn get code => text()();
  TextColumn get name => text()();
  TextColumn get direction => text()();

  @override
  Set<Column<Object>> get primaryKey => {code};
}

/// Idiom categories ordered by `display_order`.
class Categories extends Table {
  TextColumn get id => text()();
  IntColumn get displayOrder => integer().unique()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Localized category names and descriptions.
class CategoryTranslations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get categoryId => text().references(
    Categories,
    #id,
    onDelete: KeyAction.cascade,
    onUpdate: KeyAction.cascade,
  )();
  TextColumn get languageCode => text().references(
    Languages,
    #code,
    onDelete: KeyAction.restrict,
    onUpdate: KeyAction.cascade,
  )();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {categoryId, languageCode},
    {languageCode, name},
  ];
}

/// Root idiom records.
class Idioms extends Table {
  IntColumn get id => integer()();
  TextColumn get slug => text().nullable().unique()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Localized idiom text and optional usage notes.
class IdiomTranslations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idiomId => integer().references(
    Idioms,
    #id,
    onDelete: KeyAction.cascade,
    onUpdate: KeyAction.cascade,
  )();
  TextColumn get languageCode => text().references(
    Languages,
    #code,
    onDelete: KeyAction.restrict,
    onUpdate: KeyAction.cascade,
  )();
  TextColumn get textValue => text().named('text')();
  TextColumn get notes => text().nullable()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {idiomId, languageCode},
  ];
}

/// Ordered definitions belonging to an idiom.
class Definitions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idiomId => integer().references(
    Idioms,
    #id,
    onDelete: KeyAction.cascade,
    onUpdate: KeyAction.cascade,
  )();
  IntColumn get displayOrder => integer().withDefault(const Constant(1))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {idiomId, displayOrder},
  ];
}

/// Localized meanings for a definition.
class DefinitionTranslations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get definitionId => integer().references(
    Definitions,
    #id,
    onDelete: KeyAction.cascade,
    onUpdate: KeyAction.cascade,
  )();
  TextColumn get languageCode => text().references(
    Languages,
    #code,
    onDelete: KeyAction.restrict,
    onUpdate: KeyAction.cascade,
  )();
  TextColumn get meaning => text()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {definitionId, languageCode},
  ];
}

/// Ordered usage examples belonging to an idiom (and optionally a definition).
class Examples extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idiomId => integer().references(
    Idioms,
    #id,
    onDelete: KeyAction.cascade,
    onUpdate: KeyAction.cascade,
  )();
  IntColumn get definitionId => integer().nullable().references(
    Definitions,
    #id,
    onDelete: KeyAction.setNull,
    onUpdate: KeyAction.cascade,
  )();
  IntColumn get displayOrder => integer().withDefault(const Constant(1))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {idiomId, displayOrder},
  ];
}

/// Localized example sentences.
class ExampleTranslations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get exampleId => integer().references(
    Examples,
    #id,
    onDelete: KeyAction.cascade,
    onUpdate: KeyAction.cascade,
  )();
  TextColumn get languageCode => text().references(
    Languages,
    #code,
    onDelete: KeyAction.restrict,
    onUpdate: KeyAction.cascade,
  )();
  TextColumn get sentence => text()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {exampleId, languageCode},
  ];
}

/// Many-to-many join table linking idioms and categories.
class IdiomCategories extends Table {
  IntColumn get idiomId => integer().references(
    Idioms,
    #id,
    onDelete: KeyAction.cascade,
    onUpdate: KeyAction.cascade,
  )();
  TextColumn get categoryId => text().references(
    Categories,
    #id,
    onDelete: KeyAction.cascade,
    onUpdate: KeyAction.cascade,
  )();

  @override
  Set<Column<Object>> get primaryKey => {idiomId, categoryId};
}

/// User-saved favourite idioms persisted inside the local SQLite database.
class FavoriteIdioms extends Table {
  IntColumn get idiomId => integer().references(
    Idioms,
    #id,
    onDelete: KeyAction.cascade,
    onUpdate: KeyAction.cascade,
  )();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {idiomId};
}
