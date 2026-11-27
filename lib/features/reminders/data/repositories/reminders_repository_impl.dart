import 'dart:math';

import 'package:idiomer/core/services/notifications/notification_service.dart';
import 'package:idiomer/features/reminders/data/datasources/reminders_local_datasource.dart';
import 'package:idiomer/features/reminders/domain/entities/idiom_reminder_settings.dart';
import 'package:idiomer/features/reminders/domain/entities/reminder_idiom_item.dart';
import 'package:idiomer/features/reminders/domain/repositories/reminders_repository.dart';
import 'package:idiomer/shared/widgets/texts/highlighted_markup_text.dart';

class RemindersRepositoryImpl implements RemindersRepository {
  static const int reminderBaseNotificationId = 1000;
  static const int maxScheduledNotifications = 28;

  final RemindersLocalDataSource _localDataSource;
  final NotificationService _notificationService;
  final Random _random;

  RemindersRepositoryImpl({
    required RemindersLocalDataSource localDataSource,
    required NotificationService notificationService,
    Random? random,
  }) : _localDataSource = localDataSource,
       _notificationService = notificationService,
       _random = random ?? Random();

  @override
  IdiomReminderSettings getReminderSettings() =>
      _localDataSource.getReminderSettings();

  @override
  Future<void> saveReminderSettings(IdiomReminderSettings settings) =>
      _localDataSource.saveReminderSettings(settings);

  @override
  Future<List<ReminderIdiomItem>> getIdiomsForCategory(String categoryId) =>
      _localDataSource.getIdiomsForCategory(categoryId);

  @override
  Future<ReminderScheduleOutcome> applyReminderSettings(
    IdiomReminderSettings settings, {
    required bool showTranslation,
    required String channelName,
    required String channelDescription,
    DateTime? now,
  }) async {
    if (!settings.isEnabled) {
      await _localDataSource.saveReminderSettings(settings);
      await cancelAllReminders();
      return ReminderScheduleOutcome.disabled;
    }

    final categoryId = settings.categoryId;
    if (categoryId == null || categoryId.trim().isEmpty) {
      throw ArgumentError(
        'A categoryId must be chosen before enabling idiom reminders.',
      );
    }

    final granted = await _notificationService.requestPermissions();
    if (!granted) {
      return ReminderScheduleOutcome.permissionDenied;
    }

    final idioms = await _localDataSource.getIdiomsForCategory(categoryId);
    if (idioms.isEmpty) {
      return ReminderScheduleOutcome.noIdiomsInCategory;
    }

    await _localDataSource.saveReminderSettings(settings);
    await _scheduleForIdioms(
      settings: settings,
      idioms: idioms,
      showTranslation: showTranslation,
      channelName: channelName,
      channelDescription: channelDescription,
      now: now ?? DateTime.now(),
    );

    return ReminderScheduleOutcome.scheduled;
  }

  @override
  Future<void> syncScheduledNotifications({
    required bool showTranslation,
    required String channelName,
    required String channelDescription,
    DateTime? now,
  }) async {
    final settings = _localDataSource.getReminderSettings();
    if (!settings.isEnabled ||
        !settings.hasCategory ||
        !settings.hasValidTimes ||
        !settings.hasValidWeekdays) {
      await cancelAllReminders();
      return;
    }

    final idioms = await _localDataSource.getIdiomsForCategory(
      settings.categoryId!,
    );
    if (idioms.isEmpty) {
      await cancelAllReminders();
      return;
    }

    await _scheduleForIdioms(
      settings: settings,
      idioms: idioms,
      showTranslation: showTranslation,
      channelName: channelName,
      channelDescription: channelDescription,
      now: now ?? DateTime.now(),
    );
  }

  @override
  Future<void> cancelAllReminders() {
    return _notificationService.cancelRange(
      startId: reminderBaseNotificationId,
      count: maxScheduledNotifications,
    );
  }

