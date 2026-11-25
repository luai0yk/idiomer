# Verified SQLite Schema Reference

Database: `english_idioms_i18n.db`

## Inspection snapshot

| Property | Verified value |
|---|---:|
| File size | 10,887,168 bytes |
| Encoding | UTF-8 |
| Page size | 4096 bytes |
| Journal mode | `delete` |
| Auto-vacuum | `0` |
| `user_version` | `0` |
| `schema_version` | `65` |
| `application_id` | `0` |
| Views | 0 |
| `PRAGMA integrity_check` | `ok` |
| `PRAGMA foreign_key_check` | no violations |

Foreign-key declarations exist, but enforcement must be enabled on each connection with `PRAGMA foreign_keys = ON;`.

## Table row counts

| Table | Rows |
|---|---:|
| `android_metadata` | 1 |
| `categories` | 20 |
| `category_translations` | 40 |
| `definition_translations` | 8,542 |
| `definitions` | 4,271 |
| `example_translations` | 16,804 |
| `examples` | 8,402 |
| `idiom_categories` | 9,537 |
| `idiom_translations` | 8,074 |
| `idioms` | 4,037 |
| `languages` | 2 |

## Relational model

`idioms` is the root entity. Localized idiom text is stored in `idiom_translations`. Each idiom may have multiple `definitions` and `examples`; each definition and example has its own translation table. Idioms and categories form a many-to-many relationship through `idiom_categories`. `languages` is referenced by all translation tables.

```text
languages (code PK)
  ├── idiom_translations.language_code
  ├── category_translations.language_code
  ├── definition_translations.language_code
  └── example_translations.language_code

idioms (id PK)
  ├── idiom_translations (idiom_id FK)
  ├── definitions (idiom_id FK)
  │     └── definition_translations (definition_id FK)
  ├── examples (idiom_id FK, definition_id nullable FK)
  │     └── example_translations (example_id FK)
  └── idiom_categories (idiom_id FK, category_id FK)

categories (id PK)
  ├── category_translations (category_id FK)
  └── idiom_categories (category_id FK)
```

## Exact table DDL

### `android_metadata`

```sql
CREATE TABLE android_metadata (locale TEXT)
```

### `categories`

```sql
CREATE TABLE categories (
    id            TEXT    PRIMARY KEY CHECK (
                              length(trim(id)) > 0
                              AND id = lower(id)
                              AND id NOT GLOB '*[^a-z0-9_]*'
                              AND id NOT GLOB '[0-9]*'
                          ),
    display_order INTEGER NOT NULL UNIQUE CHECK (display_order >= 1)
)
```

### `category_translations`

```sql
CREATE TABLE category_translations (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    category_id   TEXT    NOT NULL,
    language_code TEXT    NOT NULL,
    name          TEXT    NOT NULL CHECK (length(trim(name)) > 0),
    description   TEXT,
    CONSTRAINT fk_category_translations_category
        FOREIGN KEY (category_id) REFERENCES categories (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_category_translations_language
        FOREIGN KEY (language_code) REFERENCES languages (code)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_category_translations_cat_lang
        UNIQUE (category_id, language_code),
    CONSTRAINT uq_category_translations_lang_name
        UNIQUE (language_code, name)
)
```

### `definition_translations`

```sql
CREATE TABLE "definition_translations" (
    id                 INTEGER PRIMARY KEY AUTOINCREMENT,
    definition_id      INTEGER NOT NULL,
    language_code      TEXT    NOT NULL,
    meaning            TEXT    NOT NULL CHECK (length(trim(meaning)) > 0),
    CONSTRAINT fk_definition_translations_definition
        FOREIGN KEY (definition_id) REFERENCES definitions (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_definition_translations_language
        FOREIGN KEY (language_code) REFERENCES languages (code)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_definition_translations_def_lang
        UNIQUE (definition_id, language_code)
)
```

### `definitions`

```sql
CREATE TABLE "definitions" (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    idiom_id      INTEGER NOT NULL,
    display_order INTEGER NOT NULL DEFAULT 1 CHECK (display_order >= 1),
    CONSTRAINT fk_definitions_idiom
        FOREIGN KEY (idiom_id) REFERENCES idioms (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_definitions_idiom_order
        UNIQUE (idiom_id, display_order)
)
```

### `example_translations`

