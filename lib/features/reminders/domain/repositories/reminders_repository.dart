import 'package:idiomer/features/reminders/domain/entities/idiom_reminder_settings.dart';
import 'package:idiomer/features/reminders/domain/entities/reminder_idiom_item.dart';

enum ReminderScheduleOutcome {
  scheduled,
  disabled,
  permissionDenied,
  noIdiomsInCategory,
}

abstract interface class RemindersRepository {
  IdiomReminderSettings getReminderSettings();

  Future<void> saveReminderSettings(IdiomReminderSettings settings);

  Future<List<ReminderIdiomItem>> getIdiomsForCategory(String categoryId);

  Future<ReminderScheduleOutcome> applyReminderSettings(
    IdiomReminderSettings settings, {
    required bool showTranslation,
    required String channelName,
    required String channelDescription,
    DateTime? now,
  });

  Future<void> syncScheduledNotifications({
    required bool showTranslation,
    required String channelName,
    required String channelDescription,
    DateTime? now,
  });

  Future<void> cancelAllReminders();
}
