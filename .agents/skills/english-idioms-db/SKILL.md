---
name: english-idioms-db
description: Use when an agent needs to inspect, query, extend, validate, or maintain the `english_idioms_i18n.db` SQLite database used by the English–Arabic idioms application. Recommended for coding agents working on database access, repository queries, localization, migrations, imports, exports, or data-integrity tasks involving this database.
---

# English Idioms Database

Use this skill whenever a task depends on the structure or contents of `english_idioms_i18n.db`. Treat the database itself and the bundled schema reference as the source of truth; do not infer schema details from application models or older documentation.

## Workflow

1. **Locate the database.** Find the actual `english_idioms_i18n.db` file in the project or supplied files. Do not create a replacement database if the file is missing; report that it could not be found.
2. **Inspect before acting.** For an unfamiliar task, inspect `sqlite_master`, relevant table definitions, indexes, triggers, and `PRAGMA` metadata. Consult [the verified schema reference](references/schema.md).
3. **Use a safe connection.** Enable foreign-key enforcement on every connection:
   ```sql
   PRAGMA foreign_keys = ON;
   ```
   Verify it with `PRAGMA foreign_keys;`. SQLite does not enable foreign-key enforcement by default on every connection.
4. **Query relationally.** Join translation tables through their parent IDs and `language_code`. Do not assume record IDs match across tables, even if some sample IDs happen to match.
5. **Preserve invariants.** Follow the constraints, uniqueness rules, cascading behavior, and example-definition trigger rules documented in the schema reference. Do not bypass them.
6. **Validate writes.** Use a transaction for related changes. After a write, run:
   ```sql
   PRAGMA integrity_check;
   PRAGMA foreign_key_check;
   ```
   Confirm expected row counts and translation coverage before reporting success.
7. **Report precisely.** Distinguish verified database facts from assumptions. Include the relevant table/column names and explain any missing or ambiguous data.

## Data model

The database stores idioms independently from their localized text. Idioms can have multiple definitions and examples, and can be assigned to multiple categories.

- `idioms` → `idiom_translations`
- `idioms` → `definitions` → `definition_translations`
- `idioms` → `examples` → `example_translations`
- `idioms` ↔ `categories` through `idiom_categories`
- `categories` → `category_translations`
- `languages` is referenced by every translation table.

Supported language rows currently are Arabic (`ar`, RTL) and English (`en`, LTR`). Retrieve language-specific content by filtering on `language_code`; never infer a translation by changing or translating another row at query time unless the task explicitly asks for generated translations.

## Query patterns

### Fetch an idiom in one language

```sql
SELECT i.id, i.slug, t.text, t.notes
FROM idioms AS i
JOIN idiom_translations AS t ON t.idiom_id = i.id
WHERE t.language_code = :language_code
  AND (i.id = :idiom_id OR i.slug = :slug);
```

Use either `:idiom_id` or `:slug` as the lookup criterion. Avoid an `OR` if you already know which identifier is available.

### Fetch idioms with localized definitions and examples

```sql
SELECT
    i.id AS idiom_id,
    i.slug,
    it.text AS idiom_text,
    d.id AS definition_id,
    d.display_order AS definition_order,
    dt.meaning,
    e.id AS example_id,
    e.display_order AS example_order,
    et.sentence
FROM idioms AS i
JOIN idiom_translations AS it
  ON it.idiom_id = i.id
 AND it.language_code = :language_code
LEFT JOIN definitions AS d
  ON d.idiom_id = i.id
LEFT JOIN definition_translations AS dt
  ON dt.definition_id = d.id
 AND dt.language_code = :language_code
LEFT JOIN examples AS e
  ON e.idiom_id = i.id
 AND (e.definition_id = d.id OR e.definition_id IS NULL)
LEFT JOIN example_translations AS et
  ON et.example_id = e.id
 AND et.language_code = :language_code
WHERE i.id = :idiom_id
ORDER BY d.display_order, e.display_order;
```

This joins can produce repeated definition data when a definition has multiple examples. For APIs or object mapping, consider separate queries for idioms, definitions, and examples to avoid accidental duplicate objects.

### List categories in a language

```sql
SELECT c.id, c.display_order, ct.name, ct.description
FROM categories AS c
JOIN category_translations AS ct
  ON ct.category_id = c.id
WHERE ct.language_code = :language_code
ORDER BY c.display_order;
```

### Find idioms assigned to a category

```sql
SELECT i.id, i.slug, it.text
FROM idiom_categories AS ic
JOIN idioms AS i ON i.id = ic.idiom_id
JOIN idiom_translations AS it ON it.idiom_id = i.id
WHERE ic.category_id = :category_id
  AND it.language_code = :language_code
ORDER BY it.text COLLATE NOCASE;
```

### Check translation coverage

```sql
SELECT
    'idioms' AS entity,
    language_code,
    COUNT(*) AS translated_rows
FROM idiom_translations
GROUP BY language_code
UNION ALL
SELECT 'definitions', language_code, COUNT(*)
FROM definition_translations
GROUP BY language_code
UNION ALL
SELECT 'examples', language_code, COUNT(*)
FROM example_translations
GROUP BY language_code
UNION ALL
SELECT 'categories', language_code, COUNT(*)
FROM category_translations
GROUP BY language_code;
```

## Write and migration rules

- Do not change primary keys, foreign keys, unique constraints, checks, indexes, or triggers unless the task explicitly requests a schema change.
- Insert the parent record before its dependent translations and relations.
- Keep one translation per `(entity_id, language_code)`; the database enforces this with unique constraints.
- Translation text is unique per language for idioms, definitions, and examples. A duplicate can fail even when it belongs to a different parent record.
- `examples.definition_id` is nullable. When non-null, it must reference a definition belonging to the same idiom; both insert and update triggers enforce this.
- Deleting an idiom cascades to its translations, definitions, examples, and category links. Deleting a definition sets linked examples' `definition_id` to `NULL`. Deleting a category cascades to its translations and idiom links. Language deletion is restricted while translations reference it.
- Do not use `INSERT OR REPLACE` for relational records: SQLite `REPLACE` may delete the conflicting row before inserting, activating foreign-key cascades. Prefer a deliberate `UPDATE` or `INSERT ... ON CONFLICT DO UPDATE` where appropriate.
- Do not assume that `id` values are contiguous or that `MAX(id)` equals the row count.
- Preserve Arabic text exactly, including diacritics and punctuation, unless editing it is part of the task.
- Definition meanings (`definition_translations.meaning`) and example sentences (`example_translations.sentence`) use inline `**...**` markdown-style markers around the target idiom or highlighted phrase (for example: `We had to **bite the bullet** and cut our marketing budget this quarter.`). Preserve or apply `**...**` markup consistently when inserting or updating definitions/examples, strip markers (`HighlightedMarkupText.stripMarkers`) for plain-text copy/share, and account for `**` markers when running substring matching or length checks.
- Use parameterized SQL for all user-provided values. Never build SQL by interpolating untrusted text.

## Important limitations

- The database has no views and no full-text-search (FTS) virtual table.
- There are no normalized-text/meaning/sentence columns or normalized indexes.
- Do not query nonexistent objects such as `idioms_fts`, `normalized_text`, `normalized_meaning`, or `normalized_sentence`.
- Use ordinary indexed SQL search unless the project explicitly adds a search implementation. For substring matching, `LIKE '%term%'` may require a scan; do not claim it uses a normal B-tree index.
- The schema reference records the inspected database state. If the live database differs, trust the live schema for current operations, identify the difference, and update the reference only when asked.