```sql
CREATE TABLE "example_translations" (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    example_id          INTEGER NOT NULL,
    language_code       TEXT    NOT NULL,
    sentence            TEXT    NOT NULL CHECK (length(trim(sentence)) > 0),
    CONSTRAINT fk_example_translations_example
        FOREIGN KEY (example_id) REFERENCES examples (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_example_translations_language
        FOREIGN KEY (language_code) REFERENCES languages (code)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_example_translations_example_lang
        UNIQUE (example_id, language_code)
)
```

### `examples`

```sql
CREATE TABLE "examples" (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    idiom_id      INTEGER NOT NULL,
    definition_id INTEGER,
    display_order INTEGER NOT NULL DEFAULT 1 CHECK (display_order >= 1),
    CONSTRAINT fk_examples_idiom
        FOREIGN KEY (idiom_id) REFERENCES idioms (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_examples_definition
        FOREIGN KEY (definition_id) REFERENCES definitions (id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT uq_examples_idiom_order
        UNIQUE (idiom_id, display_order)
)
```

### `idiom_categories`

```sql
CREATE TABLE idiom_categories (
    idiom_id    INTEGER NOT NULL,
    category_id TEXT    NOT NULL,
    PRIMARY KEY (idiom_id, category_id),
    CONSTRAINT fk_idiom_categories_idiom
        FOREIGN KEY (idiom_id) REFERENCES idioms (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_idiom_categories_category
        FOREIGN KEY (category_id) REFERENCES categories (id)
        ON DELETE CASCADE ON UPDATE CASCADE
)
```

### `idiom_translations`

```sql
CREATE TABLE "idiom_translations" (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    idiom_id        INTEGER NOT NULL,
    language_code   TEXT    NOT NULL,
    text            TEXT    NOT NULL CHECK (length(trim(text)) > 0),
    notes           TEXT,
    CONSTRAINT fk_idiom_translations_idiom
        FOREIGN KEY (idiom_id) REFERENCES idioms (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_idiom_translations_language
        FOREIGN KEY (language_code) REFERENCES languages (code)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_idiom_translations_idiom_lang
        UNIQUE (idiom_id, language_code)
)
```

### `idioms`

```sql
CREATE TABLE idioms (
    id   INTEGER PRIMARY KEY,
    slug TEXT UNIQUE CHECK (slug IS NULL OR (length(trim(slug)) > 0 AND slug = lower(slug)))
)
```

### `languages`

```sql
CREATE TABLE languages (
    code      TEXT PRIMARY KEY CHECK (length(trim(code)) >= 2 AND code = lower(code)),
    name      TEXT NOT NULL UNIQUE CHECK (length(trim(name)) > 0),
    direction TEXT NOT NULL CHECK (direction IN ('ltr', 'rtl'))
)
```

## Explicit indexes

The database also contains SQLite autoindexes created by primary-key and unique constraints. The following are the eight explicitly declared indexes:

```sql
CREATE INDEX idx_category_translations_lang
    ON category_translations (language_code, category_id);
CREATE INDEX idx_definition_translations_lang_def
    ON definition_translations (language_code, definition_id);
CREATE INDEX idx_example_translations_lang_ex
    ON example_translations (language_code, example_id);
CREATE INDEX idx_examples_definition_id
    ON examples (definition_id)
    WHERE definition_id IS NOT NULL;
CREATE INDEX idx_idiom_categories_category_idiom
    ON idiom_categories (category_id, idiom_id);
CREATE UNIQUE INDEX uq_definition_translations_lang_meaning
    ON definition_translations (language_code, meaning);
CREATE UNIQUE INDEX uq_example_translations_lang_sentence
    ON example_translations (language_code, sentence);
CREATE UNIQUE INDEX uq_idiom_translations_lang_text
    ON idiom_translations (language_code, text);
```

## Triggers

Both triggers reject an example whose non-null `definition_id` does not exist or belongs to a different idiom. One runs before insert; the other runs before updates to `idiom_id` or `definition_id`.

