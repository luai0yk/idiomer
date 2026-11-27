import 'package:idiomer/features/reminders/domain/entities/idiom_reminder_settings.dart';
import 'package:idiomer/features/reminders/domain/repositories/reminders_repository.dart';

class GetReminderSettingsUseCase {
  final RemindersRepository _repository;

  const GetReminderSettingsUseCase(this._repository);

  IdiomReminderSettings call() => _repository.getReminderSettings();
}
