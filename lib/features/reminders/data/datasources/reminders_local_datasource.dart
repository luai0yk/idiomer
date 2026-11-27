import 'package:drift/drift.dart';
import 'package:idiomer/core/database/app_database.dart';
import 'package:idiomer/core/services/cash/cash_keys.dart';
import 'package:idiomer/core/services/cash/cash_service.dart';
import 'package:idiomer/features/reminders/data/models/idiom_reminder_settings_model.dart';
import 'package:idiomer/features/reminders/domain/entities/idiom_reminder_settings.dart';
import 'package:idiomer/features/reminders/domain/entities/reminder_idiom_item.dart';

abstract interface class RemindersLocalDataSource {
  IdiomReminderSettings getReminderSettings();

  Future<void> saveReminderSettings(IdiomReminderSettings settings);

  Future<List<ReminderIdiomItem>> getIdiomsForCategory(String categoryId);
}

class RemindersLocalDataSourceImpl implements RemindersLocalDataSource {
  final CashService _cashService;
  final AppDatabase _db;

  const RemindersLocalDataSourceImpl({
    required CashService cashService,
    required AppDatabase database,
  }) : _cashService = cashService,
       _db = database;

  @override
  IdiomReminderSettings getReminderSettings() {
    final model = _cashService.getModel<IdiomReminderSettingsModel>(
      CashKeys.idiomReminder,
      IdiomReminderSettingsModel.fromJson,
    );
    return model?.toEntity() ?? const IdiomReminderSettings();
  }

  @override
  Future<void> saveReminderSettings(IdiomReminderSettings settings) async {
    final model = IdiomReminderSettingsModel.fromEntity(settings);
    await _cashService.setModel(CashKeys.idiomReminder, model.toJson());
  }

  @override
  Future<List<ReminderIdiomItem>> getIdiomsForCategory(
    String categoryId,
  ) async {
    final itEn = _db.alias(_db.idiomTranslations, 'r_it_en');
    final itAr = _db.alias(_db.idiomTranslations, 'r_it_ar');
    final defFirst = _db.alias(_db.definitions, 'r_def_first');
    final dtEn = _db.alias(_db.definitionTranslations, 'r_dt_en');
    final dtAr = _db.alias(_db.definitionTranslations, 'r_dt_ar');
    final exFirst = _db.alias(_db.examples, 'r_ex_first');
    final etEn = _db.alias(_db.exampleTranslations, 'r_et_en');

    final query =
        _db.select(_db.idioms).join([
            innerJoin(
              _db.idiomCategories,
              _db.idiomCategories.idiomId.equalsExp(_db.idioms.id) &
                  _db.idiomCategories.categoryId.equals(categoryId),
              useColumns: false,
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
              defFirst,
              defFirst.idiomId.equalsExp(_db.idioms.id) &
                  defFirst.displayOrder.equals(1),
            ),
            leftOuterJoin(
              dtEn,
              dtEn.definitionId.equalsExp(defFirst.id) &
                  dtEn.languageCode.equals('en'),
            ),
            leftOuterJoin(
              dtAr,
              dtAr.definitionId.equalsExp(defFirst.id) &
                  dtAr.languageCode.equals('ar'),
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
          ])
          ..orderBy([OrderingTerm.asc(_db.idioms.id)]);

    final rows = await query.get();
    return rows
        .map((row) {
          final idiom = row.readTable(_db.idioms);
          final en = row.readTableOrNull(itEn);
          final ar = row.readTableOrNull(itAr);
          final defEn = row.readTableOrNull(dtEn);
          final defAr = row.readTableOrNull(dtAr);
          final exEn = row.readTableOrNull(etEn);

          return ReminderIdiomItem(
            id: idiom.id,
            englishText: en?.textValue ?? '',
            arabicText: ar?.textValue ?? '',
            englishMeaning: defEn?.meaning ?? '',
            arabicMeaning: defAr?.meaning ?? '',
            englishExample: exEn?.sentence,
          );
        })
        .where((item) => item.englishText.trim().isNotEmpty)
        .toList();
  }
}
