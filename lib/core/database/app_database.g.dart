// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LanguagesTable extends Languages
    with TableInfo<$LanguagesTable, Language> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LanguagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [code, name, direction];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'languages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Language> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  Language map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Language(
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
    );
  }

  @override
  $LanguagesTable createAlias(String alias) {
    return $LanguagesTable(attachedDatabase, alias);
  }
}

class Language extends DataClass implements Insertable<Language> {
  final String code;
  final String name;
  final String direction;
  const Language({
    required this.code,
    required this.name,
    required this.direction,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['direction'] = Variable<String>(direction);
    return map;
  }

  LanguagesCompanion toCompanion(bool nullToAbsent) {
    return LanguagesCompanion(
      code: Value(code),
      name: Value(name),
      direction: Value(direction),
    );
  }

  factory Language.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Language(
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      direction: serializer.fromJson<String>(json['direction']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'direction': serializer.toJson<String>(direction),
    };
  }

  Language copyWith({String? code, String? name, String? direction}) =>
      Language(
        code: code ?? this.code,
        name: name ?? this.name,
        direction: direction ?? this.direction,
      );
  Language copyWithCompanion(LanguagesCompanion data) {
    return Language(
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      direction: data.direction.present ? data.direction.value : this.direction,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Language(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('direction: $direction')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, name, direction);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Language &&
          other.code == this.code &&
          other.name == this.name &&
          other.direction == this.direction);
}

class LanguagesCompanion extends UpdateCompanion<Language> {
  final Value<String> code;
  final Value<String> name;
  final Value<String> direction;
  final Value<int> rowid;
  const LanguagesCompanion({
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.direction = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LanguagesCompanion.insert({
    required String code,
    required String name,
    required String direction,
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       name = Value(name),
       direction = Value(direction);
  static Insertable<Language> custom({
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? direction,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (direction != null) 'direction': direction,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LanguagesCompanion copyWith({
    Value<String>? code,
    Value<String>? name,
    Value<String>? direction,
    Value<int>? rowid,
  }) {
    return LanguagesCompanion(
      code: code ?? this.code,
      name: name ?? this.name,
      direction: direction ?? this.direction,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LanguagesCompanion(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('direction: $direction, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, displayOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final int displayOrder;
  const Category({required this.id, required this.displayOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      displayOrder: Value(displayOrder),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  Category copyWith({String? id, int? displayOrder}) => Category(
    id: id ?? this.id,
    displayOrder: displayOrder ?? this.displayOrder,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, displayOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.displayOrder == this.displayOrder);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<int> displayOrder;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required int displayOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       displayOrder = Value(displayOrder);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<int>? displayOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayOrder != null) 'display_order': displayOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<int>? displayOrder,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      displayOrder: displayOrder ?? this.displayOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoryTranslationsTable extends CategoryTranslations
    with TableInfo<$CategoryTranslationsTable, CategoryTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryTranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES languages (code) ON UPDATE CASCADE ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    languageCode,
    name,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryTranslation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {categoryId, languageCode},
    {languageCode, name},
  ];
  @override
  CategoryTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryTranslation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $CategoryTranslationsTable createAlias(String alias) {
    return $CategoryTranslationsTable(attachedDatabase, alias);
  }
}

class CategoryTranslation extends DataClass
    implements Insertable<CategoryTranslation> {
  final int id;
  final String categoryId;
  final String languageCode;
  final String name;
  final String? description;
  const CategoryTranslation({
    required this.id,
    required this.categoryId,
    required this.languageCode,
    required this.name,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<String>(categoryId);
    map['language_code'] = Variable<String>(languageCode);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  CategoryTranslationsCompanion toCompanion(bool nullToAbsent) {
    return CategoryTranslationsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      languageCode: Value(languageCode),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory CategoryTranslation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryTranslation(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<String>(categoryId),
      'languageCode': serializer.toJson<String>(languageCode),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
    };
  }

  CategoryTranslation copyWith({
    int? id,
    String? categoryId,
    String? languageCode,
    String? name,
    Value<String?> description = const Value.absent(),
  }) => CategoryTranslation(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    languageCode: languageCode ?? this.languageCode,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
  );
  CategoryTranslation copyWithCompanion(CategoryTranslationsCompanion data) {
    return CategoryTranslation(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTranslation(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('languageCode: $languageCode, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, categoryId, languageCode, name, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryTranslation &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.languageCode == this.languageCode &&
          other.name == this.name &&
          other.description == this.description);
}

class CategoryTranslationsCompanion
    extends UpdateCompanion<CategoryTranslation> {
  final Value<int> id;
  final Value<String> categoryId;
  final Value<String> languageCode;
  final Value<String> name;
  final Value<String?> description;
  const CategoryTranslationsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
  });
  CategoryTranslationsCompanion.insert({
    this.id = const Value.absent(),
    required String categoryId,
    required String languageCode,
    required String name,
    this.description = const Value.absent(),
  }) : categoryId = Value(categoryId),
       languageCode = Value(languageCode),
       name = Value(name);
  static Insertable<CategoryTranslation> custom({
    Expression<int>? id,
    Expression<String>? categoryId,
    Expression<String>? languageCode,
    Expression<String>? name,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (languageCode != null) 'language_code': languageCode,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    });
  }

  CategoryTranslationsCompanion copyWith({
    Value<int>? id,
    Value<String>? categoryId,
    Value<String>? languageCode,
    Value<String>? name,
    Value<String?>? description,
  }) {
    return CategoryTranslationsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      languageCode: languageCode ?? this.languageCode,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTranslationsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('languageCode: $languageCode, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $IdiomsTable extends Idioms with TableInfo<$IdiomsTable, Idiom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IdiomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, slug];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'idioms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Idiom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Idiom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Idiom(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      ),
    );
  }

  @override
  $IdiomsTable createAlias(String alias) {
    return $IdiomsTable(attachedDatabase, alias);
  }
}

class Idiom extends DataClass implements Insertable<Idiom> {
  final int id;
  final String? slug;
  const Idiom({required this.id, this.slug});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || slug != null) {
      map['slug'] = Variable<String>(slug);
    }
    return map;
  }

  IdiomsCompanion toCompanion(bool nullToAbsent) {
    return IdiomsCompanion(
      id: Value(id),
      slug: slug == null && nullToAbsent ? const Value.absent() : Value(slug),
    );
  }

  factory Idiom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Idiom(
      id: serializer.fromJson<int>(json['id']),
      slug: serializer.fromJson<String?>(json['slug']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'slug': serializer.toJson<String?>(slug),
    };
  }

  Idiom copyWith({int? id, Value<String?> slug = const Value.absent()}) =>
      Idiom(id: id ?? this.id, slug: slug.present ? slug.value : this.slug);
  Idiom copyWithCompanion(IdiomsCompanion data) {
    return Idiom(
      id: data.id.present ? data.id.value : this.id,
      slug: data.slug.present ? data.slug.value : this.slug,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Idiom(')
          ..write('id: $id, ')
          ..write('slug: $slug')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, slug);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Idiom && other.id == this.id && other.slug == this.slug);
}

class IdiomsCompanion extends UpdateCompanion<Idiom> {
  final Value<int> id;
  final Value<String?> slug;
  const IdiomsCompanion({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
  });
  IdiomsCompanion.insert({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
  });
  static Insertable<Idiom> custom({
    Expression<int>? id,
    Expression<String>? slug,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slug != null) 'slug': slug,
    });
  }

  IdiomsCompanion copyWith({Value<int>? id, Value<String?>? slug}) {
    return IdiomsCompanion(id: id ?? this.id, slug: slug ?? this.slug);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdiomsCompanion(')
          ..write('id: $id, ')
          ..write('slug: $slug')
          ..write(')'))
        .toString();
  }
}

class $IdiomTranslationsTable extends IdiomTranslations
    with TableInfo<$IdiomTranslationsTable, IdiomTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IdiomTranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idiomIdMeta = const VerificationMeta(
    'idiomId',
  );
  @override
  late final GeneratedColumn<int> idiomId = GeneratedColumn<int>(
    'idiom_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES idioms (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES languages (code) ON UPDATE CASCADE ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _textValueMeta = const VerificationMeta(
    'textValue',
  );
  @override
  late final GeneratedColumn<String> textValue = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idiomId,
    languageCode,
    textValue,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'idiom_translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<IdiomTranslation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('idiom_id')) {
      context.handle(
        _idiomIdMeta,
        idiomId.isAcceptableOrUnknown(data['idiom_id']!, _idiomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_idiomIdMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _textValueMeta,
        textValue.isAcceptableOrUnknown(data['text']!, _textValueMeta),
      );
    } else if (isInserting) {
      context.missing(_textValueMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {idiomId, languageCode},
  ];
  @override
  IdiomTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IdiomTranslation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      idiomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idiom_id'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
      textValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $IdiomTranslationsTable createAlias(String alias) {
    return $IdiomTranslationsTable(attachedDatabase, alias);
  }
}

class IdiomTranslation extends DataClass
    implements Insertable<IdiomTranslation> {
  final int id;
  final int idiomId;
  final String languageCode;
  final String textValue;
  final String? notes;
  const IdiomTranslation({
    required this.id,
    required this.idiomId,
    required this.languageCode,
    required this.textValue,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['idiom_id'] = Variable<int>(idiomId);
    map['language_code'] = Variable<String>(languageCode);
    map['text'] = Variable<String>(textValue);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  IdiomTranslationsCompanion toCompanion(bool nullToAbsent) {
    return IdiomTranslationsCompanion(
      id: Value(id),
      idiomId: Value(idiomId),
      languageCode: Value(languageCode),
      textValue: Value(textValue),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory IdiomTranslation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IdiomTranslation(
      id: serializer.fromJson<int>(json['id']),
      idiomId: serializer.fromJson<int>(json['idiomId']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      textValue: serializer.fromJson<String>(json['textValue']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idiomId': serializer.toJson<int>(idiomId),
      'languageCode': serializer.toJson<String>(languageCode),
      'textValue': serializer.toJson<String>(textValue),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  IdiomTranslation copyWith({
    int? id,
    int? idiomId,
    String? languageCode,
    String? textValue,
    Value<String?> notes = const Value.absent(),
  }) => IdiomTranslation(
    id: id ?? this.id,
    idiomId: idiomId ?? this.idiomId,
    languageCode: languageCode ?? this.languageCode,
    textValue: textValue ?? this.textValue,
    notes: notes.present ? notes.value : this.notes,
  );
  IdiomTranslation copyWithCompanion(IdiomTranslationsCompanion data) {
    return IdiomTranslation(
      id: data.id.present ? data.id.value : this.id,
      idiomId: data.idiomId.present ? data.idiomId.value : this.idiomId,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      textValue: data.textValue.present ? data.textValue.value : this.textValue,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IdiomTranslation(')
          ..write('id: $id, ')
          ..write('idiomId: $idiomId, ')
          ..write('languageCode: $languageCode, ')
          ..write('textValue: $textValue, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idiomId, languageCode, textValue, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IdiomTranslation &&
          other.id == this.id &&
          other.idiomId == this.idiomId &&
          other.languageCode == this.languageCode &&
          other.textValue == this.textValue &&
          other.notes == this.notes);
}

class IdiomTranslationsCompanion extends UpdateCompanion<IdiomTranslation> {
  final Value<int> id;
  final Value<int> idiomId;
  final Value<String> languageCode;
  final Value<String> textValue;
  final Value<String?> notes;
  const IdiomTranslationsCompanion({
    this.id = const Value.absent(),
    this.idiomId = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.textValue = const Value.absent(),
    this.notes = const Value.absent(),
  });
  IdiomTranslationsCompanion.insert({
    this.id = const Value.absent(),
    required int idiomId,
    required String languageCode,
    required String textValue,
    this.notes = const Value.absent(),
  }) : idiomId = Value(idiomId),
       languageCode = Value(languageCode),
       textValue = Value(textValue);
  static Insertable<IdiomTranslation> custom({
    Expression<int>? id,
    Expression<int>? idiomId,
    Expression<String>? languageCode,
    Expression<String>? textValue,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idiomId != null) 'idiom_id': idiomId,
      if (languageCode != null) 'language_code': languageCode,
      if (textValue != null) 'text': textValue,
      if (notes != null) 'notes': notes,
    });
  }

  IdiomTranslationsCompanion copyWith({
    Value<int>? id,
    Value<int>? idiomId,
    Value<String>? languageCode,
    Value<String>? textValue,
    Value<String?>? notes,
  }) {
    return IdiomTranslationsCompanion(
      id: id ?? this.id,
      idiomId: idiomId ?? this.idiomId,
      languageCode: languageCode ?? this.languageCode,
      textValue: textValue ?? this.textValue,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idiomId.present) {
      map['idiom_id'] = Variable<int>(idiomId.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (textValue.present) {
      map['text'] = Variable<String>(textValue.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdiomTranslationsCompanion(')
          ..write('id: $id, ')
          ..write('idiomId: $idiomId, ')
          ..write('languageCode: $languageCode, ')
          ..write('textValue: $textValue, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $DefinitionsTable extends Definitions
    with TableInfo<$DefinitionsTable, Definition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DefinitionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idiomIdMeta = const VerificationMeta(
    'idiomId',
  );
  @override
  late final GeneratedColumn<int> idiomId = GeneratedColumn<int>(
    'idiom_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES idioms (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [id, idiomId, displayOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'definitions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Definition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('idiom_id')) {
      context.handle(
        _idiomIdMeta,
        idiomId.isAcceptableOrUnknown(data['idiom_id']!, _idiomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_idiomIdMeta);
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {idiomId, displayOrder},
  ];
  @override
  Definition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Definition(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      idiomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idiom_id'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
    );
  }

  @override
  $DefinitionsTable createAlias(String alias) {
    return $DefinitionsTable(attachedDatabase, alias);
  }
}

class Definition extends DataClass implements Insertable<Definition> {
  final int id;
  final int idiomId;
  final int displayOrder;
  const Definition({
    required this.id,
    required this.idiomId,
    required this.displayOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['idiom_id'] = Variable<int>(idiomId);
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  DefinitionsCompanion toCompanion(bool nullToAbsent) {
    return DefinitionsCompanion(
      id: Value(id),
      idiomId: Value(idiomId),
      displayOrder: Value(displayOrder),
    );
  }

  factory Definition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Definition(
      id: serializer.fromJson<int>(json['id']),
      idiomId: serializer.fromJson<int>(json['idiomId']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idiomId': serializer.toJson<int>(idiomId),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  Definition copyWith({int? id, int? idiomId, int? displayOrder}) => Definition(
    id: id ?? this.id,
    idiomId: idiomId ?? this.idiomId,
    displayOrder: displayOrder ?? this.displayOrder,
  );
  Definition copyWithCompanion(DefinitionsCompanion data) {
    return Definition(
      id: data.id.present ? data.id.value : this.id,
      idiomId: data.idiomId.present ? data.idiomId.value : this.idiomId,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Definition(')
          ..write('id: $id, ')
          ..write('idiomId: $idiomId, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idiomId, displayOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Definition &&
          other.id == this.id &&
          other.idiomId == this.idiomId &&
          other.displayOrder == this.displayOrder);
}

class DefinitionsCompanion extends UpdateCompanion<Definition> {
  final Value<int> id;
  final Value<int> idiomId;
  final Value<int> displayOrder;
  const DefinitionsCompanion({
    this.id = const Value.absent(),
    this.idiomId = const Value.absent(),
    this.displayOrder = const Value.absent(),
  });
  DefinitionsCompanion.insert({
    this.id = const Value.absent(),
    required int idiomId,
    this.displayOrder = const Value.absent(),
  }) : idiomId = Value(idiomId);
  static Insertable<Definition> custom({
    Expression<int>? id,
    Expression<int>? idiomId,
    Expression<int>? displayOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idiomId != null) 'idiom_id': idiomId,
      if (displayOrder != null) 'display_order': displayOrder,
    });
  }

  DefinitionsCompanion copyWith({
    Value<int>? id,
    Value<int>? idiomId,
    Value<int>? displayOrder,
  }) {
    return DefinitionsCompanion(
      id: id ?? this.id,
      idiomId: idiomId ?? this.idiomId,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idiomId.present) {
      map['idiom_id'] = Variable<int>(idiomId.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DefinitionsCompanion(')
          ..write('id: $id, ')
          ..write('idiomId: $idiomId, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }
}

class $DefinitionTranslationsTable extends DefinitionTranslations
    with TableInfo<$DefinitionTranslationsTable, DefinitionTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DefinitionTranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _definitionIdMeta = const VerificationMeta(
    'definitionId',
  );
  @override
  late final GeneratedColumn<int> definitionId = GeneratedColumn<int>(
    'definition_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES definitions (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES languages (code) ON UPDATE CASCADE ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _meaningMeta = const VerificationMeta(
    'meaning',
  );
  @override
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
    'meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    definitionId,
    languageCode,
    meaning,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'definition_translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<DefinitionTranslation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('definition_id')) {
      context.handle(
        _definitionIdMeta,
        definitionId.isAcceptableOrUnknown(
          data['definition_id']!,
          _definitionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_definitionIdMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('meaning')) {
      context.handle(
        _meaningMeta,
        meaning.isAcceptableOrUnknown(data['meaning']!, _meaningMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {definitionId, languageCode},
  ];
  @override
  DefinitionTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DefinitionTranslation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      definitionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}definition_id'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
      meaning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning'],
      )!,
    );
  }

  @override
  $DefinitionTranslationsTable createAlias(String alias) {
    return $DefinitionTranslationsTable(attachedDatabase, alias);
  }
}

class DefinitionTranslation extends DataClass
    implements Insertable<DefinitionTranslation> {
  final int id;
  final int definitionId;
  final String languageCode;
  final String meaning;
  const DefinitionTranslation({
    required this.id,
    required this.definitionId,
    required this.languageCode,
    required this.meaning,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['definition_id'] = Variable<int>(definitionId);
    map['language_code'] = Variable<String>(languageCode);
    map['meaning'] = Variable<String>(meaning);
    return map;
  }

  DefinitionTranslationsCompanion toCompanion(bool nullToAbsent) {
    return DefinitionTranslationsCompanion(
      id: Value(id),
      definitionId: Value(definitionId),
      languageCode: Value(languageCode),
      meaning: Value(meaning),
    );
  }

  factory DefinitionTranslation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DefinitionTranslation(
      id: serializer.fromJson<int>(json['id']),
      definitionId: serializer.fromJson<int>(json['definitionId']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      meaning: serializer.fromJson<String>(json['meaning']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'definitionId': serializer.toJson<int>(definitionId),
      'languageCode': serializer.toJson<String>(languageCode),
      'meaning': serializer.toJson<String>(meaning),
    };
  }

  DefinitionTranslation copyWith({
    int? id,
    int? definitionId,
    String? languageCode,
    String? meaning,
  }) => DefinitionTranslation(
    id: id ?? this.id,
    definitionId: definitionId ?? this.definitionId,
    languageCode: languageCode ?? this.languageCode,
    meaning: meaning ?? this.meaning,
  );
  DefinitionTranslation copyWithCompanion(
    DefinitionTranslationsCompanion data,
  ) {
    return DefinitionTranslation(
      id: data.id.present ? data.id.value : this.id,
      definitionId: data.definitionId.present
          ? data.definitionId.value
          : this.definitionId,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DefinitionTranslation(')
          ..write('id: $id, ')
          ..write('definitionId: $definitionId, ')
          ..write('languageCode: $languageCode, ')
          ..write('meaning: $meaning')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, definitionId, languageCode, meaning);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DefinitionTranslation &&
          other.id == this.id &&
          other.definitionId == this.definitionId &&
          other.languageCode == this.languageCode &&
          other.meaning == this.meaning);
}

class DefinitionTranslationsCompanion
    extends UpdateCompanion<DefinitionTranslation> {
  final Value<int> id;
  final Value<int> definitionId;
  final Value<String> languageCode;
  final Value<String> meaning;
  const DefinitionTranslationsCompanion({
    this.id = const Value.absent(),
    this.definitionId = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.meaning = const Value.absent(),
  });
  DefinitionTranslationsCompanion.insert({
    this.id = const Value.absent(),
    required int definitionId,
    required String languageCode,
    required String meaning,
  }) : definitionId = Value(definitionId),
       languageCode = Value(languageCode),
       meaning = Value(meaning);
  static Insertable<DefinitionTranslation> custom({
    Expression<int>? id,
    Expression<int>? definitionId,
    Expression<String>? languageCode,
    Expression<String>? meaning,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (definitionId != null) 'definition_id': definitionId,
      if (languageCode != null) 'language_code': languageCode,
      if (meaning != null) 'meaning': meaning,
    });
  }

  DefinitionTranslationsCompanion copyWith({
    Value<int>? id,
    Value<int>? definitionId,
    Value<String>? languageCode,
    Value<String>? meaning,
  }) {
    return DefinitionTranslationsCompanion(
      id: id ?? this.id,
      definitionId: definitionId ?? this.definitionId,
      languageCode: languageCode ?? this.languageCode,
      meaning: meaning ?? this.meaning,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (definitionId.present) {
      map['definition_id'] = Variable<int>(definitionId.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (meaning.present) {
      map['meaning'] = Variable<String>(meaning.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DefinitionTranslationsCompanion(')
          ..write('id: $id, ')
          ..write('definitionId: $definitionId, ')
          ..write('languageCode: $languageCode, ')
          ..write('meaning: $meaning')
          ..write(')'))
        .toString();
  }
}

class $ExamplesTable extends Examples with TableInfo<$ExamplesTable, Example> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idiomIdMeta = const VerificationMeta(
    'idiomId',
  );
  @override
  late final GeneratedColumn<int> idiomId = GeneratedColumn<int>(
    'idiom_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES idioms (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _definitionIdMeta = const VerificationMeta(
    'definitionId',
  );
  @override
  late final GeneratedColumn<int> definitionId = GeneratedColumn<int>(
    'definition_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES definitions (id) ON UPDATE CASCADE ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idiomId,
    definitionId,
    displayOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'examples';
  @override
  VerificationContext validateIntegrity(
    Insertable<Example> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('idiom_id')) {
      context.handle(
        _idiomIdMeta,
        idiomId.isAcceptableOrUnknown(data['idiom_id']!, _idiomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_idiomIdMeta);
    }
    if (data.containsKey('definition_id')) {
      context.handle(
        _definitionIdMeta,
        definitionId.isAcceptableOrUnknown(
          data['definition_id']!,
          _definitionIdMeta,
        ),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {idiomId, displayOrder},
  ];
  @override
  Example map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Example(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      idiomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idiom_id'],
      )!,
      definitionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}definition_id'],
      ),
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
    );
  }

  @override
  $ExamplesTable createAlias(String alias) {
    return $ExamplesTable(attachedDatabase, alias);
  }
}

class Example extends DataClass implements Insertable<Example> {
  final int id;
  final int idiomId;
  final int? definitionId;
  final int displayOrder;
  const Example({
    required this.id,
    required this.idiomId,
    this.definitionId,
    required this.displayOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['idiom_id'] = Variable<int>(idiomId);
    if (!nullToAbsent || definitionId != null) {
      map['definition_id'] = Variable<int>(definitionId);
    }
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  ExamplesCompanion toCompanion(bool nullToAbsent) {
    return ExamplesCompanion(
      id: Value(id),
      idiomId: Value(idiomId),
      definitionId: definitionId == null && nullToAbsent
          ? const Value.absent()
          : Value(definitionId),
      displayOrder: Value(displayOrder),
    );
  }

  factory Example.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Example(
      id: serializer.fromJson<int>(json['id']),
      idiomId: serializer.fromJson<int>(json['idiomId']),
      definitionId: serializer.fromJson<int?>(json['definitionId']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idiomId': serializer.toJson<int>(idiomId),
      'definitionId': serializer.toJson<int?>(definitionId),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  Example copyWith({
    int? id,
    int? idiomId,
    Value<int?> definitionId = const Value.absent(),
    int? displayOrder,
  }) => Example(
    id: id ?? this.id,
    idiomId: idiomId ?? this.idiomId,
    definitionId: definitionId.present ? definitionId.value : this.definitionId,
    displayOrder: displayOrder ?? this.displayOrder,
  );
  Example copyWithCompanion(ExamplesCompanion data) {
    return Example(
      id: data.id.present ? data.id.value : this.id,
      idiomId: data.idiomId.present ? data.idiomId.value : this.idiomId,
      definitionId: data.definitionId.present
          ? data.definitionId.value
          : this.definitionId,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Example(')
          ..write('id: $id, ')
          ..write('idiomId: $idiomId, ')
          ..write('definitionId: $definitionId, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idiomId, definitionId, displayOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Example &&
          other.id == this.id &&
          other.idiomId == this.idiomId &&
          other.definitionId == this.definitionId &&
          other.displayOrder == this.displayOrder);
}

class ExamplesCompanion extends UpdateCompanion<Example> {
  final Value<int> id;
  final Value<int> idiomId;
  final Value<int?> definitionId;
  final Value<int> displayOrder;
  const ExamplesCompanion({
    this.id = const Value.absent(),
    this.idiomId = const Value.absent(),
    this.definitionId = const Value.absent(),
    this.displayOrder = const Value.absent(),
  });
  ExamplesCompanion.insert({
    this.id = const Value.absent(),
    required int idiomId,
    this.definitionId = const Value.absent(),
    this.displayOrder = const Value.absent(),
  }) : idiomId = Value(idiomId);
  static Insertable<Example> custom({
    Expression<int>? id,
    Expression<int>? idiomId,
    Expression<int>? definitionId,
    Expression<int>? displayOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idiomId != null) 'idiom_id': idiomId,
      if (definitionId != null) 'definition_id': definitionId,
      if (displayOrder != null) 'display_order': displayOrder,
    });
  }

  ExamplesCompanion copyWith({
    Value<int>? id,
    Value<int>? idiomId,
    Value<int?>? definitionId,
    Value<int>? displayOrder,
  }) {
    return ExamplesCompanion(
      id: id ?? this.id,
      idiomId: idiomId ?? this.idiomId,
      definitionId: definitionId ?? this.definitionId,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idiomId.present) {
      map['idiom_id'] = Variable<int>(idiomId.value);
    }
    if (definitionId.present) {
      map['definition_id'] = Variable<int>(definitionId.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamplesCompanion(')
          ..write('id: $id, ')
          ..write('idiomId: $idiomId, ')
          ..write('definitionId: $definitionId, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }
}

class $ExampleTranslationsTable extends ExampleTranslations
    with TableInfo<$ExampleTranslationsTable, ExampleTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExampleTranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _exampleIdMeta = const VerificationMeta(
    'exampleId',
  );
  @override
  late final GeneratedColumn<int> exampleId = GeneratedColumn<int>(
    'example_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES examples (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES languages (code) ON UPDATE CASCADE ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _sentenceMeta = const VerificationMeta(
    'sentence',
  );
  @override
  late final GeneratedColumn<String> sentence = GeneratedColumn<String>(
    'sentence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, exampleId, languageCode, sentence];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'example_translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExampleTranslation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('example_id')) {
      context.handle(
        _exampleIdMeta,
        exampleId.isAcceptableOrUnknown(data['example_id']!, _exampleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exampleIdMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('sentence')) {
      context.handle(
        _sentenceMeta,
        sentence.isAcceptableOrUnknown(data['sentence']!, _sentenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sentenceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {exampleId, languageCode},
  ];
  @override
  ExampleTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExampleTranslation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      exampleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}example_id'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
      sentence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sentence'],
      )!,
    );
  }

  @override
  $ExampleTranslationsTable createAlias(String alias) {
    return $ExampleTranslationsTable(attachedDatabase, alias);
  }
}

class ExampleTranslation extends DataClass
    implements Insertable<ExampleTranslation> {
  final int id;
  final int exampleId;
  final String languageCode;
  final String sentence;
  const ExampleTranslation({
    required this.id,
    required this.exampleId,
    required this.languageCode,
    required this.sentence,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['example_id'] = Variable<int>(exampleId);
    map['language_code'] = Variable<String>(languageCode);
    map['sentence'] = Variable<String>(sentence);
    return map;
  }

  ExampleTranslationsCompanion toCompanion(bool nullToAbsent) {
    return ExampleTranslationsCompanion(
      id: Value(id),
      exampleId: Value(exampleId),
      languageCode: Value(languageCode),
      sentence: Value(sentence),
    );
  }

  factory ExampleTranslation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExampleTranslation(
      id: serializer.fromJson<int>(json['id']),
      exampleId: serializer.fromJson<int>(json['exampleId']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      sentence: serializer.fromJson<String>(json['sentence']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exampleId': serializer.toJson<int>(exampleId),
      'languageCode': serializer.toJson<String>(languageCode),
      'sentence': serializer.toJson<String>(sentence),
    };
  }

  ExampleTranslation copyWith({
    int? id,
    int? exampleId,
    String? languageCode,
    String? sentence,
  }) => ExampleTranslation(
    id: id ?? this.id,
    exampleId: exampleId ?? this.exampleId,
    languageCode: languageCode ?? this.languageCode,
    sentence: sentence ?? this.sentence,
  );
  ExampleTranslation copyWithCompanion(ExampleTranslationsCompanion data) {
    return ExampleTranslation(
      id: data.id.present ? data.id.value : this.id,
      exampleId: data.exampleId.present ? data.exampleId.value : this.exampleId,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      sentence: data.sentence.present ? data.sentence.value : this.sentence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExampleTranslation(')
          ..write('id: $id, ')
          ..write('exampleId: $exampleId, ')
          ..write('languageCode: $languageCode, ')
          ..write('sentence: $sentence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, exampleId, languageCode, sentence);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExampleTranslation &&
          other.id == this.id &&
          other.exampleId == this.exampleId &&
          other.languageCode == this.languageCode &&
          other.sentence == this.sentence);
}

class ExampleTranslationsCompanion extends UpdateCompanion<ExampleTranslation> {
  final Value<int> id;
  final Value<int> exampleId;
  final Value<String> languageCode;
  final Value<String> sentence;
  const ExampleTranslationsCompanion({
    this.id = const Value.absent(),
    this.exampleId = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.sentence = const Value.absent(),
  });
  ExampleTranslationsCompanion.insert({
    this.id = const Value.absent(),
    required int exampleId,
    required String languageCode,
    required String sentence,
  }) : exampleId = Value(exampleId),
       languageCode = Value(languageCode),
       sentence = Value(sentence);
  static Insertable<ExampleTranslation> custom({
    Expression<int>? id,
    Expression<int>? exampleId,
    Expression<String>? languageCode,
    Expression<String>? sentence,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exampleId != null) 'example_id': exampleId,
      if (languageCode != null) 'language_code': languageCode,
      if (sentence != null) 'sentence': sentence,
    });
  }

  ExampleTranslationsCompanion copyWith({
    Value<int>? id,
    Value<int>? exampleId,
    Value<String>? languageCode,
    Value<String>? sentence,
  }) {
    return ExampleTranslationsCompanion(
      id: id ?? this.id,
      exampleId: exampleId ?? this.exampleId,
      languageCode: languageCode ?? this.languageCode,
      sentence: sentence ?? this.sentence,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exampleId.present) {
      map['example_id'] = Variable<int>(exampleId.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (sentence.present) {
      map['sentence'] = Variable<String>(sentence.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExampleTranslationsCompanion(')
          ..write('id: $id, ')
          ..write('exampleId: $exampleId, ')
          ..write('languageCode: $languageCode, ')
          ..write('sentence: $sentence')
          ..write(')'))
        .toString();
  }
}

class $IdiomCategoriesTable extends IdiomCategories
    with TableInfo<$IdiomCategoriesTable, IdiomCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IdiomCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idiomIdMeta = const VerificationMeta(
    'idiomId',
  );
  @override
  late final GeneratedColumn<int> idiomId = GeneratedColumn<int>(
    'idiom_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES idioms (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [idiomId, categoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'idiom_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<IdiomCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('idiom_id')) {
      context.handle(
        _idiomIdMeta,
        idiomId.isAcceptableOrUnknown(data['idiom_id']!, _idiomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_idiomIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idiomId, categoryId};
  @override
  IdiomCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IdiomCategory(
      idiomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idiom_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
    );
  }

  @override
  $IdiomCategoriesTable createAlias(String alias) {
    return $IdiomCategoriesTable(attachedDatabase, alias);
  }
}

class IdiomCategory extends DataClass implements Insertable<IdiomCategory> {
  final int idiomId;
  final String categoryId;
  const IdiomCategory({required this.idiomId, required this.categoryId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['idiom_id'] = Variable<int>(idiomId);
    map['category_id'] = Variable<String>(categoryId);
    return map;
  }

  IdiomCategoriesCompanion toCompanion(bool nullToAbsent) {
    return IdiomCategoriesCompanion(
      idiomId: Value(idiomId),
      categoryId: Value(categoryId),
    );
  }

  factory IdiomCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IdiomCategory(
      idiomId: serializer.fromJson<int>(json['idiomId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idiomId': serializer.toJson<int>(idiomId),
      'categoryId': serializer.toJson<String>(categoryId),
    };
  }

  IdiomCategory copyWith({int? idiomId, String? categoryId}) => IdiomCategory(
    idiomId: idiomId ?? this.idiomId,
    categoryId: categoryId ?? this.categoryId,
  );
  IdiomCategory copyWithCompanion(IdiomCategoriesCompanion data) {
    return IdiomCategory(
      idiomId: data.idiomId.present ? data.idiomId.value : this.idiomId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IdiomCategory(')
          ..write('idiomId: $idiomId, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idiomId, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IdiomCategory &&
          other.idiomId == this.idiomId &&
          other.categoryId == this.categoryId);
}

class IdiomCategoriesCompanion extends UpdateCompanion<IdiomCategory> {
  final Value<int> idiomId;
  final Value<String> categoryId;
  final Value<int> rowid;
  const IdiomCategoriesCompanion({
    this.idiomId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IdiomCategoriesCompanion.insert({
    required int idiomId,
    required String categoryId,
    this.rowid = const Value.absent(),
  }) : idiomId = Value(idiomId),
       categoryId = Value(categoryId);
  static Insertable<IdiomCategory> custom({
    Expression<int>? idiomId,
    Expression<String>? categoryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idiomId != null) 'idiom_id': idiomId,
      if (categoryId != null) 'category_id': categoryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IdiomCategoriesCompanion copyWith({
    Value<int>? idiomId,
    Value<String>? categoryId,
    Value<int>? rowid,
  }) {
    return IdiomCategoriesCompanion(
      idiomId: idiomId ?? this.idiomId,
      categoryId: categoryId ?? this.categoryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idiomId.present) {
      map['idiom_id'] = Variable<int>(idiomId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdiomCategoriesCompanion(')
          ..write('idiomId: $idiomId, ')
          ..write('categoryId: $categoryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoriteIdiomsTable extends FavoriteIdioms
    with TableInfo<$FavoriteIdiomsTable, FavoriteIdiom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteIdiomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idiomIdMeta = const VerificationMeta(
    'idiomId',
  );
  @override
  late final GeneratedColumn<int> idiomId = GeneratedColumn<int>(
    'idiom_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES idioms (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [idiomId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_idioms';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoriteIdiom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('idiom_id')) {
      context.handle(
        _idiomIdMeta,
        idiomId.isAcceptableOrUnknown(data['idiom_id']!, _idiomIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idiomId};
  @override
  FavoriteIdiom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteIdiom(
      idiomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idiom_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FavoriteIdiomsTable createAlias(String alias) {
    return $FavoriteIdiomsTable(attachedDatabase, alias);
  }
}

class FavoriteIdiom extends DataClass implements Insertable<FavoriteIdiom> {
  final int idiomId;
  final DateTime createdAt;
  const FavoriteIdiom({required this.idiomId, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['idiom_id'] = Variable<int>(idiomId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FavoriteIdiomsCompanion toCompanion(bool nullToAbsent) {
    return FavoriteIdiomsCompanion(
      idiomId: Value(idiomId),
      createdAt: Value(createdAt),
    );
  }

  factory FavoriteIdiom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteIdiom(
      idiomId: serializer.fromJson<int>(json['idiomId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idiomId': serializer.toJson<int>(idiomId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FavoriteIdiom copyWith({int? idiomId, DateTime? createdAt}) => FavoriteIdiom(
    idiomId: idiomId ?? this.idiomId,
    createdAt: createdAt ?? this.createdAt,
  );
  FavoriteIdiom copyWithCompanion(FavoriteIdiomsCompanion data) {
    return FavoriteIdiom(
      idiomId: data.idiomId.present ? data.idiomId.value : this.idiomId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteIdiom(')
          ..write('idiomId: $idiomId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idiomId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteIdiom &&
          other.idiomId == this.idiomId &&
          other.createdAt == this.createdAt);
}

class FavoriteIdiomsCompanion extends UpdateCompanion<FavoriteIdiom> {
  final Value<int> idiomId;
  final Value<DateTime> createdAt;
  const FavoriteIdiomsCompanion({
    this.idiomId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FavoriteIdiomsCompanion.insert({
    this.idiomId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<FavoriteIdiom> custom({
    Expression<int>? idiomId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (idiomId != null) 'idiom_id': idiomId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FavoriteIdiomsCompanion copyWith({
    Value<int>? idiomId,
    Value<DateTime>? createdAt,
  }) {
    return FavoriteIdiomsCompanion(
      idiomId: idiomId ?? this.idiomId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idiomId.present) {
      map['idiom_id'] = Variable<int>(idiomId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteIdiomsCompanion(')
          ..write('idiomId: $idiomId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FlashcardGroupsTable extends FlashcardGroups
    with TableInfo<$FlashcardGroupsTable, FlashcardGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlashcardGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON UPDATE CASCADE ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    categoryId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flashcard_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlashcardGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FlashcardGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlashcardGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FlashcardGroupsTable createAlias(String alias) {
    return $FlashcardGroupsTable(attachedDatabase, alias);
  }
}

class FlashcardGroup extends DataClass implements Insertable<FlashcardGroup> {
  final int id;
  final String name;

  /// Optional link to the idiom category that auto-created this group.
  final String? categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FlashcardGroup({
    required this.id,
    required this.name,
    this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FlashcardGroupsCompanion toCompanion(bool nullToAbsent) {
    return FlashcardGroupsCompanion(
      id: Value(id),
      name: Value(name),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FlashcardGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlashcardGroup(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<String?>(categoryId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FlashcardGroup copyWith({
    int? id,
    String? name,
    Value<String?> categoryId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FlashcardGroup(
    id: id ?? this.id,
    name: name ?? this.name,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FlashcardGroup copyWithCompanion(FlashcardGroupsCompanion data) {
    return FlashcardGroup(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardGroup(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, categoryId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlashcardGroup &&
          other.id == this.id &&
          other.name == this.name &&
          other.categoryId == this.categoryId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FlashcardGroupsCompanion extends UpdateCompanion<FlashcardGroup> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> categoryId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const FlashcardGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FlashcardGroupsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.categoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<FlashcardGroup> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? categoryId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FlashcardGroupsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? categoryId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return FlashcardGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FlashcardGroupItemsTable extends FlashcardGroupItems
    with TableInfo<$FlashcardGroupItemsTable, FlashcardGroupItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlashcardGroupItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES flashcard_groups (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _idiomIdMeta = const VerificationMeta(
    'idiomId',
  );
  @override
  late final GeneratedColumn<int> idiomId = GeneratedColumn<int>(
    'idiom_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES idioms (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, groupId, idiomId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flashcard_group_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlashcardGroupItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('idiom_id')) {
      context.handle(
        _idiomIdMeta,
        idiomId.isAcceptableOrUnknown(data['idiom_id']!, _idiomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_idiomIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {groupId, idiomId},
  ];
  @override
  FlashcardGroupItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlashcardGroupItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      )!,
      idiomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idiom_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FlashcardGroupItemsTable createAlias(String alias) {
    return $FlashcardGroupItemsTable(attachedDatabase, alias);
  }
}

class FlashcardGroupItem extends DataClass
    implements Insertable<FlashcardGroupItem> {
  final int id;
  final int groupId;
  final int idiomId;
  final DateTime createdAt;
  const FlashcardGroupItem({
    required this.id,
    required this.groupId,
    required this.idiomId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['idiom_id'] = Variable<int>(idiomId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FlashcardGroupItemsCompanion toCompanion(bool nullToAbsent) {
    return FlashcardGroupItemsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      idiomId: Value(idiomId),
      createdAt: Value(createdAt),
    );
  }

  factory FlashcardGroupItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlashcardGroupItem(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      idiomId: serializer.fromJson<int>(json['idiomId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'idiomId': serializer.toJson<int>(idiomId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FlashcardGroupItem copyWith({
    int? id,
    int? groupId,
    int? idiomId,
    DateTime? createdAt,
  }) => FlashcardGroupItem(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    idiomId: idiomId ?? this.idiomId,
    createdAt: createdAt ?? this.createdAt,
  );
  FlashcardGroupItem copyWithCompanion(FlashcardGroupItemsCompanion data) {
    return FlashcardGroupItem(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      idiomId: data.idiomId.present ? data.idiomId.value : this.idiomId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardGroupItem(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('idiomId: $idiomId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, idiomId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlashcardGroupItem &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.idiomId == this.idiomId &&
          other.createdAt == this.createdAt);
}

class FlashcardGroupItemsCompanion extends UpdateCompanion<FlashcardGroupItem> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> idiomId;
  final Value<DateTime> createdAt;
  const FlashcardGroupItemsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.idiomId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FlashcardGroupItemsCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required int idiomId,
    this.createdAt = const Value.absent(),
  }) : groupId = Value(groupId),
       idiomId = Value(idiomId);
  static Insertable<FlashcardGroupItem> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<int>? idiomId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (idiomId != null) 'idiom_id': idiomId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FlashcardGroupItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? groupId,
    Value<int>? idiomId,
    Value<DateTime>? createdAt,
  }) {
    return FlashcardGroupItemsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      idiomId: idiomId ?? this.idiomId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (idiomId.present) {
      map['idiom_id'] = Variable<int>(idiomId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardGroupItemsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('idiomId: $idiomId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $QuizAttemptsTable extends QuizAttempts
    with TableInfo<$QuizAttemptsTable, QuizAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _totalQuestionsMeta = const VerificationMeta(
    'totalQuestions',
  );
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
    'total_questions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctAnswersMeta = const VerificationMeta(
    'correctAnswers',
  );
  @override
  late final GeneratedColumn<int> correctAnswers = GeneratedColumn<int>(
    'correct_answers',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    totalQuestions,
    correctAnswers,
    durationSeconds,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizAttempt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('total_questions')) {
      context.handle(
        _totalQuestionsMeta,
        totalQuestions.isAcceptableOrUnknown(
          data['total_questions']!,
          _totalQuestionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalQuestionsMeta);
    }
    if (data.containsKey('correct_answers')) {
      context.handle(
        _correctAnswersMeta,
        correctAnswers.isAcceptableOrUnknown(
          data['correct_answers']!,
          _correctAnswersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctAnswersMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizAttempt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      totalQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_questions'],
      )!,
      correctAnswers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_answers'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $QuizAttemptsTable createAlias(String alias) {
    return $QuizAttemptsTable(attachedDatabase, alias);
  }
}

class QuizAttempt extends DataClass implements Insertable<QuizAttempt> {
  final int id;
  final int totalQuestions;
  final int correctAnswers;
  final int durationSeconds;
  final DateTime completedAt;
  const QuizAttempt({
    required this.id,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.durationSeconds,
    required this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['total_questions'] = Variable<int>(totalQuestions);
    map['correct_answers'] = Variable<int>(correctAnswers);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  QuizAttemptsCompanion toCompanion(bool nullToAbsent) {
    return QuizAttemptsCompanion(
      id: Value(id),
      totalQuestions: Value(totalQuestions),
      correctAnswers: Value(correctAnswers),
      durationSeconds: Value(durationSeconds),
      completedAt: Value(completedAt),
    );
  }

  factory QuizAttempt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizAttempt(
      id: serializer.fromJson<int>(json['id']),
      totalQuestions: serializer.fromJson<int>(json['totalQuestions']),
      correctAnswers: serializer.fromJson<int>(json['correctAnswers']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'totalQuestions': serializer.toJson<int>(totalQuestions),
      'correctAnswers': serializer.toJson<int>(correctAnswers),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  QuizAttempt copyWith({
    int? id,
    int? totalQuestions,
    int? correctAnswers,
    int? durationSeconds,
    DateTime? completedAt,
  }) => QuizAttempt(
    id: id ?? this.id,
    totalQuestions: totalQuestions ?? this.totalQuestions,
    correctAnswers: correctAnswers ?? this.correctAnswers,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    completedAt: completedAt ?? this.completedAt,
  );
  QuizAttempt copyWithCompanion(QuizAttemptsCompanion data) {
    return QuizAttempt(
      id: data.id.present ? data.id.value : this.id,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
      correctAnswers: data.correctAnswers.present
          ? data.correctAnswers.value
          : this.correctAnswers,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttempt(')
          ..write('id: $id, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    totalQuestions,
    correctAnswers,
    durationSeconds,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizAttempt &&
          other.id == this.id &&
          other.totalQuestions == this.totalQuestions &&
          other.correctAnswers == this.correctAnswers &&
          other.durationSeconds == this.durationSeconds &&
          other.completedAt == this.completedAt);
}

class QuizAttemptsCompanion extends UpdateCompanion<QuizAttempt> {
  final Value<int> id;
  final Value<int> totalQuestions;
  final Value<int> correctAnswers;
  final Value<int> durationSeconds;
  final Value<DateTime> completedAt;
  const QuizAttemptsCompanion({
    this.id = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.correctAnswers = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  QuizAttemptsCompanion.insert({
    this.id = const Value.absent(),
    required int totalQuestions,
    required int correctAnswers,
    required int durationSeconds,
    this.completedAt = const Value.absent(),
  }) : totalQuestions = Value(totalQuestions),
       correctAnswers = Value(correctAnswers),
       durationSeconds = Value(durationSeconds);
  static Insertable<QuizAttempt> custom({
    Expression<int>? id,
    Expression<int>? totalQuestions,
    Expression<int>? correctAnswers,
    Expression<int>? durationSeconds,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (correctAnswers != null) 'correct_answers': correctAnswers,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  QuizAttemptsCompanion copyWith({
    Value<int>? id,
    Value<int>? totalQuestions,
    Value<int>? correctAnswers,
    Value<int>? durationSeconds,
    Value<DateTime>? completedAt,
  }) {
    return QuizAttemptsCompanion(
      id: id ?? this.id,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (correctAnswers.present) {
      map['correct_answers'] = Variable<int>(correctAnswers.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $QuizAttemptAnswersTable extends QuizAttemptAnswers
    with TableInfo<$QuizAttemptAnswersTable, QuizAttemptAnswer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizAttemptAnswersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _attemptIdMeta = const VerificationMeta(
    'attemptId',
  );
  @override
  late final GeneratedColumn<int> attemptId = GeneratedColumn<int>(
    'attempt_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quiz_attempts (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _questionOrderMeta = const VerificationMeta(
    'questionOrder',
  );
  @override
  late final GeneratedColumn<int> questionOrder = GeneratedColumn<int>(
    'question_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idiomIdMeta = const VerificationMeta(
    'idiomId',
  );
  @override
  late final GeneratedColumn<int> idiomId = GeneratedColumn<int>(
    'idiom_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES idioms (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _selectedIdiomIdMeta = const VerificationMeta(
    'selectedIdiomId',
  );
  @override
  late final GeneratedColumn<int> selectedIdiomId = GeneratedColumn<int>(
    'selected_idiom_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES idioms (id) ON UPDATE CASCADE ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _correctIdiomIdMeta = const VerificationMeta(
    'correctIdiomId',
  );
  @override
  late final GeneratedColumn<int> correctIdiomId = GeneratedColumn<int>(
    'correct_idiom_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES idioms (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _optionIdiomIdsMeta = const VerificationMeta(
    'optionIdiomIds',
  );
  @override
  late final GeneratedColumn<String> optionIdiomIds = GeneratedColumn<String>(
    'option_idiom_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    attemptId,
    questionOrder,
    idiomId,
    selectedIdiomId,
    correctIdiomId,
    optionIdiomIds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_attempt_answers';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizAttemptAnswer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('question_order')) {
      context.handle(
        _questionOrderMeta,
        questionOrder.isAcceptableOrUnknown(
          data['question_order']!,
          _questionOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionOrderMeta);
    }
    if (data.containsKey('idiom_id')) {
      context.handle(
        _idiomIdMeta,
        idiomId.isAcceptableOrUnknown(data['idiom_id']!, _idiomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_idiomIdMeta);
    }
    if (data.containsKey('selected_idiom_id')) {
      context.handle(
        _selectedIdiomIdMeta,
        selectedIdiomId.isAcceptableOrUnknown(
          data['selected_idiom_id']!,
          _selectedIdiomIdMeta,
        ),
      );
    }
    if (data.containsKey('correct_idiom_id')) {
      context.handle(
        _correctIdiomIdMeta,
        correctIdiomId.isAcceptableOrUnknown(
          data['correct_idiom_id']!,
          _correctIdiomIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctIdiomIdMeta);
    }
    if (data.containsKey('option_idiom_ids')) {
      context.handle(
        _optionIdiomIdsMeta,
        optionIdiomIds.isAcceptableOrUnknown(
          data['option_idiom_ids']!,
          _optionIdiomIdsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_optionIdiomIdsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {attemptId, questionOrder},
  ];
  @override
  QuizAttemptAnswer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizAttemptAnswer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_id'],
      )!,
      questionOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_order'],
      )!,
      idiomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idiom_id'],
      )!,
      selectedIdiomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selected_idiom_id'],
      ),
      correctIdiomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_idiom_id'],
      )!,
      optionIdiomIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_idiom_ids'],
      )!,
    );
  }

  @override
  $QuizAttemptAnswersTable createAlias(String alias) {
    return $QuizAttemptAnswersTable(attachedDatabase, alias);
  }
}

class QuizAttemptAnswer extends DataClass
    implements Insertable<QuizAttemptAnswer> {
  final int id;
  final int attemptId;
  final int questionOrder;
  final int idiomId;
  final int? selectedIdiomId;
  final int correctIdiomId;

  /// JSON-encoded list of option idiom IDs preserving the original option order.
  final String optionIdiomIds;
  const QuizAttemptAnswer({
    required this.id,
    required this.attemptId,
    required this.questionOrder,
    required this.idiomId,
    this.selectedIdiomId,
    required this.correctIdiomId,
    required this.optionIdiomIds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['attempt_id'] = Variable<int>(attemptId);
    map['question_order'] = Variable<int>(questionOrder);
    map['idiom_id'] = Variable<int>(idiomId);
    if (!nullToAbsent || selectedIdiomId != null) {
      map['selected_idiom_id'] = Variable<int>(selectedIdiomId);
    }
    map['correct_idiom_id'] = Variable<int>(correctIdiomId);
    map['option_idiom_ids'] = Variable<String>(optionIdiomIds);
    return map;
  }

  QuizAttemptAnswersCompanion toCompanion(bool nullToAbsent) {
    return QuizAttemptAnswersCompanion(
      id: Value(id),
      attemptId: Value(attemptId),
      questionOrder: Value(questionOrder),
      idiomId: Value(idiomId),
      selectedIdiomId: selectedIdiomId == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedIdiomId),
      correctIdiomId: Value(correctIdiomId),
      optionIdiomIds: Value(optionIdiomIds),
    );
  }

  factory QuizAttemptAnswer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizAttemptAnswer(
      id: serializer.fromJson<int>(json['id']),
      attemptId: serializer.fromJson<int>(json['attemptId']),
      questionOrder: serializer.fromJson<int>(json['questionOrder']),
      idiomId: serializer.fromJson<int>(json['idiomId']),
      selectedIdiomId: serializer.fromJson<int?>(json['selectedIdiomId']),
      correctIdiomId: serializer.fromJson<int>(json['correctIdiomId']),
      optionIdiomIds: serializer.fromJson<String>(json['optionIdiomIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'attemptId': serializer.toJson<int>(attemptId),
      'questionOrder': serializer.toJson<int>(questionOrder),
      'idiomId': serializer.toJson<int>(idiomId),
      'selectedIdiomId': serializer.toJson<int?>(selectedIdiomId),
      'correctIdiomId': serializer.toJson<int>(correctIdiomId),
      'optionIdiomIds': serializer.toJson<String>(optionIdiomIds),
    };
  }

  QuizAttemptAnswer copyWith({
    int? id,
    int? attemptId,
    int? questionOrder,
    int? idiomId,
    Value<int?> selectedIdiomId = const Value.absent(),
    int? correctIdiomId,
    String? optionIdiomIds,
  }) => QuizAttemptAnswer(
    id: id ?? this.id,
    attemptId: attemptId ?? this.attemptId,
    questionOrder: questionOrder ?? this.questionOrder,
    idiomId: idiomId ?? this.idiomId,
    selectedIdiomId: selectedIdiomId.present
        ? selectedIdiomId.value
        : this.selectedIdiomId,
    correctIdiomId: correctIdiomId ?? this.correctIdiomId,
    optionIdiomIds: optionIdiomIds ?? this.optionIdiomIds,
  );
  QuizAttemptAnswer copyWithCompanion(QuizAttemptAnswersCompanion data) {
    return QuizAttemptAnswer(
      id: data.id.present ? data.id.value : this.id,
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      questionOrder: data.questionOrder.present
          ? data.questionOrder.value
          : this.questionOrder,
      idiomId: data.idiomId.present ? data.idiomId.value : this.idiomId,
      selectedIdiomId: data.selectedIdiomId.present
          ? data.selectedIdiomId.value
          : this.selectedIdiomId,
      correctIdiomId: data.correctIdiomId.present
          ? data.correctIdiomId.value
          : this.correctIdiomId,
      optionIdiomIds: data.optionIdiomIds.present
          ? data.optionIdiomIds.value
          : this.optionIdiomIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttemptAnswer(')
          ..write('id: $id, ')
          ..write('attemptId: $attemptId, ')
          ..write('questionOrder: $questionOrder, ')
          ..write('idiomId: $idiomId, ')
          ..write('selectedIdiomId: $selectedIdiomId, ')
          ..write('correctIdiomId: $correctIdiomId, ')
          ..write('optionIdiomIds: $optionIdiomIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    attemptId,
    questionOrder,
    idiomId,
    selectedIdiomId,
    correctIdiomId,
    optionIdiomIds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizAttemptAnswer &&
          other.id == this.id &&
          other.attemptId == this.attemptId &&
          other.questionOrder == this.questionOrder &&
          other.idiomId == this.idiomId &&
          other.selectedIdiomId == this.selectedIdiomId &&
          other.correctIdiomId == this.correctIdiomId &&
          other.optionIdiomIds == this.optionIdiomIds);
}

class QuizAttemptAnswersCompanion extends UpdateCompanion<QuizAttemptAnswer> {
  final Value<int> id;
  final Value<int> attemptId;
  final Value<int> questionOrder;
  final Value<int> idiomId;
  final Value<int?> selectedIdiomId;
  final Value<int> correctIdiomId;
  final Value<String> optionIdiomIds;
  const QuizAttemptAnswersCompanion({
    this.id = const Value.absent(),
    this.attemptId = const Value.absent(),
    this.questionOrder = const Value.absent(),
    this.idiomId = const Value.absent(),
    this.selectedIdiomId = const Value.absent(),
    this.correctIdiomId = const Value.absent(),
    this.optionIdiomIds = const Value.absent(),
  });
  QuizAttemptAnswersCompanion.insert({
    this.id = const Value.absent(),
    required int attemptId,
    required int questionOrder,
    required int idiomId,
    this.selectedIdiomId = const Value.absent(),
    required int correctIdiomId,
    required String optionIdiomIds,
  }) : attemptId = Value(attemptId),
       questionOrder = Value(questionOrder),
       idiomId = Value(idiomId),
       correctIdiomId = Value(correctIdiomId),
       optionIdiomIds = Value(optionIdiomIds);
  static Insertable<QuizAttemptAnswer> custom({
    Expression<int>? id,
    Expression<int>? attemptId,
    Expression<int>? questionOrder,
    Expression<int>? idiomId,
    Expression<int>? selectedIdiomId,
    Expression<int>? correctIdiomId,
    Expression<String>? optionIdiomIds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (attemptId != null) 'attempt_id': attemptId,
      if (questionOrder != null) 'question_order': questionOrder,
      if (idiomId != null) 'idiom_id': idiomId,
      if (selectedIdiomId != null) 'selected_idiom_id': selectedIdiomId,
      if (correctIdiomId != null) 'correct_idiom_id': correctIdiomId,
      if (optionIdiomIds != null) 'option_idiom_ids': optionIdiomIds,
    });
  }

  QuizAttemptAnswersCompanion copyWith({
    Value<int>? id,
    Value<int>? attemptId,
    Value<int>? questionOrder,
    Value<int>? idiomId,
    Value<int?>? selectedIdiomId,
    Value<int>? correctIdiomId,
    Value<String>? optionIdiomIds,
  }) {
    return QuizAttemptAnswersCompanion(
      id: id ?? this.id,
      attemptId: attemptId ?? this.attemptId,
      questionOrder: questionOrder ?? this.questionOrder,
      idiomId: idiomId ?? this.idiomId,
      selectedIdiomId: selectedIdiomId ?? this.selectedIdiomId,
      correctIdiomId: correctIdiomId ?? this.correctIdiomId,
      optionIdiomIds: optionIdiomIds ?? this.optionIdiomIds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (attemptId.present) {
      map['attempt_id'] = Variable<int>(attemptId.value);
    }
    if (questionOrder.present) {
      map['question_order'] = Variable<int>(questionOrder.value);
    }
    if (idiomId.present) {
      map['idiom_id'] = Variable<int>(idiomId.value);
    }
    if (selectedIdiomId.present) {
      map['selected_idiom_id'] = Variable<int>(selectedIdiomId.value);
    }
    if (correctIdiomId.present) {
      map['correct_idiom_id'] = Variable<int>(correctIdiomId.value);
    }
    if (optionIdiomIds.present) {
      map['option_idiom_ids'] = Variable<String>(optionIdiomIds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttemptAnswersCompanion(')
          ..write('id: $id, ')
          ..write('attemptId: $attemptId, ')
          ..write('questionOrder: $questionOrder, ')
          ..write('idiomId: $idiomId, ')
          ..write('selectedIdiomId: $selectedIdiomId, ')
          ..write('correctIdiomId: $correctIdiomId, ')
          ..write('optionIdiomIds: $optionIdiomIds')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LanguagesTable languages = $LanguagesTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $CategoryTranslationsTable categoryTranslations =
      $CategoryTranslationsTable(this);
  late final $IdiomsTable idioms = $IdiomsTable(this);
  late final $IdiomTranslationsTable idiomTranslations =
      $IdiomTranslationsTable(this);
  late final $DefinitionsTable definitions = $DefinitionsTable(this);
  late final $DefinitionTranslationsTable definitionTranslations =
      $DefinitionTranslationsTable(this);
  late final $ExamplesTable examples = $ExamplesTable(this);
  late final $ExampleTranslationsTable exampleTranslations =
      $ExampleTranslationsTable(this);
  late final $IdiomCategoriesTable idiomCategories = $IdiomCategoriesTable(
    this,
  );
  late final $FavoriteIdiomsTable favoriteIdioms = $FavoriteIdiomsTable(this);
  late final $FlashcardGroupsTable flashcardGroups = $FlashcardGroupsTable(
    this,
  );
  late final $FlashcardGroupItemsTable flashcardGroupItems =
      $FlashcardGroupItemsTable(this);
  late final $QuizAttemptsTable quizAttempts = $QuizAttemptsTable(this);
  late final $QuizAttemptAnswersTable quizAttemptAnswers =
      $QuizAttemptAnswersTable(this);
  late final Index flashcardGroupItemsGroupIdx = Index(
    'flashcard_group_items_group_idx',
    'CREATE INDEX flashcard_group_items_group_idx ON flashcard_group_items (group_id)',
  );
  late final Index flashcardGroupItemsIdiomIdx = Index(
    'flashcard_group_items_idiom_idx',
    'CREATE INDEX flashcard_group_items_idiom_idx ON flashcard_group_items (idiom_id)',
  );
  late final Index quizAttemptsCompletedAtIdx = Index(
    'quiz_attempts_completed_at_idx',
    'CREATE INDEX quiz_attempts_completed_at_idx ON quiz_attempts (completed_at DESC)',
  );
  late final Index quizAttemptAnswersAttemptIdx = Index(
    'quiz_attempt_answers_attempt_idx',
    'CREATE INDEX quiz_attempt_answers_attempt_idx ON quiz_attempt_answers (attempt_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    languages,
    categories,
    categoryTranslations,
    idioms,
    idiomTranslations,
    definitions,
    definitionTranslations,
    examples,
    exampleTranslations,
    idiomCategories,
    favoriteIdioms,
    flashcardGroups,
    flashcardGroupItems,
    quizAttempts,
    quizAttemptAnswers,
    flashcardGroupItemsGroupIdx,
    flashcardGroupItemsIdiomIdx,
    quizAttemptsCompletedAtIdx,
    quizAttemptAnswersAttemptIdx,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('category_translations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('category_translations', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'languages',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('category_translations', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('idiom_translations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('idiom_translations', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'languages',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('idiom_translations', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('definitions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('definitions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'definitions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('definition_translations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'definitions',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('definition_translations', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'languages',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('definition_translations', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('examples', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('examples', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'definitions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('examples', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'definitions',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('examples', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'examples',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('example_translations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'examples',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('example_translations', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'languages',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('example_translations', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('idiom_categories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('idiom_categories', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('idiom_categories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('idiom_categories', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('favorite_idioms', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('favorite_idioms', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('flashcard_groups', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('flashcard_groups', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'flashcard_groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('flashcard_group_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'flashcard_groups',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('flashcard_group_items', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('flashcard_group_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('flashcard_group_items', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quiz_attempts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quiz_attempt_answers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quiz_attempts',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('quiz_attempt_answers', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quiz_attempt_answers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('quiz_attempt_answers', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quiz_attempt_answers', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('quiz_attempt_answers', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quiz_attempt_answers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idioms',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('quiz_attempt_answers', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$LanguagesTableCreateCompanionBuilder =
    LanguagesCompanion Function({
      required String code,
      required String name,
      required String direction,
      Value<int> rowid,
    });
typedef $$LanguagesTableUpdateCompanionBuilder =
    LanguagesCompanion Function({
      Value<String> code,
      Value<String> name,
      Value<String> direction,
      Value<int> rowid,
    });

final class $$LanguagesTableReferences
    extends BaseReferences<_$AppDatabase, $LanguagesTable, Language> {
  $$LanguagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $CategoryTranslationsTable,
    List<CategoryTranslation>
  >
  _categoryTranslationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.categoryTranslations,
        aliasName: 'languages__code__category_translations__language_code',
      );

  $$CategoryTranslationsTableProcessedTableManager
  get categoryTranslationsRefs {
    final manager =
        $$CategoryTranslationsTableTableManager(
          $_db,
          $_db.categoryTranslations,
        ).filter(
          (f) => f.languageCode.code.sqlEquals($_itemColumn<String>('code')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _categoryTranslationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IdiomTranslationsTable, List<IdiomTranslation>>
  _idiomTranslationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.idiomTranslations,
        aliasName: 'languages__code__idiom_translations__language_code',
      );

  $$IdiomTranslationsTableProcessedTableManager get idiomTranslationsRefs {
    final manager =
        $$IdiomTranslationsTableTableManager(
          $_db,
          $_db.idiomTranslations,
        ).filter(
          (f) => f.languageCode.code.sqlEquals($_itemColumn<String>('code')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _idiomTranslationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DefinitionTranslationsTable,
    List<DefinitionTranslation>
  >
  _definitionTranslationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.definitionTranslations,
        aliasName: 'languages__code__definition_translations__language_code',
      );

  $$DefinitionTranslationsTableProcessedTableManager
  get definitionTranslationsRefs {
    final manager =
        $$DefinitionTranslationsTableTableManager(
          $_db,
          $_db.definitionTranslations,
        ).filter(
          (f) => f.languageCode.code.sqlEquals($_itemColumn<String>('code')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _definitionTranslationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ExampleTranslationsTable,
    List<ExampleTranslation>
  >
  _exampleTranslationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.exampleTranslations,
        aliasName: 'languages__code__example_translations__language_code',
      );

  $$ExampleTranslationsTableProcessedTableManager get exampleTranslationsRefs {
    final manager =
        $$ExampleTranslationsTableTableManager(
          $_db,
          $_db.exampleTranslations,
        ).filter(
          (f) => f.languageCode.code.sqlEquals($_itemColumn<String>('code')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _exampleTranslationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LanguagesTableFilterComposer
    extends Composer<_$AppDatabase, $LanguagesTable> {
  $$LanguagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> categoryTranslationsRefs(
    Expression<bool> Function($$CategoryTranslationsTableFilterComposer f) f,
  ) {
    final $$CategoryTranslationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.categoryTranslations,
      getReferencedColumn: (t) => t.languageCode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryTranslationsTableFilterComposer(
            $db: $db,
            $table: $db.categoryTranslations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> idiomTranslationsRefs(
    Expression<bool> Function($$IdiomTranslationsTableFilterComposer f) f,
  ) {
    final $$IdiomTranslationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.idiomTranslations,
      getReferencedColumn: (t) => t.languageCode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomTranslationsTableFilterComposer(
            $db: $db,
            $table: $db.idiomTranslations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> definitionTranslationsRefs(
    Expression<bool> Function($$DefinitionTranslationsTableFilterComposer f) f,
  ) {
    final $$DefinitionTranslationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.code,
          referencedTable: $db.definitionTranslations,
          getReferencedColumn: (t) => t.languageCode,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DefinitionTranslationsTableFilterComposer(
                $db: $db,
                $table: $db.definitionTranslations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> exampleTranslationsRefs(
    Expression<bool> Function($$ExampleTranslationsTableFilterComposer f) f,
  ) {
    final $$ExampleTranslationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.exampleTranslations,
      getReferencedColumn: (t) => t.languageCode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExampleTranslationsTableFilterComposer(
            $db: $db,
            $table: $db.exampleTranslations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LanguagesTableOrderingComposer
    extends Composer<_$AppDatabase, $LanguagesTable> {
  $$LanguagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LanguagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LanguagesTable> {
  $$LanguagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  Expression<T> categoryTranslationsRefs<T extends Object>(
    Expression<T> Function($$CategoryTranslationsTableAnnotationComposer a) f,
  ) {
    final $$CategoryTranslationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.code,
          referencedTable: $db.categoryTranslations,
          getReferencedColumn: (t) => t.languageCode,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CategoryTranslationsTableAnnotationComposer(
                $db: $db,
                $table: $db.categoryTranslations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> idiomTranslationsRefs<T extends Object>(
    Expression<T> Function($$IdiomTranslationsTableAnnotationComposer a) f,
  ) {
    final $$IdiomTranslationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.code,
          referencedTable: $db.idiomTranslations,
          getReferencedColumn: (t) => t.languageCode,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IdiomTranslationsTableAnnotationComposer(
                $db: $db,
                $table: $db.idiomTranslations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> definitionTranslationsRefs<T extends Object>(
    Expression<T> Function($$DefinitionTranslationsTableAnnotationComposer a) f,
  ) {
    final $$DefinitionTranslationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.code,
          referencedTable: $db.definitionTranslations,
          getReferencedColumn: (t) => t.languageCode,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DefinitionTranslationsTableAnnotationComposer(
                $db: $db,
                $table: $db.definitionTranslations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> exampleTranslationsRefs<T extends Object>(
    Expression<T> Function($$ExampleTranslationsTableAnnotationComposer a) f,
  ) {
    final $$ExampleTranslationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.code,
          referencedTable: $db.exampleTranslations,
          getReferencedColumn: (t) => t.languageCode,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExampleTranslationsTableAnnotationComposer(
                $db: $db,
                $table: $db.exampleTranslations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LanguagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LanguagesTable,
          Language,
          $$LanguagesTableFilterComposer,
          $$LanguagesTableOrderingComposer,
          $$LanguagesTableAnnotationComposer,
          $$LanguagesTableCreateCompanionBuilder,
          $$LanguagesTableUpdateCompanionBuilder,
          (Language, $$LanguagesTableReferences),
          Language,
          PrefetchHooks Function({
            bool categoryTranslationsRefs,
            bool idiomTranslationsRefs,
            bool definitionTranslationsRefs,
            bool exampleTranslationsRefs,
          })
        > {
  $$LanguagesTableTableManager(_$AppDatabase db, $LanguagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LanguagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LanguagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LanguagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LanguagesCompanion(
                code: code,
                name: name,
                direction: direction,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String code,
                required String name,
                required String direction,
                Value<int> rowid = const Value.absent(),
              }) => LanguagesCompanion.insert(
                code: code,
                name: name,
                direction: direction,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LanguagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryTranslationsRefs = false,
                idiomTranslationsRefs = false,
                definitionTranslationsRefs = false,
                exampleTranslationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (categoryTranslationsRefs) db.categoryTranslations,
                    if (idiomTranslationsRefs) db.idiomTranslations,
                    if (definitionTranslationsRefs) db.definitionTranslations,
                    if (exampleTranslationsRefs) db.exampleTranslations,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (categoryTranslationsRefs)
                        await $_getPrefetchedData<
                          Language,
                          $LanguagesTable,
                          CategoryTranslation
                        >(
                          currentTable: table,
                          referencedTable: $$LanguagesTableReferences
                              ._categoryTranslationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LanguagesTableReferences(
                                db,
                                table,
                                p0,
                              ).categoryTranslationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.languageCode == item.code,
                              ),
                          typedResults: items,
                        ),
                      if (idiomTranslationsRefs)
                        await $_getPrefetchedData<
                          Language,
                          $LanguagesTable,
                          IdiomTranslation
                        >(
                          currentTable: table,
                          referencedTable: $$LanguagesTableReferences
                              ._idiomTranslationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LanguagesTableReferences(
                                db,
                                table,
                                p0,
                              ).idiomTranslationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.languageCode == item.code,
                              ),
                          typedResults: items,
                        ),
                      if (definitionTranslationsRefs)
                        await $_getPrefetchedData<
                          Language,
                          $LanguagesTable,
                          DefinitionTranslation
                        >(
                          currentTable: table,
                          referencedTable: $$LanguagesTableReferences
                              ._definitionTranslationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LanguagesTableReferences(
                                db,
                                table,
                                p0,
                              ).definitionTranslationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.languageCode == item.code,
                              ),
                          typedResults: items,
                        ),
                      if (exampleTranslationsRefs)
                        await $_getPrefetchedData<
                          Language,
                          $LanguagesTable,
                          ExampleTranslation
                        >(
                          currentTable: table,
                          referencedTable: $$LanguagesTableReferences
                              ._exampleTranslationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LanguagesTableReferences(
                                db,
                                table,
                                p0,
                              ).exampleTranslationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.languageCode == item.code,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LanguagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LanguagesTable,
      Language,
      $$LanguagesTableFilterComposer,
      $$LanguagesTableOrderingComposer,
      $$LanguagesTableAnnotationComposer,
      $$LanguagesTableCreateCompanionBuilder,
      $$LanguagesTableUpdateCompanionBuilder,
      (Language, $$LanguagesTableReferences),
      Language,
      PrefetchHooks Function({
        bool categoryTranslationsRefs,
        bool idiomTranslationsRefs,
        bool definitionTranslationsRefs,
        bool exampleTranslationsRefs,
      })
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required int displayOrder,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<int> displayOrder,
      Value<int> rowid,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $CategoryTranslationsTable,
    List<CategoryTranslation>
  >
  _categoryTranslationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.categoryTranslations,
        aliasName: 'categories__id__category_translations__category_id',
      );

  $$CategoryTranslationsTableProcessedTableManager
  get categoryTranslationsRefs {
    final manager = $$CategoryTranslationsTableTableManager(
      $_db,
      $_db.categoryTranslations,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _categoryTranslationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IdiomCategoriesTable, List<IdiomCategory>>
  _idiomCategoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.idiomCategories,
    aliasName: 'categories__id__idiom_categories__category_id',
  );

  $$IdiomCategoriesTableProcessedTableManager get idiomCategoriesRefs {
    final manager = $$IdiomCategoriesTableTableManager(
      $_db,
      $_db.idiomCategories,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _idiomCategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FlashcardGroupsTable, List<FlashcardGroup>>
  _flashcardGroupsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.flashcardGroups,
    aliasName: 'categories__id__flashcard_groups__category_id',
  );

  $$FlashcardGroupsTableProcessedTableManager get flashcardGroupsRefs {
    final manager = $$FlashcardGroupsTableTableManager(
      $_db,
      $_db.flashcardGroups,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _flashcardGroupsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> categoryTranslationsRefs(
    Expression<bool> Function($$CategoryTranslationsTableFilterComposer f) f,
  ) {
    final $$CategoryTranslationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categoryTranslations,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryTranslationsTableFilterComposer(
            $db: $db,
            $table: $db.categoryTranslations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> idiomCategoriesRefs(
    Expression<bool> Function($$IdiomCategoriesTableFilterComposer f) f,
  ) {
    final $$IdiomCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.idiomCategories,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.idiomCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> flashcardGroupsRefs(
    Expression<bool> Function($$FlashcardGroupsTableFilterComposer f) f,
  ) {
    final $$FlashcardGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flashcardGroups,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardGroupsTableFilterComposer(
            $db: $db,
            $table: $db.flashcardGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  Expression<T> categoryTranslationsRefs<T extends Object>(
    Expression<T> Function($$CategoryTranslationsTableAnnotationComposer a) f,
  ) {
    final $$CategoryTranslationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.categoryTranslations,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CategoryTranslationsTableAnnotationComposer(
                $db: $db,
                $table: $db.categoryTranslations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> idiomCategoriesRefs<T extends Object>(
    Expression<T> Function($$IdiomCategoriesTableAnnotationComposer a) f,
  ) {
    final $$IdiomCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.idiomCategories,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.idiomCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> flashcardGroupsRefs<T extends Object>(
    Expression<T> Function($$FlashcardGroupsTableAnnotationComposer a) f,
  ) {
    final $$FlashcardGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flashcardGroups,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.flashcardGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({
            bool categoryTranslationsRefs,
            bool idiomCategoriesRefs,
            bool flashcardGroupsRefs,
          })
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int displayOrder,
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryTranslationsRefs = false,
                idiomCategoriesRefs = false,
                flashcardGroupsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (categoryTranslationsRefs) db.categoryTranslations,
                    if (idiomCategoriesRefs) db.idiomCategories,
                    if (flashcardGroupsRefs) db.flashcardGroups,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (categoryTranslationsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          CategoryTranslation
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._categoryTranslationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).categoryTranslationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (idiomCategoriesRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          IdiomCategory
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._idiomCategoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).idiomCategoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (flashcardGroupsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          FlashcardGroup
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._flashcardGroupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).flashcardGroupsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({
        bool categoryTranslationsRefs,
        bool idiomCategoriesRefs,
        bool flashcardGroupsRefs,
      })
    >;
typedef $$CategoryTranslationsTableCreateCompanionBuilder =
    CategoryTranslationsCompanion Function({
      Value<int> id,
      required String categoryId,
      required String languageCode,
      required String name,
      Value<String?> description,
    });
typedef $$CategoryTranslationsTableUpdateCompanionBuilder =
    CategoryTranslationsCompanion Function({
      Value<int> id,
      Value<String> categoryId,
      Value<String> languageCode,
      Value<String> name,
      Value<String?> description,
    });

final class $$CategoryTranslationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CategoryTranslationsTable,
          CategoryTranslation
        > {
  $$CategoryTranslationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) => db.categories
      .createAlias('category_translations__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LanguagesTable _languageCodeTable(_$AppDatabase db) => db.languages
      .createAlias('category_translations__language_code__languages__code');

  $$LanguagesTableProcessedTableManager get languageCode {
    final $_column = $_itemColumn<String>('language_code')!;

    final manager = $$LanguagesTableTableManager(
      $_db,
      $_db.languages,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_languageCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CategoryTranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryTranslationsTable> {
  $$CategoryTranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LanguagesTableFilterComposer get languageCode {
    final $$LanguagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.languageCode,
      referencedTable: $db.languages,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LanguagesTableFilterComposer(
            $db: $db,
            $table: $db.languages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoryTranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryTranslationsTable> {
  $$CategoryTranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LanguagesTableOrderingComposer get languageCode {
    final $$LanguagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.languageCode,
      referencedTable: $db.languages,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LanguagesTableOrderingComposer(
            $db: $db,
            $table: $db.languages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoryTranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryTranslationsTable> {
  $$CategoryTranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LanguagesTableAnnotationComposer get languageCode {
    final $$LanguagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.languageCode,
      referencedTable: $db.languages,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LanguagesTableAnnotationComposer(
            $db: $db,
            $table: $db.languages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoryTranslationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoryTranslationsTable,
          CategoryTranslation,
          $$CategoryTranslationsTableFilterComposer,
          $$CategoryTranslationsTableOrderingComposer,
          $$CategoryTranslationsTableAnnotationComposer,
          $$CategoryTranslationsTableCreateCompanionBuilder,
          $$CategoryTranslationsTableUpdateCompanionBuilder,
          (CategoryTranslation, $$CategoryTranslationsTableReferences),
          CategoryTranslation,
          PrefetchHooks Function({bool categoryId, bool languageCode})
        > {
  $$CategoryTranslationsTableTableManager(
    _$AppDatabase db,
    $CategoryTranslationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryTranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryTranslationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CategoryTranslationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
              }) => CategoryTranslationsCompanion(
                id: id,
                categoryId: categoryId,
                languageCode: languageCode,
                name: name,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String categoryId,
                required String languageCode,
                required String name,
                Value<String?> description = const Value.absent(),
              }) => CategoryTranslationsCompanion.insert(
                id: id,
                categoryId: categoryId,
                languageCode: languageCode,
                name: name,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoryTranslationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false, languageCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable:
                                    $$CategoryTranslationsTableReferences
                                        ._categoryIdTable(db),
                                referencedColumn:
                                    $$CategoryTranslationsTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (languageCode) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.languageCode,
                                referencedTable:
                                    $$CategoryTranslationsTableReferences
                                        ._languageCodeTable(db),
                                referencedColumn:
                                    $$CategoryTranslationsTableReferences
                                        ._languageCodeTable(db)
                                        .code,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CategoryTranslationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoryTranslationsTable,
      CategoryTranslation,
      $$CategoryTranslationsTableFilterComposer,
      $$CategoryTranslationsTableOrderingComposer,
      $$CategoryTranslationsTableAnnotationComposer,
      $$CategoryTranslationsTableCreateCompanionBuilder,
      $$CategoryTranslationsTableUpdateCompanionBuilder,
      (CategoryTranslation, $$CategoryTranslationsTableReferences),
      CategoryTranslation,
      PrefetchHooks Function({bool categoryId, bool languageCode})
    >;
typedef $$IdiomsTableCreateCompanionBuilder =
    IdiomsCompanion Function({Value<int> id, Value<String?> slug});
typedef $$IdiomsTableUpdateCompanionBuilder =
    IdiomsCompanion Function({Value<int> id, Value<String?> slug});

final class $$IdiomsTableReferences
    extends BaseReferences<_$AppDatabase, $IdiomsTable, Idiom> {
  $$IdiomsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$IdiomTranslationsTable, List<IdiomTranslation>>
  _idiomTranslationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.idiomTranslations,
        aliasName: 'idioms__id__idiom_translations__idiom_id',
      );

  $$IdiomTranslationsTableProcessedTableManager get idiomTranslationsRefs {
    final manager = $$IdiomTranslationsTableTableManager(
      $_db,
      $_db.idiomTranslations,
    ).filter((f) => f.idiomId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _idiomTranslationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DefinitionsTable, List<Definition>>
  _definitionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.definitions,
    aliasName: 'idioms__id__definitions__idiom_id',
  );

  $$DefinitionsTableProcessedTableManager get definitionsRefs {
    final manager = $$DefinitionsTableTableManager(
      $_db,
      $_db.definitions,
    ).filter((f) => f.idiomId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_definitionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExamplesTable, List<Example>> _examplesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.examples,
    aliasName: 'idioms__id__examples__idiom_id',
  );

  $$ExamplesTableProcessedTableManager get examplesRefs {
    final manager = $$ExamplesTableTableManager(
      $_db,
      $_db.examples,
    ).filter((f) => f.idiomId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_examplesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IdiomCategoriesTable, List<IdiomCategory>>
  _idiomCategoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.idiomCategories,
    aliasName: 'idioms__id__idiom_categories__idiom_id',
  );

  $$IdiomCategoriesTableProcessedTableManager get idiomCategoriesRefs {
    final manager = $$IdiomCategoriesTableTableManager(
      $_db,
      $_db.idiomCategories,
    ).filter((f) => f.idiomId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _idiomCategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FavoriteIdiomsTable, List<FavoriteIdiom>>
  _favoriteIdiomsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.favoriteIdioms,
    aliasName: 'idioms__id__favorite_idioms__idiom_id',
  );

  $$FavoriteIdiomsTableProcessedTableManager get favoriteIdiomsRefs {
    final manager = $$FavoriteIdiomsTableTableManager(
      $_db,
      $_db.favoriteIdioms,
    ).filter((f) => f.idiomId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_favoriteIdiomsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $FlashcardGroupItemsTable,
    List<FlashcardGroupItem>
  >
  _flashcardGroupItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.flashcardGroupItems,
        aliasName: 'idioms__id__flashcard_group_items__idiom_id',
      );

  $$FlashcardGroupItemsTableProcessedTableManager get flashcardGroupItemsRefs {
    final manager = $$FlashcardGroupItemsTableTableManager(
      $_db,
      $_db.flashcardGroupItems,
    ).filter((f) => f.idiomId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _flashcardGroupItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IdiomsTableFilterComposer
    extends Composer<_$AppDatabase, $IdiomsTable> {
  $$IdiomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> idiomTranslationsRefs(
    Expression<bool> Function($$IdiomTranslationsTableFilterComposer f) f,
  ) {
    final $$IdiomTranslationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.idiomTranslations,
      getReferencedColumn: (t) => t.idiomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomTranslationsTableFilterComposer(
            $db: $db,
            $table: $db.idiomTranslations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> definitionsRefs(
    Expression<bool> Function($$DefinitionsTableFilterComposer f) f,
  ) {
    final $$DefinitionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.definitions,
      getReferencedColumn: (t) => t.idiomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DefinitionsTableFilterComposer(
            $db: $db,
            $table: $db.definitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> examplesRefs(
    Expression<bool> Function($$ExamplesTableFilterComposer f) f,
  ) {
    final $$ExamplesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examples,
      getReferencedColumn: (t) => t.idiomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamplesTableFilterComposer(
            $db: $db,
            $table: $db.examples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> idiomCategoriesRefs(
    Expression<bool> Function($$IdiomCategoriesTableFilterComposer f) f,
  ) {
    final $$IdiomCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.idiomCategories,
      getReferencedColumn: (t) => t.idiomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.idiomCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> favoriteIdiomsRefs(
    Expression<bool> Function($$FavoriteIdiomsTableFilterComposer f) f,
  ) {
    final $$FavoriteIdiomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favoriteIdioms,
      getReferencedColumn: (t) => t.idiomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoriteIdiomsTableFilterComposer(
            $db: $db,
            $table: $db.favoriteIdioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> flashcardGroupItemsRefs(
    Expression<bool> Function($$FlashcardGroupItemsTableFilterComposer f) f,
  ) {
    final $$FlashcardGroupItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flashcardGroupItems,
      getReferencedColumn: (t) => t.idiomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardGroupItemsTableFilterComposer(
            $db: $db,
            $table: $db.flashcardGroupItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IdiomsTableOrderingComposer
    extends Composer<_$AppDatabase, $IdiomsTable> {
  $$IdiomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IdiomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IdiomsTable> {
  $$IdiomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  Expression<T> idiomTranslationsRefs<T extends Object>(
    Expression<T> Function($$IdiomTranslationsTableAnnotationComposer a) f,
  ) {
    final $$IdiomTranslationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.idiomTranslations,
          getReferencedColumn: (t) => t.idiomId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IdiomTranslationsTableAnnotationComposer(
                $db: $db,
                $table: $db.idiomTranslations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> definitionsRefs<T extends Object>(
    Expression<T> Function($$DefinitionsTableAnnotationComposer a) f,
  ) {
    final $$DefinitionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.definitions,
      getReferencedColumn: (t) => t.idiomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DefinitionsTableAnnotationComposer(
            $db: $db,
            $table: $db.definitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> examplesRefs<T extends Object>(
    Expression<T> Function($$ExamplesTableAnnotationComposer a) f,
  ) {
    final $$ExamplesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examples,
      getReferencedColumn: (t) => t.idiomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamplesTableAnnotationComposer(
            $db: $db,
            $table: $db.examples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> idiomCategoriesRefs<T extends Object>(
    Expression<T> Function($$IdiomCategoriesTableAnnotationComposer a) f,
  ) {
    final $$IdiomCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.idiomCategories,
      getReferencedColumn: (t) => t.idiomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.idiomCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> favoriteIdiomsRefs<T extends Object>(
    Expression<T> Function($$FavoriteIdiomsTableAnnotationComposer a) f,
  ) {
    final $$FavoriteIdiomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favoriteIdioms,
      getReferencedColumn: (t) => t.idiomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoriteIdiomsTableAnnotationComposer(
            $db: $db,
            $table: $db.favoriteIdioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> flashcardGroupItemsRefs<T extends Object>(
    Expression<T> Function($$FlashcardGroupItemsTableAnnotationComposer a) f,
  ) {
    final $$FlashcardGroupItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.flashcardGroupItems,
          getReferencedColumn: (t) => t.idiomId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FlashcardGroupItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.flashcardGroupItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$IdiomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IdiomsTable,
          Idiom,
          $$IdiomsTableFilterComposer,
          $$IdiomsTableOrderingComposer,
          $$IdiomsTableAnnotationComposer,
          $$IdiomsTableCreateCompanionBuilder,
          $$IdiomsTableUpdateCompanionBuilder,
          (Idiom, $$IdiomsTableReferences),
          Idiom,
          PrefetchHooks Function({
            bool idiomTranslationsRefs,
            bool definitionsRefs,
            bool examplesRefs,
            bool idiomCategoriesRefs,
            bool favoriteIdiomsRefs,
            bool flashcardGroupItemsRefs,
          })
        > {
  $$IdiomsTableTableManager(_$AppDatabase db, $IdiomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IdiomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IdiomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IdiomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> slug = const Value.absent(),
              }) => IdiomsCompanion(id: id, slug: slug),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> slug = const Value.absent(),
              }) => IdiomsCompanion.insert(id: id, slug: slug),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$IdiomsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                idiomTranslationsRefs = false,
                definitionsRefs = false,
                examplesRefs = false,
                idiomCategoriesRefs = false,
                favoriteIdiomsRefs = false,
                flashcardGroupItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (idiomTranslationsRefs) db.idiomTranslations,
                    if (definitionsRefs) db.definitions,
                    if (examplesRefs) db.examples,
                    if (idiomCategoriesRefs) db.idiomCategories,
                    if (favoriteIdiomsRefs) db.favoriteIdioms,
                    if (flashcardGroupItemsRefs) db.flashcardGroupItems,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (idiomTranslationsRefs)
                        await $_getPrefetchedData<
                          Idiom,
                          $IdiomsTable,
                          IdiomTranslation
                        >(
                          currentTable: table,
                          referencedTable: $$IdiomsTableReferences
                              ._idiomTranslationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IdiomsTableReferences(
                                db,
                                table,
                                p0,
                              ).idiomTranslationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idiomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (definitionsRefs)
                        await $_getPrefetchedData<
                          Idiom,
                          $IdiomsTable,
                          Definition
                        >(
                          currentTable: table,
                          referencedTable: $$IdiomsTableReferences
                              ._definitionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IdiomsTableReferences(
                                db,
                                table,
                                p0,
                              ).definitionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idiomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (examplesRefs)
                        await $_getPrefetchedData<Idiom, $IdiomsTable, Example>(
                          currentTable: table,
                          referencedTable: $$IdiomsTableReferences
                              ._examplesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IdiomsTableReferences(
                                db,
                                table,
                                p0,
                              ).examplesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idiomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (idiomCategoriesRefs)
                        await $_getPrefetchedData<
                          Idiom,
                          $IdiomsTable,
                          IdiomCategory
                        >(
                          currentTable: table,
                          referencedTable: $$IdiomsTableReferences
                              ._idiomCategoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IdiomsTableReferences(
                                db,
                                table,
                                p0,
                              ).idiomCategoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idiomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (favoriteIdiomsRefs)
                        await $_getPrefetchedData<
                          Idiom,
                          $IdiomsTable,
                          FavoriteIdiom
                        >(
                          currentTable: table,
                          referencedTable: $$IdiomsTableReferences
                              ._favoriteIdiomsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IdiomsTableReferences(
                                db,
                                table,
                                p0,
                              ).favoriteIdiomsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idiomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (flashcardGroupItemsRefs)
                        await $_getPrefetchedData<
                          Idiom,
                          $IdiomsTable,
                          FlashcardGroupItem
                        >(
                          currentTable: table,
                          referencedTable: $$IdiomsTableReferences
                              ._flashcardGroupItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IdiomsTableReferences(
                                db,
                                table,
                                p0,
                              ).flashcardGroupItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idiomId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$IdiomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IdiomsTable,
      Idiom,
      $$IdiomsTableFilterComposer,
      $$IdiomsTableOrderingComposer,
      $$IdiomsTableAnnotationComposer,
      $$IdiomsTableCreateCompanionBuilder,
      $$IdiomsTableUpdateCompanionBuilder,
      (Idiom, $$IdiomsTableReferences),
      Idiom,
      PrefetchHooks Function({
        bool idiomTranslationsRefs,
        bool definitionsRefs,
        bool examplesRefs,
        bool idiomCategoriesRefs,
        bool favoriteIdiomsRefs,
        bool flashcardGroupItemsRefs,
      })
    >;
typedef $$IdiomTranslationsTableCreateCompanionBuilder =
    IdiomTranslationsCompanion Function({
      Value<int> id,
      required int idiomId,
      required String languageCode,
      required String textValue,
      Value<String?> notes,
    });
typedef $$IdiomTranslationsTableUpdateCompanionBuilder =
    IdiomTranslationsCompanion Function({
      Value<int> id,
      Value<int> idiomId,
      Value<String> languageCode,
      Value<String> textValue,
      Value<String?> notes,
    });

final class $$IdiomTranslationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IdiomTranslationsTable,
          IdiomTranslation
        > {
  $$IdiomTranslationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IdiomsTable _idiomIdTable(_$AppDatabase db) =>
      db.idioms.createAlias('idiom_translations__idiom_id__idioms__id');

  $$IdiomsTableProcessedTableManager get idiomId {
    final $_column = $_itemColumn<int>('idiom_id')!;

    final manager = $$IdiomsTableTableManager(
      $_db,
      $_db.idioms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idiomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LanguagesTable _languageCodeTable(_$AppDatabase db) => db.languages
      .createAlias('idiom_translations__language_code__languages__code');

  $$LanguagesTableProcessedTableManager get languageCode {
    final $_column = $_itemColumn<String>('language_code')!;

    final manager = $$LanguagesTableTableManager(
      $_db,
      $_db.languages,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_languageCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IdiomTranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $IdiomTranslationsTable> {
  $$IdiomTranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textValue => $composableBuilder(
    column: $table.textValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$IdiomsTableFilterComposer get idiomId {
    final $$IdiomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableFilterComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LanguagesTableFilterComposer get languageCode {
    final $$LanguagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.languageCode,
      referencedTable: $db.languages,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LanguagesTableFilterComposer(
            $db: $db,
            $table: $db.languages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdiomTranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $IdiomTranslationsTable> {
  $$IdiomTranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textValue => $composableBuilder(
    column: $table.textValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$IdiomsTableOrderingComposer get idiomId {
    final $$IdiomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableOrderingComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LanguagesTableOrderingComposer get languageCode {
    final $$LanguagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.languageCode,
      referencedTable: $db.languages,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LanguagesTableOrderingComposer(
            $db: $db,
            $table: $db.languages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdiomTranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IdiomTranslationsTable> {
  $$IdiomTranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textValue =>
      $composableBuilder(column: $table.textValue, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$IdiomsTableAnnotationComposer get idiomId {
    final $$IdiomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableAnnotationComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LanguagesTableAnnotationComposer get languageCode {
    final $$LanguagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.languageCode,
      referencedTable: $db.languages,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LanguagesTableAnnotationComposer(
            $db: $db,
            $table: $db.languages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdiomTranslationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IdiomTranslationsTable,
          IdiomTranslation,
          $$IdiomTranslationsTableFilterComposer,
          $$IdiomTranslationsTableOrderingComposer,
          $$IdiomTranslationsTableAnnotationComposer,
          $$IdiomTranslationsTableCreateCompanionBuilder,
          $$IdiomTranslationsTableUpdateCompanionBuilder,
          (IdiomTranslation, $$IdiomTranslationsTableReferences),
          IdiomTranslation,
          PrefetchHooks Function({bool idiomId, bool languageCode})
        > {
  $$IdiomTranslationsTableTableManager(
    _$AppDatabase db,
    $IdiomTranslationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IdiomTranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IdiomTranslationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IdiomTranslationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> idiomId = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<String> textValue = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => IdiomTranslationsCompanion(
                id: id,
                idiomId: idiomId,
                languageCode: languageCode,
                textValue: textValue,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int idiomId,
                required String languageCode,
                required String textValue,
                Value<String?> notes = const Value.absent(),
              }) => IdiomTranslationsCompanion.insert(
                id: id,
                idiomId: idiomId,
                languageCode: languageCode,
                textValue: textValue,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IdiomTranslationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idiomId = false, languageCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idiomId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idiomId,
                                referencedTable:
                                    $$IdiomTranslationsTableReferences
                                        ._idiomIdTable(db),
                                referencedColumn:
                                    $$IdiomTranslationsTableReferences
                                        ._idiomIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (languageCode) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.languageCode,
                                referencedTable:
                                    $$IdiomTranslationsTableReferences
                                        ._languageCodeTable(db),
                                referencedColumn:
                                    $$IdiomTranslationsTableReferences
                                        ._languageCodeTable(db)
                                        .code,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IdiomTranslationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IdiomTranslationsTable,
      IdiomTranslation,
      $$IdiomTranslationsTableFilterComposer,
      $$IdiomTranslationsTableOrderingComposer,
      $$IdiomTranslationsTableAnnotationComposer,
      $$IdiomTranslationsTableCreateCompanionBuilder,
      $$IdiomTranslationsTableUpdateCompanionBuilder,
      (IdiomTranslation, $$IdiomTranslationsTableReferences),
      IdiomTranslation,
      PrefetchHooks Function({bool idiomId, bool languageCode})
    >;
typedef $$DefinitionsTableCreateCompanionBuilder =
    DefinitionsCompanion Function({
      Value<int> id,
      required int idiomId,
      Value<int> displayOrder,
    });
typedef $$DefinitionsTableUpdateCompanionBuilder =
    DefinitionsCompanion Function({
      Value<int> id,
      Value<int> idiomId,
      Value<int> displayOrder,
    });

final class $$DefinitionsTableReferences
    extends BaseReferences<_$AppDatabase, $DefinitionsTable, Definition> {
  $$DefinitionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $IdiomsTable _idiomIdTable(_$AppDatabase db) =>
      db.idioms.createAlias('definitions__idiom_id__idioms__id');

  $$IdiomsTableProcessedTableManager get idiomId {
    final $_column = $_itemColumn<int>('idiom_id')!;

    final manager = $$IdiomsTableTableManager(
      $_db,
      $_db.idioms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idiomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $DefinitionTranslationsTable,
    List<DefinitionTranslation>
  >
  _definitionTranslationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.definitionTranslations,
        aliasName: 'definitions__id__definition_translations__definition_id',
      );

  $$DefinitionTranslationsTableProcessedTableManager
  get definitionTranslationsRefs {
    final manager = $$DefinitionTranslationsTableTableManager(
      $_db,
      $_db.definitionTranslations,
    ).filter((f) => f.definitionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _definitionTranslationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExamplesTable, List<Example>> _examplesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.examples,
    aliasName: 'definitions__id__examples__definition_id',
  );

  $$ExamplesTableProcessedTableManager get examplesRefs {
    final manager = $$ExamplesTableTableManager(
      $_db,
      $_db.examples,
    ).filter((f) => f.definitionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_examplesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DefinitionsTableFilterComposer
    extends Composer<_$AppDatabase, $DefinitionsTable> {
  $$DefinitionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$IdiomsTableFilterComposer get idiomId {
    final $$IdiomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableFilterComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> definitionTranslationsRefs(
    Expression<bool> Function($$DefinitionTranslationsTableFilterComposer f) f,
  ) {
    final $$DefinitionTranslationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.definitionTranslations,
          getReferencedColumn: (t) => t.definitionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DefinitionTranslationsTableFilterComposer(
                $db: $db,
                $table: $db.definitionTranslations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> examplesRefs(
    Expression<bool> Function($$ExamplesTableFilterComposer f) f,
  ) {
    final $$ExamplesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examples,
      getReferencedColumn: (t) => t.definitionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamplesTableFilterComposer(
            $db: $db,
            $table: $db.examples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DefinitionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DefinitionsTable> {
  $$DefinitionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$IdiomsTableOrderingComposer get idiomId {
    final $$IdiomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableOrderingComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DefinitionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DefinitionsTable> {
  $$DefinitionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  $$IdiomsTableAnnotationComposer get idiomId {
    final $$IdiomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableAnnotationComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> definitionTranslationsRefs<T extends Object>(
    Expression<T> Function($$DefinitionTranslationsTableAnnotationComposer a) f,
  ) {
    final $$DefinitionTranslationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.definitionTranslations,
          getReferencedColumn: (t) => t.definitionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DefinitionTranslationsTableAnnotationComposer(
                $db: $db,
                $table: $db.definitionTranslations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> examplesRefs<T extends Object>(
    Expression<T> Function($$ExamplesTableAnnotationComposer a) f,
  ) {
    final $$ExamplesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examples,
      getReferencedColumn: (t) => t.definitionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamplesTableAnnotationComposer(
            $db: $db,
            $table: $db.examples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DefinitionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DefinitionsTable,
          Definition,
          $$DefinitionsTableFilterComposer,
          $$DefinitionsTableOrderingComposer,
          $$DefinitionsTableAnnotationComposer,
          $$DefinitionsTableCreateCompanionBuilder,
          $$DefinitionsTableUpdateCompanionBuilder,
          (Definition, $$DefinitionsTableReferences),
          Definition,
          PrefetchHooks Function({
            bool idiomId,
            bool definitionTranslationsRefs,
            bool examplesRefs,
          })
        > {
  $$DefinitionsTableTableManager(_$AppDatabase db, $DefinitionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DefinitionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DefinitionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DefinitionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> idiomId = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
              }) => DefinitionsCompanion(
                id: id,
                idiomId: idiomId,
                displayOrder: displayOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int idiomId,
                Value<int> displayOrder = const Value.absent(),
              }) => DefinitionsCompanion.insert(
                id: id,
                idiomId: idiomId,
                displayOrder: displayOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DefinitionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                idiomId = false,
                definitionTranslationsRefs = false,
                examplesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (definitionTranslationsRefs) db.definitionTranslations,
                    if (examplesRefs) db.examples,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (idiomId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idiomId,
                                    referencedTable:
                                        $$DefinitionsTableReferences
                                            ._idiomIdTable(db),
                                    referencedColumn:
                                        $$DefinitionsTableReferences
                                            ._idiomIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (definitionTranslationsRefs)
                        await $_getPrefetchedData<
                          Definition,
                          $DefinitionsTable,
                          DefinitionTranslation
                        >(
                          currentTable: table,
                          referencedTable: $$DefinitionsTableReferences
                              ._definitionTranslationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DefinitionsTableReferences(
                                db,
                                table,
                                p0,
                              ).definitionTranslationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.definitionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (examplesRefs)
                        await $_getPrefetchedData<
                          Definition,
                          $DefinitionsTable,
                          Example
                        >(
                          currentTable: table,
                          referencedTable: $$DefinitionsTableReferences
                              ._examplesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DefinitionsTableReferences(
                                db,
                                table,
                                p0,
                              ).examplesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.definitionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DefinitionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DefinitionsTable,
      Definition,
      $$DefinitionsTableFilterComposer,
      $$DefinitionsTableOrderingComposer,
      $$DefinitionsTableAnnotationComposer,
      $$DefinitionsTableCreateCompanionBuilder,
      $$DefinitionsTableUpdateCompanionBuilder,
      (Definition, $$DefinitionsTableReferences),
      Definition,
      PrefetchHooks Function({
        bool idiomId,
        bool definitionTranslationsRefs,
        bool examplesRefs,
      })
    >;
typedef $$DefinitionTranslationsTableCreateCompanionBuilder =
    DefinitionTranslationsCompanion Function({
      Value<int> id,
      required int definitionId,
      required String languageCode,
      required String meaning,
    });
typedef $$DefinitionTranslationsTableUpdateCompanionBuilder =
    DefinitionTranslationsCompanion Function({
      Value<int> id,
      Value<int> definitionId,
      Value<String> languageCode,
      Value<String> meaning,
    });

final class $$DefinitionTranslationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DefinitionTranslationsTable,
          DefinitionTranslation
        > {
  $$DefinitionTranslationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DefinitionsTable _definitionIdTable(_$AppDatabase db) => db
      .definitions
      .createAlias('definition_translations__definition_id__definitions__id');

  $$DefinitionsTableProcessedTableManager get definitionId {
    final $_column = $_itemColumn<int>('definition_id')!;

    final manager = $$DefinitionsTableTableManager(
      $_db,
      $_db.definitions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_definitionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LanguagesTable _languageCodeTable(_$AppDatabase db) => db.languages
      .createAlias('definition_translations__language_code__languages__code');

  $$LanguagesTableProcessedTableManager get languageCode {
    final $_column = $_itemColumn<String>('language_code')!;

    final manager = $$LanguagesTableTableManager(
      $_db,
      $_db.languages,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_languageCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DefinitionTranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $DefinitionTranslationsTable> {
  $$DefinitionTranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnFilters(column),
  );

  $$DefinitionsTableFilterComposer get definitionId {
    final $$DefinitionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.definitionId,
      referencedTable: $db.definitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DefinitionsTableFilterComposer(
            $db: $db,
            $table: $db.definitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LanguagesTableFilterComposer get languageCode {
    final $$LanguagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.languageCode,
      referencedTable: $db.languages,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LanguagesTableFilterComposer(
            $db: $db,
            $table: $db.languages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DefinitionTranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $DefinitionTranslationsTable> {
  $$DefinitionTranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnOrderings(column),
  );

  $$DefinitionsTableOrderingComposer get definitionId {
    final $$DefinitionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.definitionId,
      referencedTable: $db.definitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DefinitionsTableOrderingComposer(
            $db: $db,
            $table: $db.definitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LanguagesTableOrderingComposer get languageCode {
    final $$LanguagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.languageCode,
      referencedTable: $db.languages,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LanguagesTableOrderingComposer(
            $db: $db,
            $table: $db.languages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DefinitionTranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DefinitionTranslationsTable> {
  $$DefinitionTranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get meaning =>
      $composableBuilder(column: $table.meaning, builder: (column) => column);

  $$DefinitionsTableAnnotationComposer get definitionId {
    final $$DefinitionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.definitionId,
      referencedTable: $db.definitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DefinitionsTableAnnotationComposer(
            $db: $db,
            $table: $db.definitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LanguagesTableAnnotationComposer get languageCode {
    final $$LanguagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.languageCode,
      referencedTable: $db.languages,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LanguagesTableAnnotationComposer(
            $db: $db,
            $table: $db.languages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DefinitionTranslationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DefinitionTranslationsTable,
          DefinitionTranslation,
          $$DefinitionTranslationsTableFilterComposer,
          $$DefinitionTranslationsTableOrderingComposer,
          $$DefinitionTranslationsTableAnnotationComposer,
          $$DefinitionTranslationsTableCreateCompanionBuilder,
          $$DefinitionTranslationsTableUpdateCompanionBuilder,
          (DefinitionTranslation, $$DefinitionTranslationsTableReferences),
          DefinitionTranslation,
          PrefetchHooks Function({bool definitionId, bool languageCode})
        > {
  $$DefinitionTranslationsTableTableManager(
    _$AppDatabase db,
    $DefinitionTranslationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DefinitionTranslationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DefinitionTranslationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DefinitionTranslationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> definitionId = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<String> meaning = const Value.absent(),
              }) => DefinitionTranslationsCompanion(
                id: id,
                definitionId: definitionId,
                languageCode: languageCode,
                meaning: meaning,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int definitionId,
                required String languageCode,
                required String meaning,
              }) => DefinitionTranslationsCompanion.insert(
                id: id,
                definitionId: definitionId,
                languageCode: languageCode,
                meaning: meaning,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DefinitionTranslationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({definitionId = false, languageCode = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (definitionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.definitionId,
                                    referencedTable:
                                        $$DefinitionTranslationsTableReferences
                                            ._definitionIdTable(db),
                                    referencedColumn:
                                        $$DefinitionTranslationsTableReferences
                                            ._definitionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (languageCode) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.languageCode,
                                    referencedTable:
                                        $$DefinitionTranslationsTableReferences
                                            ._languageCodeTable(db),
                                    referencedColumn:
                                        $$DefinitionTranslationsTableReferences
                                            ._languageCodeTable(db)
                                            .code,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$DefinitionTranslationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DefinitionTranslationsTable,
      DefinitionTranslation,
      $$DefinitionTranslationsTableFilterComposer,
      $$DefinitionTranslationsTableOrderingComposer,
      $$DefinitionTranslationsTableAnnotationComposer,
      $$DefinitionTranslationsTableCreateCompanionBuilder,
      $$DefinitionTranslationsTableUpdateCompanionBuilder,
      (DefinitionTranslation, $$DefinitionTranslationsTableReferences),
      DefinitionTranslation,
      PrefetchHooks Function({bool definitionId, bool languageCode})
    >;
typedef $$ExamplesTableCreateCompanionBuilder =
    ExamplesCompanion Function({
      Value<int> id,
      required int idiomId,
      Value<int?> definitionId,
      Value<int> displayOrder,
    });
typedef $$ExamplesTableUpdateCompanionBuilder =
    ExamplesCompanion Function({
      Value<int> id,
      Value<int> idiomId,
      Value<int?> definitionId,
      Value<int> displayOrder,
    });

final class $$ExamplesTableReferences
    extends BaseReferences<_$AppDatabase, $ExamplesTable, Example> {
  $$ExamplesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $IdiomsTable _idiomIdTable(_$AppDatabase db) =>
      db.idioms.createAlias('examples__idiom_id__idioms__id');

  $$IdiomsTableProcessedTableManager get idiomId {
    final $_column = $_itemColumn<int>('idiom_id')!;

    final manager = $$IdiomsTableTableManager(
      $_db,
      $_db.idioms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idiomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DefinitionsTable _definitionIdTable(_$AppDatabase db) =>
      db.definitions.createAlias('examples__definition_id__definitions__id');

  $$DefinitionsTableProcessedTableManager? get definitionId {
    final $_column = $_itemColumn<int>('definition_id');
    if ($_column == null) return null;
    final manager = $$DefinitionsTableTableManager(
      $_db,
      $_db.definitions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_definitionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ExampleTranslationsTable,
    List<ExampleTranslation>
  >
  _exampleTranslationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.exampleTranslations,
        aliasName: 'examples__id__example_translations__example_id',
      );

  $$ExampleTranslationsTableProcessedTableManager get exampleTranslationsRefs {
    final manager = $$ExampleTranslationsTableTableManager(
      $_db,
      $_db.exampleTranslations,
    ).filter((f) => f.exampleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _exampleTranslationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExamplesTableFilterComposer
    extends Composer<_$AppDatabase, $ExamplesTable> {
  $$ExamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$IdiomsTableFilterComposer get idiomId {
    final $$IdiomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableFilterComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DefinitionsTableFilterComposer get definitionId {
    final $$DefinitionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.definitionId,
      referencedTable: $db.definitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DefinitionsTableFilterComposer(
            $db: $db,
            $table: $db.definitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> exampleTranslationsRefs(
    Expression<bool> Function($$ExampleTranslationsTableFilterComposer f) f,
  ) {
    final $$ExampleTranslationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exampleTranslations,
      getReferencedColumn: (t) => t.exampleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExampleTranslationsTableFilterComposer(
            $db: $db,
            $table: $db.exampleTranslations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamplesTable> {
  $$ExamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$IdiomsTableOrderingComposer get idiomId {
    final $$IdiomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableOrderingComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DefinitionsTableOrderingComposer get definitionId {
    final $$DefinitionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.definitionId,
      referencedTable: $db.definitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DefinitionsTableOrderingComposer(
            $db: $db,
            $table: $db.definitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamplesTable> {
  $$ExamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  $$IdiomsTableAnnotationComposer get idiomId {
    final $$IdiomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableAnnotationComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DefinitionsTableAnnotationComposer get definitionId {
    final $$DefinitionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.definitionId,
      referencedTable: $db.definitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DefinitionsTableAnnotationComposer(
            $db: $db,
            $table: $db.definitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> exampleTranslationsRefs<T extends Object>(
    Expression<T> Function($$ExampleTranslationsTableAnnotationComposer a) f,
  ) {
    final $$ExampleTranslationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.exampleTranslations,
          getReferencedColumn: (t) => t.exampleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExampleTranslationsTableAnnotationComposer(
                $db: $db,
                $table: $db.exampleTranslations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ExamplesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamplesTable,
          Example,
          $$ExamplesTableFilterComposer,
          $$ExamplesTableOrderingComposer,
          $$ExamplesTableAnnotationComposer,
          $$ExamplesTableCreateCompanionBuilder,
          $$ExamplesTableUpdateCompanionBuilder,
          (Example, $$ExamplesTableReferences),
          Example,
          PrefetchHooks Function({
            bool idiomId,
            bool definitionId,
            bool exampleTranslationsRefs,
          })
        > {
  $$ExamplesTableTableManager(_$AppDatabase db, $ExamplesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> idiomId = const Value.absent(),
                Value<int?> definitionId = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
              }) => ExamplesCompanion(
                id: id,
                idiomId: idiomId,
                definitionId: definitionId,
                displayOrder: displayOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int idiomId,
                Value<int?> definitionId = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
              }) => ExamplesCompanion.insert(
                id: id,
                idiomId: idiomId,
                definitionId: definitionId,
                displayOrder: displayOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExamplesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                idiomId = false,
                definitionId = false,
                exampleTranslationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (exampleTranslationsRefs) db.exampleTranslations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (idiomId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idiomId,
                                    referencedTable: $$ExamplesTableReferences
                                        ._idiomIdTable(db),
                                    referencedColumn: $$ExamplesTableReferences
                                        ._idiomIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (definitionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.definitionId,
                                    referencedTable: $$ExamplesTableReferences
                                        ._definitionIdTable(db),
                                    referencedColumn: $$ExamplesTableReferences
                                        ._definitionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (exampleTranslationsRefs)
                        await $_getPrefetchedData<
                          Example,
                          $ExamplesTable,
                          ExampleTranslation
                        >(
                          currentTable: table,
                          referencedTable: $$ExamplesTableReferences
                              ._exampleTranslationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExamplesTableReferences(
                                db,
                                table,
                                p0,
                              ).exampleTranslationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exampleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamplesTable,
      Example,
      $$ExamplesTableFilterComposer,
      $$ExamplesTableOrderingComposer,
      $$ExamplesTableAnnotationComposer,
      $$ExamplesTableCreateCompanionBuilder,
      $$ExamplesTableUpdateCompanionBuilder,
      (Example, $$ExamplesTableReferences),
      Example,
      PrefetchHooks Function({
        bool idiomId,
        bool definitionId,
        bool exampleTranslationsRefs,
      })
    >;
typedef $$ExampleTranslationsTableCreateCompanionBuilder =
    ExampleTranslationsCompanion Function({
      Value<int> id,
      required int exampleId,
      required String languageCode,
      required String sentence,
    });
typedef $$ExampleTranslationsTableUpdateCompanionBuilder =
    ExampleTranslationsCompanion Function({
      Value<int> id,
      Value<int> exampleId,
      Value<String> languageCode,
      Value<String> sentence,
    });

final class $$ExampleTranslationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ExampleTranslationsTable,
          ExampleTranslation
        > {
  $$ExampleTranslationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExamplesTable _exampleIdTable(_$AppDatabase db) =>
      db.examples.createAlias('example_translations__example_id__examples__id');

  $$ExamplesTableProcessedTableManager get exampleId {
    final $_column = $_itemColumn<int>('example_id')!;

    final manager = $$ExamplesTableTableManager(
      $_db,
      $_db.examples,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exampleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LanguagesTable _languageCodeTable(_$AppDatabase db) => db.languages
      .createAlias('example_translations__language_code__languages__code');

  $$LanguagesTableProcessedTableManager get languageCode {
    final $_column = $_itemColumn<String>('language_code')!;

    final manager = $$LanguagesTableTableManager(
      $_db,
      $_db.languages,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_languageCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExampleTranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $ExampleTranslationsTable> {
  $$ExampleTranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sentence => $composableBuilder(
    column: $table.sentence,
    builder: (column) => ColumnFilters(column),
  );

  $$ExamplesTableFilterComposer get exampleId {
    final $$ExamplesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exampleId,
      referencedTable: $db.examples,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamplesTableFilterComposer(
            $db: $db,
            $table: $db.examples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LanguagesTableFilterComposer get languageCode {
    final $$LanguagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.languageCode,
      referencedTable: $db.languages,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LanguagesTableFilterComposer(
            $db: $db,
            $table: $db.languages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExampleTranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExampleTranslationsTable> {
  $$ExampleTranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sentence => $composableBuilder(
    column: $table.sentence,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExamplesTableOrderingComposer get exampleId {
    final $$ExamplesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exampleId,
      referencedTable: $db.examples,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamplesTableOrderingComposer(
            $db: $db,
            $table: $db.examples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LanguagesTableOrderingComposer get languageCode {
    final $$LanguagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.languageCode,
      referencedTable: $db.languages,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LanguagesTableOrderingComposer(
            $db: $db,
            $table: $db.languages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExampleTranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExampleTranslationsTable> {
  $$ExampleTranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sentence =>
      $composableBuilder(column: $table.sentence, builder: (column) => column);

  $$ExamplesTableAnnotationComposer get exampleId {
    final $$ExamplesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exampleId,
      referencedTable: $db.examples,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamplesTableAnnotationComposer(
            $db: $db,
            $table: $db.examples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LanguagesTableAnnotationComposer get languageCode {
    final $$LanguagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.languageCode,
      referencedTable: $db.languages,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LanguagesTableAnnotationComposer(
            $db: $db,
            $table: $db.languages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExampleTranslationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExampleTranslationsTable,
          ExampleTranslation,
          $$ExampleTranslationsTableFilterComposer,
          $$ExampleTranslationsTableOrderingComposer,
          $$ExampleTranslationsTableAnnotationComposer,
          $$ExampleTranslationsTableCreateCompanionBuilder,
          $$ExampleTranslationsTableUpdateCompanionBuilder,
          (ExampleTranslation, $$ExampleTranslationsTableReferences),
          ExampleTranslation,
          PrefetchHooks Function({bool exampleId, bool languageCode})
        > {
  $$ExampleTranslationsTableTableManager(
    _$AppDatabase db,
    $ExampleTranslationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExampleTranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExampleTranslationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ExampleTranslationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> exampleId = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<String> sentence = const Value.absent(),
              }) => ExampleTranslationsCompanion(
                id: id,
                exampleId: exampleId,
                languageCode: languageCode,
                sentence: sentence,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int exampleId,
                required String languageCode,
                required String sentence,
              }) => ExampleTranslationsCompanion.insert(
                id: id,
                exampleId: exampleId,
                languageCode: languageCode,
                sentence: sentence,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExampleTranslationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exampleId = false, languageCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (exampleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.exampleId,
                                referencedTable:
                                    $$ExampleTranslationsTableReferences
                                        ._exampleIdTable(db),
                                referencedColumn:
                                    $$ExampleTranslationsTableReferences
                                        ._exampleIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (languageCode) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.languageCode,
                                referencedTable:
                                    $$ExampleTranslationsTableReferences
                                        ._languageCodeTable(db),
                                referencedColumn:
                                    $$ExampleTranslationsTableReferences
                                        ._languageCodeTable(db)
                                        .code,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExampleTranslationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExampleTranslationsTable,
      ExampleTranslation,
      $$ExampleTranslationsTableFilterComposer,
      $$ExampleTranslationsTableOrderingComposer,
      $$ExampleTranslationsTableAnnotationComposer,
      $$ExampleTranslationsTableCreateCompanionBuilder,
      $$ExampleTranslationsTableUpdateCompanionBuilder,
      (ExampleTranslation, $$ExampleTranslationsTableReferences),
      ExampleTranslation,
      PrefetchHooks Function({bool exampleId, bool languageCode})
    >;
typedef $$IdiomCategoriesTableCreateCompanionBuilder =
    IdiomCategoriesCompanion Function({
      required int idiomId,
      required String categoryId,
      Value<int> rowid,
    });
typedef $$IdiomCategoriesTableUpdateCompanionBuilder =
    IdiomCategoriesCompanion Function({
      Value<int> idiomId,
      Value<String> categoryId,
      Value<int> rowid,
    });

final class $$IdiomCategoriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $IdiomCategoriesTable, IdiomCategory> {
  $$IdiomCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IdiomsTable _idiomIdTable(_$AppDatabase db) =>
      db.idioms.createAlias('idiom_categories__idiom_id__idioms__id');

  $$IdiomsTableProcessedTableManager get idiomId {
    final $_column = $_itemColumn<int>('idiom_id')!;

    final manager = $$IdiomsTableTableManager(
      $_db,
      $_db.idioms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idiomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) => db.categories
      .createAlias('idiom_categories__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IdiomCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $IdiomCategoriesTable> {
  $$IdiomCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$IdiomsTableFilterComposer get idiomId {
    final $$IdiomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableFilterComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdiomCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $IdiomCategoriesTable> {
  $$IdiomCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$IdiomsTableOrderingComposer get idiomId {
    final $$IdiomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableOrderingComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdiomCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IdiomCategoriesTable> {
  $$IdiomCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$IdiomsTableAnnotationComposer get idiomId {
    final $$IdiomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableAnnotationComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdiomCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IdiomCategoriesTable,
          IdiomCategory,
          $$IdiomCategoriesTableFilterComposer,
          $$IdiomCategoriesTableOrderingComposer,
          $$IdiomCategoriesTableAnnotationComposer,
          $$IdiomCategoriesTableCreateCompanionBuilder,
          $$IdiomCategoriesTableUpdateCompanionBuilder,
          (IdiomCategory, $$IdiomCategoriesTableReferences),
          IdiomCategory,
          PrefetchHooks Function({bool idiomId, bool categoryId})
        > {
  $$IdiomCategoriesTableTableManager(
    _$AppDatabase db,
    $IdiomCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IdiomCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IdiomCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IdiomCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idiomId = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdiomCategoriesCompanion(
                idiomId: idiomId,
                categoryId: categoryId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int idiomId,
                required String categoryId,
                Value<int> rowid = const Value.absent(),
              }) => IdiomCategoriesCompanion.insert(
                idiomId: idiomId,
                categoryId: categoryId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IdiomCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idiomId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idiomId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idiomId,
                                referencedTable:
                                    $$IdiomCategoriesTableReferences
                                        ._idiomIdTable(db),
                                referencedColumn:
                                    $$IdiomCategoriesTableReferences
                                        ._idiomIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable:
                                    $$IdiomCategoriesTableReferences
                                        ._categoryIdTable(db),
                                referencedColumn:
                                    $$IdiomCategoriesTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IdiomCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IdiomCategoriesTable,
      IdiomCategory,
      $$IdiomCategoriesTableFilterComposer,
      $$IdiomCategoriesTableOrderingComposer,
      $$IdiomCategoriesTableAnnotationComposer,
      $$IdiomCategoriesTableCreateCompanionBuilder,
      $$IdiomCategoriesTableUpdateCompanionBuilder,
      (IdiomCategory, $$IdiomCategoriesTableReferences),
      IdiomCategory,
      PrefetchHooks Function({bool idiomId, bool categoryId})
    >;
typedef $$FavoriteIdiomsTableCreateCompanionBuilder =
    FavoriteIdiomsCompanion Function({
      Value<int> idiomId,
      Value<DateTime> createdAt,
    });
typedef $$FavoriteIdiomsTableUpdateCompanionBuilder =
    FavoriteIdiomsCompanion Function({
      Value<int> idiomId,
      Value<DateTime> createdAt,
    });

final class $$FavoriteIdiomsTableReferences
    extends BaseReferences<_$AppDatabase, $FavoriteIdiomsTable, FavoriteIdiom> {
  $$FavoriteIdiomsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IdiomsTable _idiomIdTable(_$AppDatabase db) =>
      db.idioms.createAlias('favorite_idioms__idiom_id__idioms__id');

  $$IdiomsTableProcessedTableManager get idiomId {
    final $_column = $_itemColumn<int>('idiom_id')!;

    final manager = $$IdiomsTableTableManager(
      $_db,
      $_db.idioms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idiomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FavoriteIdiomsTableFilterComposer
    extends Composer<_$AppDatabase, $FavoriteIdiomsTable> {
  $$FavoriteIdiomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$IdiomsTableFilterComposer get idiomId {
    final $$IdiomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableFilterComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoriteIdiomsTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoriteIdiomsTable> {
  $$FavoriteIdiomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$IdiomsTableOrderingComposer get idiomId {
    final $$IdiomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableOrderingComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoriteIdiomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoriteIdiomsTable> {
  $$FavoriteIdiomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$IdiomsTableAnnotationComposer get idiomId {
    final $$IdiomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableAnnotationComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoriteIdiomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoriteIdiomsTable,
          FavoriteIdiom,
          $$FavoriteIdiomsTableFilterComposer,
          $$FavoriteIdiomsTableOrderingComposer,
          $$FavoriteIdiomsTableAnnotationComposer,
          $$FavoriteIdiomsTableCreateCompanionBuilder,
          $$FavoriteIdiomsTableUpdateCompanionBuilder,
          (FavoriteIdiom, $$FavoriteIdiomsTableReferences),
          FavoriteIdiom,
          PrefetchHooks Function({bool idiomId})
        > {
  $$FavoriteIdiomsTableTableManager(
    _$AppDatabase db,
    $FavoriteIdiomsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoriteIdiomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoriteIdiomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoriteIdiomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idiomId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FavoriteIdiomsCompanion(
                idiomId: idiomId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> idiomId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FavoriteIdiomsCompanion.insert(
                idiomId: idiomId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FavoriteIdiomsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idiomId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idiomId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idiomId,
                                referencedTable: $$FavoriteIdiomsTableReferences
                                    ._idiomIdTable(db),
                                referencedColumn:
                                    $$FavoriteIdiomsTableReferences
                                        ._idiomIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FavoriteIdiomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoriteIdiomsTable,
      FavoriteIdiom,
      $$FavoriteIdiomsTableFilterComposer,
      $$FavoriteIdiomsTableOrderingComposer,
      $$FavoriteIdiomsTableAnnotationComposer,
      $$FavoriteIdiomsTableCreateCompanionBuilder,
      $$FavoriteIdiomsTableUpdateCompanionBuilder,
      (FavoriteIdiom, $$FavoriteIdiomsTableReferences),
      FavoriteIdiom,
      PrefetchHooks Function({bool idiomId})
    >;
typedef $$FlashcardGroupsTableCreateCompanionBuilder =
    FlashcardGroupsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> categoryId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$FlashcardGroupsTableUpdateCompanionBuilder =
    FlashcardGroupsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> categoryId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$FlashcardGroupsTableReferences
    extends
        BaseReferences<_$AppDatabase, $FlashcardGroupsTable, FlashcardGroup> {
  $$FlashcardGroupsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) => db.categories
      .createAlias('flashcard_groups__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $FlashcardGroupItemsTable,
    List<FlashcardGroupItem>
  >
  _flashcardGroupItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.flashcardGroupItems,
        aliasName: 'flashcard_groups__id__flashcard_group_items__group_id',
      );

  $$FlashcardGroupItemsTableProcessedTableManager get flashcardGroupItemsRefs {
    final manager = $$FlashcardGroupItemsTableTableManager(
      $_db,
      $_db.flashcardGroupItems,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _flashcardGroupItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FlashcardGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $FlashcardGroupsTable> {
  $$FlashcardGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> flashcardGroupItemsRefs(
    Expression<bool> Function($$FlashcardGroupItemsTableFilterComposer f) f,
  ) {
    final $$FlashcardGroupItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flashcardGroupItems,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardGroupItemsTableFilterComposer(
            $db: $db,
            $table: $db.flashcardGroupItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FlashcardGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $FlashcardGroupsTable> {
  $$FlashcardGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlashcardGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlashcardGroupsTable> {
  $$FlashcardGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> flashcardGroupItemsRefs<T extends Object>(
    Expression<T> Function($$FlashcardGroupItemsTableAnnotationComposer a) f,
  ) {
    final $$FlashcardGroupItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.flashcardGroupItems,
          getReferencedColumn: (t) => t.groupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FlashcardGroupItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.flashcardGroupItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$FlashcardGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlashcardGroupsTable,
          FlashcardGroup,
          $$FlashcardGroupsTableFilterComposer,
          $$FlashcardGroupsTableOrderingComposer,
          $$FlashcardGroupsTableAnnotationComposer,
          $$FlashcardGroupsTableCreateCompanionBuilder,
          $$FlashcardGroupsTableUpdateCompanionBuilder,
          (FlashcardGroup, $$FlashcardGroupsTableReferences),
          FlashcardGroup,
          PrefetchHooks Function({
            bool categoryId,
            bool flashcardGroupItemsRefs,
          })
        > {
  $$FlashcardGroupsTableTableManager(
    _$AppDatabase db,
    $FlashcardGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlashcardGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlashcardGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlashcardGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FlashcardGroupsCompanion(
                id: id,
                name: name,
                categoryId: categoryId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> categoryId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FlashcardGroupsCompanion.insert(
                id: id,
                name: name,
                categoryId: categoryId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FlashcardGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoryId = false, flashcardGroupItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (flashcardGroupItemsRefs) db.flashcardGroupItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$FlashcardGroupsTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$FlashcardGroupsTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (flashcardGroupItemsRefs)
                        await $_getPrefetchedData<
                          FlashcardGroup,
                          $FlashcardGroupsTable,
                          FlashcardGroupItem
                        >(
                          currentTable: table,
                          referencedTable: $$FlashcardGroupsTableReferences
                              ._flashcardGroupItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FlashcardGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).flashcardGroupItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FlashcardGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlashcardGroupsTable,
      FlashcardGroup,
      $$FlashcardGroupsTableFilterComposer,
      $$FlashcardGroupsTableOrderingComposer,
      $$FlashcardGroupsTableAnnotationComposer,
      $$FlashcardGroupsTableCreateCompanionBuilder,
      $$FlashcardGroupsTableUpdateCompanionBuilder,
      (FlashcardGroup, $$FlashcardGroupsTableReferences),
      FlashcardGroup,
      PrefetchHooks Function({bool categoryId, bool flashcardGroupItemsRefs})
    >;
typedef $$FlashcardGroupItemsTableCreateCompanionBuilder =
    FlashcardGroupItemsCompanion Function({
      Value<int> id,
      required int groupId,
      required int idiomId,
      Value<DateTime> createdAt,
    });
typedef $$FlashcardGroupItemsTableUpdateCompanionBuilder =
    FlashcardGroupItemsCompanion Function({
      Value<int> id,
      Value<int> groupId,
      Value<int> idiomId,
      Value<DateTime> createdAt,
    });

final class $$FlashcardGroupItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FlashcardGroupItemsTable,
          FlashcardGroupItem
        > {
  $$FlashcardGroupItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FlashcardGroupsTable _groupIdTable(_$AppDatabase db) => db
      .flashcardGroups
      .createAlias('flashcard_group_items__group_id__flashcard_groups__id');

  $$FlashcardGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$FlashcardGroupsTableTableManager(
      $_db,
      $_db.flashcardGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IdiomsTable _idiomIdTable(_$AppDatabase db) =>
      db.idioms.createAlias('flashcard_group_items__idiom_id__idioms__id');

  $$IdiomsTableProcessedTableManager get idiomId {
    final $_column = $_itemColumn<int>('idiom_id')!;

    final manager = $$IdiomsTableTableManager(
      $_db,
      $_db.idioms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idiomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FlashcardGroupItemsTableFilterComposer
    extends Composer<_$AppDatabase, $FlashcardGroupItemsTable> {
  $$FlashcardGroupItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FlashcardGroupsTableFilterComposer get groupId {
    final $$FlashcardGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.flashcardGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardGroupsTableFilterComposer(
            $db: $db,
            $table: $db.flashcardGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IdiomsTableFilterComposer get idiomId {
    final $$IdiomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableFilterComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlashcardGroupItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $FlashcardGroupItemsTable> {
  $$FlashcardGroupItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FlashcardGroupsTableOrderingComposer get groupId {
    final $$FlashcardGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.flashcardGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.flashcardGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IdiomsTableOrderingComposer get idiomId {
    final $$IdiomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableOrderingComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlashcardGroupItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlashcardGroupItemsTable> {
  $$FlashcardGroupItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$FlashcardGroupsTableAnnotationComposer get groupId {
    final $$FlashcardGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.flashcardGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.flashcardGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IdiomsTableAnnotationComposer get idiomId {
    final $$IdiomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableAnnotationComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlashcardGroupItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlashcardGroupItemsTable,
          FlashcardGroupItem,
          $$FlashcardGroupItemsTableFilterComposer,
          $$FlashcardGroupItemsTableOrderingComposer,
          $$FlashcardGroupItemsTableAnnotationComposer,
          $$FlashcardGroupItemsTableCreateCompanionBuilder,
          $$FlashcardGroupItemsTableUpdateCompanionBuilder,
          (FlashcardGroupItem, $$FlashcardGroupItemsTableReferences),
          FlashcardGroupItem,
          PrefetchHooks Function({bool groupId, bool idiomId})
        > {
  $$FlashcardGroupItemsTableTableManager(
    _$AppDatabase db,
    $FlashcardGroupItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlashcardGroupItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlashcardGroupItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FlashcardGroupItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> groupId = const Value.absent(),
                Value<int> idiomId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FlashcardGroupItemsCompanion(
                id: id,
                groupId: groupId,
                idiomId: idiomId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int groupId,
                required int idiomId,
                Value<DateTime> createdAt = const Value.absent(),
              }) => FlashcardGroupItemsCompanion.insert(
                id: id,
                groupId: groupId,
                idiomId: idiomId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FlashcardGroupItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, idiomId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable:
                                    $$FlashcardGroupItemsTableReferences
                                        ._groupIdTable(db),
                                referencedColumn:
                                    $$FlashcardGroupItemsTableReferences
                                        ._groupIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (idiomId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idiomId,
                                referencedTable:
                                    $$FlashcardGroupItemsTableReferences
                                        ._idiomIdTable(db),
                                referencedColumn:
                                    $$FlashcardGroupItemsTableReferences
                                        ._idiomIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FlashcardGroupItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlashcardGroupItemsTable,
      FlashcardGroupItem,
      $$FlashcardGroupItemsTableFilterComposer,
      $$FlashcardGroupItemsTableOrderingComposer,
      $$FlashcardGroupItemsTableAnnotationComposer,
      $$FlashcardGroupItemsTableCreateCompanionBuilder,
      $$FlashcardGroupItemsTableUpdateCompanionBuilder,
      (FlashcardGroupItem, $$FlashcardGroupItemsTableReferences),
      FlashcardGroupItem,
      PrefetchHooks Function({bool groupId, bool idiomId})
    >;
typedef $$QuizAttemptsTableCreateCompanionBuilder =
    QuizAttemptsCompanion Function({
      Value<int> id,
      required int totalQuestions,
      required int correctAnswers,
      required int durationSeconds,
      Value<DateTime> completedAt,
    });
typedef $$QuizAttemptsTableUpdateCompanionBuilder =
    QuizAttemptsCompanion Function({
      Value<int> id,
      Value<int> totalQuestions,
      Value<int> correctAnswers,
      Value<int> durationSeconds,
      Value<DateTime> completedAt,
    });

final class $$QuizAttemptsTableReferences
    extends BaseReferences<_$AppDatabase, $QuizAttemptsTable, QuizAttempt> {
  $$QuizAttemptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$QuizAttemptAnswersTable, List<QuizAttemptAnswer>>
  _quizAttemptAnswersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.quizAttemptAnswers,
        aliasName: 'quiz_attempts__id__quiz_attempt_answers__attempt_id',
      );

  $$QuizAttemptAnswersTableProcessedTableManager get quizAttemptAnswersRefs {
    final manager = $$QuizAttemptAnswersTableTableManager(
      $_db,
      $_db.quizAttemptAnswers,
    ).filter((f) => f.attemptId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _quizAttemptAnswersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuizAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> quizAttemptAnswersRefs(
    Expression<bool> Function($$QuizAttemptAnswersTableFilterComposer f) f,
  ) {
    final $$QuizAttemptAnswersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizAttemptAnswers,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptAnswersTableFilterComposer(
            $db: $db,
            $table: $db.quizAttemptAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuizAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuizAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  Expression<T> quizAttemptAnswersRefs<T extends Object>(
    Expression<T> Function($$QuizAttemptAnswersTableAnnotationComposer a) f,
  ) {
    final $$QuizAttemptAnswersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.quizAttemptAnswers,
          getReferencedColumn: (t) => t.attemptId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$QuizAttemptAnswersTableAnnotationComposer(
                $db: $db,
                $table: $db.quizAttemptAnswers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$QuizAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizAttemptsTable,
          QuizAttempt,
          $$QuizAttemptsTableFilterComposer,
          $$QuizAttemptsTableOrderingComposer,
          $$QuizAttemptsTableAnnotationComposer,
          $$QuizAttemptsTableCreateCompanionBuilder,
          $$QuizAttemptsTableUpdateCompanionBuilder,
          (QuizAttempt, $$QuizAttemptsTableReferences),
          QuizAttempt,
          PrefetchHooks Function({bool quizAttemptAnswersRefs})
        > {
  $$QuizAttemptsTableTableManager(_$AppDatabase db, $QuizAttemptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> totalQuestions = const Value.absent(),
                Value<int> correctAnswers = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
              }) => QuizAttemptsCompanion(
                id: id,
                totalQuestions: totalQuestions,
                correctAnswers: correctAnswers,
                durationSeconds: durationSeconds,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int totalQuestions,
                required int correctAnswers,
                required int durationSeconds,
                Value<DateTime> completedAt = const Value.absent(),
              }) => QuizAttemptsCompanion.insert(
                id: id,
                totalQuestions: totalQuestions,
                correctAnswers: correctAnswers,
                durationSeconds: durationSeconds,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizAttemptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({quizAttemptAnswersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (quizAttemptAnswersRefs) db.quizAttemptAnswers,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (quizAttemptAnswersRefs)
                    await $_getPrefetchedData<
                      QuizAttempt,
                      $QuizAttemptsTable,
                      QuizAttemptAnswer
                    >(
                      currentTable: table,
                      referencedTable: $$QuizAttemptsTableReferences
                          ._quizAttemptAnswersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$QuizAttemptsTableReferences(
                            db,
                            table,
                            p0,
                          ).quizAttemptAnswersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.attemptId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$QuizAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizAttemptsTable,
      QuizAttempt,
      $$QuizAttemptsTableFilterComposer,
      $$QuizAttemptsTableOrderingComposer,
      $$QuizAttemptsTableAnnotationComposer,
      $$QuizAttemptsTableCreateCompanionBuilder,
      $$QuizAttemptsTableUpdateCompanionBuilder,
      (QuizAttempt, $$QuizAttemptsTableReferences),
      QuizAttempt,
      PrefetchHooks Function({bool quizAttemptAnswersRefs})
    >;
typedef $$QuizAttemptAnswersTableCreateCompanionBuilder =
    QuizAttemptAnswersCompanion Function({
      Value<int> id,
      required int attemptId,
      required int questionOrder,
      required int idiomId,
      Value<int?> selectedIdiomId,
      required int correctIdiomId,
      required String optionIdiomIds,
    });
typedef $$QuizAttemptAnswersTableUpdateCompanionBuilder =
    QuizAttemptAnswersCompanion Function({
      Value<int> id,
      Value<int> attemptId,
      Value<int> questionOrder,
      Value<int> idiomId,
      Value<int?> selectedIdiomId,
      Value<int> correctIdiomId,
      Value<String> optionIdiomIds,
    });

final class $$QuizAttemptAnswersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $QuizAttemptAnswersTable,
          QuizAttemptAnswer
        > {
  $$QuizAttemptAnswersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuizAttemptsTable _attemptIdTable(_$AppDatabase db) => db.quizAttempts
      .createAlias('quiz_attempt_answers__attempt_id__quiz_attempts__id');

  $$QuizAttemptsTableProcessedTableManager get attemptId {
    final $_column = $_itemColumn<int>('attempt_id')!;

    final manager = $$QuizAttemptsTableTableManager(
      $_db,
      $_db.quizAttempts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_attemptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IdiomsTable _idiomIdTable(_$AppDatabase db) =>
      db.idioms.createAlias('quiz_attempt_answers__idiom_id__idioms__id');

  $$IdiomsTableProcessedTableManager get idiomId {
    final $_column = $_itemColumn<int>('idiom_id')!;

    final manager = $$IdiomsTableTableManager(
      $_db,
      $_db.idioms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idiomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IdiomsTable _selectedIdiomIdTable(_$AppDatabase db) => db.idioms
      .createAlias('quiz_attempt_answers__selected_idiom_id__idioms__id');

  $$IdiomsTableProcessedTableManager? get selectedIdiomId {
    final $_column = $_itemColumn<int>('selected_idiom_id');
    if ($_column == null) return null;
    final manager = $$IdiomsTableTableManager(
      $_db,
      $_db.idioms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_selectedIdiomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IdiomsTable _correctIdiomIdTable(_$AppDatabase db) => db.idioms
      .createAlias('quiz_attempt_answers__correct_idiom_id__idioms__id');

  $$IdiomsTableProcessedTableManager get correctIdiomId {
    final $_column = $_itemColumn<int>('correct_idiom_id')!;

    final manager = $$IdiomsTableTableManager(
      $_db,
      $_db.idioms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_correctIdiomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuizAttemptAnswersTableFilterComposer
    extends Composer<_$AppDatabase, $QuizAttemptAnswersTable> {
  $$QuizAttemptAnswersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionOrder => $composableBuilder(
    column: $table.questionOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionIdiomIds => $composableBuilder(
    column: $table.optionIdiomIds,
    builder: (column) => ColumnFilters(column),
  );

  $$QuizAttemptsTableFilterComposer get attemptId {
    final $$QuizAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IdiomsTableFilterComposer get idiomId {
    final $$IdiomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableFilterComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IdiomsTableFilterComposer get selectedIdiomId {
    final $$IdiomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.selectedIdiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableFilterComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IdiomsTableFilterComposer get correctIdiomId {
    final $$IdiomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.correctIdiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableFilterComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizAttemptAnswersTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizAttemptAnswersTable> {
  $$QuizAttemptAnswersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionOrder => $composableBuilder(
    column: $table.questionOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionIdiomIds => $composableBuilder(
    column: $table.optionIdiomIds,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuizAttemptsTableOrderingComposer get attemptId {
    final $$QuizAttemptsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableOrderingComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IdiomsTableOrderingComposer get idiomId {
    final $$IdiomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableOrderingComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IdiomsTableOrderingComposer get selectedIdiomId {
    final $$IdiomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.selectedIdiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableOrderingComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IdiomsTableOrderingComposer get correctIdiomId {
    final $$IdiomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.correctIdiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableOrderingComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizAttemptAnswersTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizAttemptAnswersTable> {
  $$QuizAttemptAnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get questionOrder => $composableBuilder(
    column: $table.questionOrder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get optionIdiomIds => $composableBuilder(
    column: $table.optionIdiomIds,
    builder: (column) => column,
  );

  $$QuizAttemptsTableAnnotationComposer get attemptId {
    final $$QuizAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IdiomsTableAnnotationComposer get idiomId {
    final $$IdiomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableAnnotationComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IdiomsTableAnnotationComposer get selectedIdiomId {
    final $$IdiomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.selectedIdiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableAnnotationComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IdiomsTableAnnotationComposer get correctIdiomId {
    final $$IdiomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.correctIdiomId,
      referencedTable: $db.idioms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdiomsTableAnnotationComposer(
            $db: $db,
            $table: $db.idioms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizAttemptAnswersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizAttemptAnswersTable,
          QuizAttemptAnswer,
          $$QuizAttemptAnswersTableFilterComposer,
          $$QuizAttemptAnswersTableOrderingComposer,
          $$QuizAttemptAnswersTableAnnotationComposer,
          $$QuizAttemptAnswersTableCreateCompanionBuilder,
          $$QuizAttemptAnswersTableUpdateCompanionBuilder,
          (QuizAttemptAnswer, $$QuizAttemptAnswersTableReferences),
          QuizAttemptAnswer,
          PrefetchHooks Function({
            bool attemptId,
            bool idiomId,
            bool selectedIdiomId,
            bool correctIdiomId,
          })
        > {
  $$QuizAttemptAnswersTableTableManager(
    _$AppDatabase db,
    $QuizAttemptAnswersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizAttemptAnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizAttemptAnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizAttemptAnswersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> attemptId = const Value.absent(),
                Value<int> questionOrder = const Value.absent(),
                Value<int> idiomId = const Value.absent(),
                Value<int?> selectedIdiomId = const Value.absent(),
                Value<int> correctIdiomId = const Value.absent(),
                Value<String> optionIdiomIds = const Value.absent(),
              }) => QuizAttemptAnswersCompanion(
                id: id,
                attemptId: attemptId,
                questionOrder: questionOrder,
                idiomId: idiomId,
                selectedIdiomId: selectedIdiomId,
                correctIdiomId: correctIdiomId,
                optionIdiomIds: optionIdiomIds,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int attemptId,
                required int questionOrder,
                required int idiomId,
                Value<int?> selectedIdiomId = const Value.absent(),
                required int correctIdiomId,
                required String optionIdiomIds,
              }) => QuizAttemptAnswersCompanion.insert(
                id: id,
                attemptId: attemptId,
                questionOrder: questionOrder,
                idiomId: idiomId,
                selectedIdiomId: selectedIdiomId,
                correctIdiomId: correctIdiomId,
                optionIdiomIds: optionIdiomIds,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizAttemptAnswersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                attemptId = false,
                idiomId = false,
                selectedIdiomId = false,
                correctIdiomId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (attemptId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.attemptId,
                                    referencedTable:
                                        $$QuizAttemptAnswersTableReferences
                                            ._attemptIdTable(db),
                                    referencedColumn:
                                        $$QuizAttemptAnswersTableReferences
                                            ._attemptIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (idiomId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idiomId,
                                    referencedTable:
                                        $$QuizAttemptAnswersTableReferences
                                            ._idiomIdTable(db),
                                    referencedColumn:
                                        $$QuizAttemptAnswersTableReferences
                                            ._idiomIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (selectedIdiomId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.selectedIdiomId,
                                    referencedTable:
                                        $$QuizAttemptAnswersTableReferences
                                            ._selectedIdiomIdTable(db),
                                    referencedColumn:
                                        $$QuizAttemptAnswersTableReferences
                                            ._selectedIdiomIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (correctIdiomId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.correctIdiomId,
                                    referencedTable:
                                        $$QuizAttemptAnswersTableReferences
                                            ._correctIdiomIdTable(db),
                                    referencedColumn:
                                        $$QuizAttemptAnswersTableReferences
                                            ._correctIdiomIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$QuizAttemptAnswersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizAttemptAnswersTable,
      QuizAttemptAnswer,
      $$QuizAttemptAnswersTableFilterComposer,
      $$QuizAttemptAnswersTableOrderingComposer,
      $$QuizAttemptAnswersTableAnnotationComposer,
      $$QuizAttemptAnswersTableCreateCompanionBuilder,
      $$QuizAttemptAnswersTableUpdateCompanionBuilder,
      (QuizAttemptAnswer, $$QuizAttemptAnswersTableReferences),
      QuizAttemptAnswer,
      PrefetchHooks Function({
        bool attemptId,
        bool idiomId,
        bool selectedIdiomId,
        bool correctIdiomId,
      })
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LanguagesTableTableManager get languages =>
      $$LanguagesTableTableManager(_db, _db.languages);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$CategoryTranslationsTableTableManager get categoryTranslations =>
      $$CategoryTranslationsTableTableManager(_db, _db.categoryTranslations);
  $$IdiomsTableTableManager get idioms =>
      $$IdiomsTableTableManager(_db, _db.idioms);
  $$IdiomTranslationsTableTableManager get idiomTranslations =>
      $$IdiomTranslationsTableTableManager(_db, _db.idiomTranslations);
  $$DefinitionsTableTableManager get definitions =>
      $$DefinitionsTableTableManager(_db, _db.definitions);
  $$DefinitionTranslationsTableTableManager get definitionTranslations =>
      $$DefinitionTranslationsTableTableManager(
        _db,
        _db.definitionTranslations,
      );
  $$ExamplesTableTableManager get examples =>
      $$ExamplesTableTableManager(_db, _db.examples);
  $$ExampleTranslationsTableTableManager get exampleTranslations =>
      $$ExampleTranslationsTableTableManager(_db, _db.exampleTranslations);
  $$IdiomCategoriesTableTableManager get idiomCategories =>
      $$IdiomCategoriesTableTableManager(_db, _db.idiomCategories);
  $$FavoriteIdiomsTableTableManager get favoriteIdioms =>
      $$FavoriteIdiomsTableTableManager(_db, _db.favoriteIdioms);
  $$FlashcardGroupsTableTableManager get flashcardGroups =>
      $$FlashcardGroupsTableTableManager(_db, _db.flashcardGroups);
  $$FlashcardGroupItemsTableTableManager get flashcardGroupItems =>
      $$FlashcardGroupItemsTableTableManager(_db, _db.flashcardGroupItems);
  $$QuizAttemptsTableTableManager get quizAttempts =>
      $$QuizAttemptsTableTableManager(_db, _db.quizAttempts);
  $$QuizAttemptAnswersTableTableManager get quizAttemptAnswers =>
      $$QuizAttemptAnswersTableTableManager(_db, _db.quizAttemptAnswers);
}
