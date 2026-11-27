import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/core/database/app_database.dart';
import 'package:idiomer/core/services/cash/cash_service.dart';
import 'package:idiomer/core/services/notifications/notification_service.dart';
import 'package:idiomer/features/reminders/data/datasources/reminders_local_datasource.dart';
import 'package:idiomer/features/reminders/data/models/idiom_reminder_settings_model.dart';
import 'package:idiomer/features/reminders/data/repositories/reminders_repository_impl.dart';
import 'package:idiomer/features/reminders/domain/entities/idiom_reminder_settings.dart';
import 'package:idiomer/features/reminders/domain/repositories/reminders_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../idioms/idioms_local_datasource_test.dart';

class _MockNotificationService extends Mock implements NotificationService {}

void main() {
  group('IdiomReminderSettingsModel', () {
    test('serializes and deserializes all cadence variants', () {
      const settings = IdiomReminderSettings(
        isEnabled: true,
        categoryId: 'business',
        cadence: ReminderCadence.weeklyThreeTimes,
        times: [ReminderTime(hour: 18, minute: 30)],
        weekdays: [DateTime.monday, DateTime.wednesday, DateTime.friday],
      );

      final json = IdiomReminderSettingsModel.fromEntity(settings).toJson();
      final decoded = IdiomReminderSettingsModel.fromJson(json).toEntity();

      expect(decoded, settings);
    });

    test('falls back safely when stored JSON has invalid times or counts', () {
      final decoded = IdiomReminderSettingsModel.fromJson({
        'isEnabled': true,
        'categoryId': '  ',
        'cadence': 'dailyTwice',
        'times': [
          {'hour': 99, 'minute': 0},
        ],
        'weekdays': [1],
      }).toEntity();

      expect(decoded.categoryId, isNull);
      expect(decoded.cadence, ReminderCadence.dailyTwice);
      expect(decoded.times, ReminderCadence.dailyTwice.defaultTimes);
      expect(decoded.weekdays, isEmpty);
    });
  });

  group('RemindersRepositoryImpl.buildUpcomingOccurrences', () {
    test('dailyOnce skips today when time has already passed', () {
      final now = DateTime(2026, 3, 2, 10, 0);
      const settings = IdiomReminderSettings(
        isEnabled: true,
        categoryId: 'business',
        cadence: ReminderCadence.dailyOnce,
        times: [ReminderTime(hour: 9, minute: 0)],
      );

      final result = RemindersRepositoryImpl.buildUpcomingOccurrences(
        settings: settings,
        now: now,
        maxCount: 3,
      );

      expect(result, [
        DateTime(2026, 3, 3, 9, 0),
        DateTime(2026, 3, 4, 9, 0),
        DateTime(2026, 3, 5, 9, 0),
      ]);
    });

    test('dailyTwice emits both times chronologically each day', () {
      final now = DateTime(2026, 3, 2, 10, 0);
      const settings = IdiomReminderSettings(
        isEnabled: true,
        categoryId: 'business',
        cadence: ReminderCadence.dailyTwice,
        times: [
          ReminderTime(hour: 20, minute: 30),
          ReminderTime(hour: 8, minute: 15),
        ],
      );

      final result = RemindersRepositoryImpl.buildUpcomingOccurrences(
        settings: settings,
        now: now,
        maxCount: 4,
      );

      expect(result, [
        DateTime(2026, 3, 2, 20, 30),
        DateTime(2026, 3, 3, 8, 15),
        DateTime(2026, 3, 3, 20, 30),
        DateTime(2026, 3, 4, 8, 15),
      ]);
    });

    test('weeklyThreeTimes schedules only on selected weekdays', () {
      // 2026-03-02 is Monday.
      final now = DateTime(2026, 3, 2, 8, 0);
      const settings = IdiomReminderSettings(
        isEnabled: true,
        categoryId: 'business',
        cadence: ReminderCadence.weeklyThreeTimes,
        times: [ReminderTime(hour: 9, minute: 0)],
        weekdays: [DateTime.monday, DateTime.wednesday, DateTime.friday],
      );

      final result = RemindersRepositoryImpl.buildUpcomingOccurrences(
        settings: settings,
        now: now,
        maxCount: 4,
      );

      expect(result, [
        DateTime(2026, 3, 2, 9, 0), // Mon
        DateTime(2026, 3, 4, 9, 0), // Wed
        DateTime(2026, 3, 6, 9, 0), // Fri
        DateTime(2026, 3, 9, 9, 0), // Next Mon
      ]);
    });
  });

  group('RemindersLocalDataSourceImpl & RemindersRepositoryImpl', () {
    late AppDatabase db;
    late RemindersLocalDataSourceImpl localDataSource;
    late _MockNotificationService notificationService;
    late RemindersRepositoryImpl repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await CashService.instance.init();
      db = AppDatabase(NativeDatabase.memory());
      await seedTestDatabase(db);

      localDataSource = RemindersLocalDataSourceImpl(
        cashService: CashService.instance,
        database: db,
      );
      notificationService = _MockNotificationService();
      when(() => notificationService.requestPermissions()).thenAnswer(
        (_) async => true,
      );
      when(
        () => notificationService.cancelRange(
          startId: any(named: 'startId'),
          count: any(named: 'count'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => notificationService.scheduleNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledAt: any(named: 'scheduledAt'),
          channelName: any(named: 'channelName'),
          channelDescription: any(named: 'channelDescription'),
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) async {});

      repository = RemindersRepositoryImpl(
        localDataSource: localDataSource,
        notificationService: notificationService,
        random: Random(42),
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('filters idioms strictly by chosen category', () async {
      final businessIdioms = await localDataSource.getIdiomsForCategory(
        'business',
      );
      final dailyIdioms = await localDataSource.getIdiomsForCategory(
        'daily_life',
      );

      expect(businessIdioms.map((e) => e.englishText), ['Call it a day']);
      expect(dailyIdioms.map((e) => e.englishText), ['Break the ice']);
      expect(
        dailyIdioms.first.englishMeaning,
        'To start a friendly conversation and relieve tension.',
      );
    });

    test('schedules notifications only for chosen category and persists config', () async {
      const settings = IdiomReminderSettings(
        isEnabled: true,
        categoryId: 'daily_life',
        cadence: ReminderCadence.dailyOnce,
        times: [ReminderTime(hour: 9, minute: 0)],
      );

      final outcome = await repository.applyReminderSettings(
        settings,
        showTranslation: true,
        channelName: 'Idiom Reminders',
        channelDescription: 'Scheduled reminders',
        now: DateTime(2026, 3, 2, 8, 0),
      );

      expect(outcome, ReminderScheduleOutcome.scheduled);
      expect(repository.getReminderSettings(), settings);

      verify(
        () => notificationService.cancelRange(
          startId: RemindersRepositoryImpl.reminderBaseNotificationId,
          count: RemindersRepositoryImpl.maxScheduledNotifications,
        ),
      ).called(1);

      verify(
        () => notificationService.scheduleNotification(
          id: any(named: 'id'),
          title: 'Break the ice',
          body:
              'يكسر الجليد — To start a friendly conversation and relieve tension.',
          scheduledAt: any(named: 'scheduledAt'),
          channelName: 'Idiom Reminders',
          channelDescription: 'Scheduled reminders',
          payload: '1',
        ),
      ).called(RemindersRepositoryImpl.maxScheduledNotifications);
    });

    test('returns permissionDenied and does not persist when permission is denied', () async {
      when(() => notificationService.requestPermissions()).thenAnswer(
        (_) async => false,
      );

      const settings = IdiomReminderSettings(
        isEnabled: true,
        categoryId: 'daily_life',
        cadence: ReminderCadence.dailyOnce,
        times: [ReminderTime(hour: 9, minute: 0)],
      );

      final outcome = await repository.applyReminderSettings(
        settings,
        showTranslation: true,
        channelName: 'Idiom Reminders',
        channelDescription: 'Scheduled reminders',
      );

      expect(outcome, ReminderScheduleOutcome.permissionDenied);
      expect(repository.getReminderSettings().isEnabled, isFalse);
      verifyNever(
        () => notificationService.scheduleNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledAt: any(named: 'scheduledAt'),
          channelName: any(named: 'channelName'),
          channelDescription: any(named: 'channelDescription'),
          payload: any(named: 'payload'),
        ),
      );
    });

    test('disabling reminder saves disabled state and cancels pending range', () async {
      const disabled = IdiomReminderSettings(
        isEnabled: false,
        categoryId: 'business',
      );

      final outcome = await repository.applyReminderSettings(
        disabled,
        showTranslation: true,
        channelName: 'Idiom Reminders',
        channelDescription: 'Scheduled reminders',
      );

      expect(outcome, ReminderScheduleOutcome.disabled);
      expect(repository.getReminderSettings().isEnabled, isFalse);
      verify(
        () => notificationService.cancelRange(
          startId: RemindersRepositoryImpl.reminderBaseNotificationId,
          count: RemindersRepositoryImpl.maxScheduledNotifications,
        ),
      ).called(1);
    });
  });
}