```sql
CREATE TRIGGER trg_examples_validate_definition_insert
BEFORE INSERT ON examples
WHEN NEW.definition_id IS NOT NULL
BEGIN
    SELECT CASE
        WHEN (SELECT idiom_id FROM definitions WHERE id = NEW.definition_id) IS NULL
            THEN RAISE(ABORT, 'Invalid definition_id: definition does not exist')
        WHEN (SELECT idiom_id FROM definitions WHERE id = NEW.definition_id) != NEW.idiom_id
            THEN RAISE(ABORT, 'Cross-idiom reference violation: definition_id belongs to a different idiom')
    END;
END
CREATE TRIGGER trg_examples_validate_definition_update
BEFORE UPDATE OF idiom_id, definition_id ON examples
WHEN NEW.definition_id IS NOT NULL
BEGIN
    SELECT CASE
        WHEN (SELECT idiom_id FROM definitions WHERE id = NEW.definition_id) IS NULL
            THEN RAISE(ABORT, 'Invalid definition_id: definition does not exist')
        WHEN (SELECT idiom_id FROM definitions WHERE id = NEW.definition_id) != NEW.idiom_id
            THEN RAISE(ABORT, 'Cross-idiom reference violation: definition_id belongs to a different idiom')
    END;
END
```

## Supported languages

| Code | Name | Direction |
|---|---|---|
| `ar` | Arabic | `rtl` |
| `en` | English | `ltr` |

## Category lookup data

Category IDs are lowercase `snake_case` identifiers. `display_order` is unique and determines presentation order. Names and descriptions are localized in `category_translations`.

| Order | ID | English name | Arabic name |
|---:|---|---|---|
| 1 | `daily_life` | Daily Life | الحياة اليومية |
| 2 | `business` | Business | الأعمال والتجارة |
| 3 | `education` | Education | التعليم والتعلّم |
| 4 | `relationships` | Relationships | العلاقات الاجتماعية |
| 5 | `emotions` | Emotions | المشاعر والانفعالات |
| 6 | `communication` | Communication | التواصل والحوار |
| 7 | `success` | Success | النجاح والإنجاز |
| 8 | `failure` | Failure | الإخفاق والتعثر |
| 9 | `money` | Money | المال والاقتصاد |
| 10 | `work` | Work | العمل والمهنة |
| 11 | `health` | Health | الصحة والعافية |
| 12 | `food` | Food | الطعام والمائدة |
| 13 | `travel` | Travel | السفر والتنقل |
| 14 | `time` | Time | الوقت والزمن |
| 15 | `weather` | Weather | الطقس والمناخ |
| 16 | `animals` | Animals | الحيوانات والطيور |
| 17 | `nature` | Nature | الطبيعة والبيئة |
| 18 | `technology` | Technology | التقنية والآلات |
| 19 | `decision_making` | Decision Making | اتخاذ القرار |
| 20 | `personality` | Personality | الشخصية والطباع |

## Verified structural notes

- `idioms`: 4,037 rows; IDs range from 1 to 4,178 and are not contiguous. No current row has a null slug.
- `idiom_translations`: 8,074 rows, currently 4,037 English and 4,037 Arabic; `notes` is nullable.
- `definitions`: 4,271 rows; `display_order` ranges from 1 to 2.
- `definition_translations`: 8,542 rows, currently 4,271 per language.
- `examples`: 8,402 rows; `definition_id` is nullable; `display_order` ranges from 1 to 4.
- `example_translations`: 16,804 rows, currently 8,402 per language.
- `idiom_categories`: 9,537 links.
- `categories`: 20 rows; `category_translations`: 40 rows.
- Translation tables enforce one row per parent entity and language.
- Unique indexes also prevent duplicate idiom text, definition meaning, and example sentence within the same language.
- No FTS virtual table, views, normalized text columns, or normalized indexes exist.

## SQLite system tables

- `sqlite_sequence` tracks AUTOINCREMENT sequences for `category_translations`, `definition_translations`, `definitions`, `example_translations`, `examples`, and `idiom_translations`.
- `sqlite_stat1` is populated by `ANALYZE`.

## Important constraints and delete behavior

- Deleting an idiom cascades to its translations, definitions, examples, and category links.
- Deleting a definition sets a referencing example's `definition_id` to `NULL`.
- Deleting a category cascades to category translations and idiom-category links.
- Deleting a referenced language is restricted.
- Foreign keys use `ON UPDATE CASCADE`.
- The example triggers enforce that `examples.definition_id`, when present, belongs to the same `idiom_id` as the example.

Snapshot values above describe the supplied database at inspection time. Re-check the live file before relying on them after migrations or data updates.
