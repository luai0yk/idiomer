import 'package:idiomer/features/reminders/domain/entities/idiom_reminder_settings.dart';
import 'package:idiomer/features/reminders/domain/repositories/reminders_repository.dart';

class SaveAndScheduleReminderUseCase {
  final RemindersRepository _repository;

  const SaveAndScheduleReminderUseCase(this._repository);

  Future<ReminderScheduleOutcome> call(
    IdiomReminderSettings settings, {
    required bool showTranslation,
    required String channelName,
    required String channelDescription,
    DateTime? now,
  }) {
    return _repository.applyReminderSettings(
      settings,
      showTranslation: showTranslation,
      channelName: channelName,
      channelDescription: channelDescription,
      now: now,
    );
  }
}
