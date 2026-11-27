import 'package:idiomer/features/reminders/domain/repositories/reminders_repository.dart';

class SyncReminderNotificationsUseCase {
  final RemindersRepository _repository;

  const SyncReminderNotificationsUseCase(this._repository);

  Future<void> call({
    required bool showTranslation,
    required String channelName,
    required String channelDescription,
    DateTime? now,
  }) {
    return _repository.syncScheduledNotifications(
      showTranslation: showTranslation,
      channelName: channelName,
      channelDescription: channelDescription,
      now: now,
    );
  }
}