  Future<void> _scheduleForIdioms({
    required IdiomReminderSettings settings,
    required List<ReminderIdiomItem> idioms,
    required bool showTranslation,
    required String channelName,
    required String channelDescription,
    required DateTime now,
  }) async {
    await cancelAllReminders();

    final occurrences = buildUpcomingOccurrences(
      settings: settings,
      now: now,
      maxCount: maxScheduledNotifications,
    );
    if (occurrences.isEmpty) return;

    final pickedIdioms = _pickIdiomsForOccurrences(
      idioms: idioms,
      count: occurrences.length,
    );

    for (int i = 0; i < occurrences.length; i++) {
      final idiom = pickedIdioms[i];
      final body = formatNotificationBody(
        idiom,
        showTranslation: showTranslation,
      );
      await _notificationService.scheduleNotification(
        id: reminderBaseNotificationId + i,
        title: idiom.englishText.trim(),
        body: body,
        scheduledAt: occurrences[i],
        channelName: channelName,
        channelDescription: channelDescription,
        payload: idiom.id.toString(),
      );
    }
  }

  List<ReminderIdiomItem> _pickIdiomsForOccurrences({
    required List<ReminderIdiomItem> idioms,
    required int count,
  }) {
    final result = <ReminderIdiomItem>[];
    var pool = List<ReminderIdiomItem>.from(idioms)..shuffle(_random);
    var poolIndex = 0;
    int? lastId;

    while (result.length < count) {
      if (poolIndex >= pool.length) {
        pool = List<ReminderIdiomItem>.from(idioms)..shuffle(_random);
        if (pool.length > 1 && pool.first.id == lastId) {
          final swap = pool.removeAt(0);
          pool.add(swap);
        }
        poolIndex = 0;
      }

      final next = pool[poolIndex++];
      result.add(next);
      lastId = next.id;
    }

    return result;
  }

  static String formatNotificationBody(
    ReminderIdiomItem idiom, {
    required bool showTranslation,
  }) {
    final meaning = idiom.englishMeaning.trim();
    final arabic = idiom.arabicText.trim();
    final example = HighlightedMarkupText.stripMarkers(
      idiom.englishExample ?? '',
    ).trim();

    final detailText = meaning.isNotEmpty ? meaning : example;
    if (showTranslation && arabic.isNotEmpty && detailText.isNotEmpty) {
      return '$arabic — $detailText';
    }
    if (showTranslation && arabic.isNotEmpty) {
      return arabic;
    }
    if (detailText.isNotEmpty) {
      return detailText;
    }
    return idiom.englishText.trim();
  }

  /// Generates chronological upcoming notification timestamps strictly after
  /// [now] according to [settings.cadence], [settings.times], and
  /// [settings.weekdays].
  static List<DateTime> buildUpcomingOccurrences({
    required IdiomReminderSettings settings,
    required DateTime now,
    int maxCount = maxScheduledNotifications,
  }) {
    if (maxCount <= 0 || settings.times.isEmpty) return const [];

    final sortedTimes = List<ReminderTime>.from(settings.times)..sort();
    final occurrences = <DateTime>[];

    if (settings.cadence.isDaily) {
      for (int dayOffset = 0; occurrences.length < maxCount; dayOffset++) {
        final date = DateTime(now.year, now.month, now.day + dayOffset);
        for (final time in sortedTimes) {
          final candidate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          if (candidate.isAfter(now)) {
            occurrences.add(candidate);
            if (occurrences.length >= maxCount) break;
          }
        }
      }
      return occurrences;
    }

    final allowedWeekdays = settings.weekdays
        .where((d) => d >= 1 && d <= 7)
        .toSet();
    if (allowedWeekdays.isEmpty) return const [];

    final reminderTime = sortedTimes.first;
    // Cap scan to 365 days to guarantee termination even with sparse schedules.
    for (
      int dayOffset = 0;
      dayOffset < 365 && occurrences.length < maxCount;
      dayOffset++
    ) {
      final date = DateTime(now.year, now.month, now.day + dayOffset);
      if (!allowedWeekdays.contains(date.weekday)) continue;

      final candidate = DateTime(
        date.year,
        date.month,
        date.day,
        reminderTime.hour,
        reminderTime.minute,
      );
      if (candidate.isAfter(now)) {
        occurrences.add(candidate);
      }
    }

    return occurrences;
  }
}
