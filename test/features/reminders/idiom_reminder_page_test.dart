import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/app/di/injection.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/theme/material_theme.dart';
import 'package:idiomer/core/services/cash/cash_service.dart';
import 'package:idiomer/core/utils/helpers/ui/app_navigator.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_entity.dart';
import 'package:idiomer/features/idioms/domain/repositories/idioms_repository.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_categories_usecase.dart';
import 'package:idiomer/features/idioms/presentation/widgets/select_category_sheet.dart';
import 'package:idiomer/features/reminders/domain/entities/idiom_reminder_settings.dart';
import 'package:idiomer/features/reminders/domain/entities/reminder_idiom_item.dart';
import 'package:idiomer/features/reminders/domain/repositories/reminders_repository.dart';
import 'package:idiomer/features/reminders/domain/usecases/get_reminder_settings_usecase.dart';
import 'package:idiomer/features/reminders/domain/usecases/save_and_schedule_reminder_usecase.dart';
import 'package:idiomer/features/reminders/presentation/cubit/idiom_reminder_cubit.dart';
import 'package:idiomer/features/reminders/presentation/cubit/idiom_reminder_state.dart';
import 'package:idiomer/features/reminders/presentation/pages/idiom_reminder_page.dart';
import 'package:idiomer/features/reminders/presentation/widgets/reminder_category_card.dart';
import 'package:idiomer/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeIdiomsRepository implements IdiomsRepository {
  final List<CategoryEntity> categories;

  _FakeIdiomsRepository(this.categories);

  @override
  Stream<List<CategoryEntity>> watchCategories() => Stream.value(categories);

  @override
  Future<void> clearAllFavorites() async {}

  @override
  Future<void> setFavorite(int idiomId, {required bool isFavorite}) async {}

  @override
  Future<void> toggleFavorite(int idiomId) async {}

  @override
  Stream<IdiomDetailEntity?> watchIdiomDetail(int idiomId) =>
      const Stream.empty();

  @override
  Stream<IdiomDetailEntity?> watchIdiomOfTheDay({DateTime? date}) =>
      const Stream.empty();

  @override
  Stream<List<IdiomEntity>> watchIdioms({
    String query = '',
    String? categoryId,
    int limit = 50,
    bool favoritesOnly = false,
  }) => const Stream.empty();
}

class _FakeRemindersRepository implements RemindersRepository {
  IdiomReminderSettings savedSettings = const IdiomReminderSettings();
  int applyCount = 0;

  _FakeRemindersRepository();

  @override
  Future<ReminderScheduleOutcome> applyReminderSettings(
    IdiomReminderSettings settings, {
    required bool showTranslation,
    required String channelName,
    required String channelDescription,
    DateTime? now,
  }) async {
    applyCount++;
    savedSettings = settings;
    return settings.isEnabled
        ? ReminderScheduleOutcome.scheduled
        : ReminderScheduleOutcome.disabled;
  }

  @override
  Future<void> cancelAllReminders() async {}

  @override
  Future<List<ReminderIdiomItem>> getIdiomsForCategory(
    String categoryId,
  ) async => const [];

  @override
  IdiomReminderSettings getReminderSettings() => savedSettings;

  @override
  Future<void> saveReminderSettings(IdiomReminderSettings settings) async {
    savedSettings = settings;
  }

  @override
  Future<void> syncScheduledNotifications({
    required bool showTranslation,
    required String channelName,
    required String channelDescription,
    DateTime? now,
  }) async {}
}

void main() {
  const testCategories = [
    CategoryEntity(
      id: 'business',
      displayOrder: 1,
      englishName: 'Business',
      arabicName: 'الأعمال',
    ),
    CategoryEntity(
      id: 'emotions',
      displayOrder: 2,
      englishName: 'Emotions',
      arabicName: 'المشاعر',
    ),
  ];

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await CashService.instance.init();
  });

  group('IdiomReminderCubit', () {
    late _FakeRemindersRepository remindersRepo;
    late IdiomReminderCubit cubit;

    setUp(() {
      remindersRepo = _FakeRemindersRepository();
      cubit = IdiomReminderCubit(
        getSettings: GetReminderSettingsUseCase(remindersRepo),
        saveAndSchedule: SaveAndScheduleReminderUseCase(remindersRepo),
        watchCategories: WatchCategoriesUseCase(
          _FakeIdiomsRepository(testCategories),
        ),
      )..load();
    });

    tearDown(() => cubit.close());

    test('requires choosing a category before saving enabled reminder', () async {
      cubit.setEnabled(true);
      await cubit.save(
        showTranslation: true,
        channelName: 'Idiom Reminders',
        channelDescription: 'Desc',
      );

      expect(cubit.state.categoryError, isTrue);
      expect(cubit.state.feedback, IdiomReminderFeedback.categoryRequired);
      expect(remindersRepo.applyCount, 0);
    });

    test('supports daily once/twice and weekly once/twice/three times', () async {
      cubit.selectCategory('business');
      cubit.setEnabled(true);

      // Daily twice -> 2 time slots
      cubit.changeTimesPerPeriod(2);
      expect(cubit.state.cadence, ReminderCadence.dailyTwice);
      expect(cubit.state.times.length, 2);

      // Weekly -> weeklyOnce -> weeklyThreeTimes -> 3 weekdays
      cubit.changeFrequency(ReminderFrequency.weekly);
      expect(cubit.state.cadence, ReminderCadence.weeklyOnce);
      expect(cubit.state.weekdays.length, 1);

      cubit.changeTimesPerPeriod(2);
      expect(cubit.state.cadence, ReminderCadence.weeklyTwice);
      expect(cubit.state.weekdays.length, 2);

      cubit.changeTimesPerPeriod(3);
      expect(cubit.state.cadence, ReminderCadence.weeklyThreeTimes);
      expect(cubit.state.weekdays.length, 3);

      await cubit.save(
        showTranslation: true,
        channelName: 'Idiom Reminders',
        channelDescription: 'Desc',
      );

      expect(cubit.state.feedback, IdiomReminderFeedback.saved);
      expect(remindersRepo.applyCount, 1);
      expect(remindersRepo.savedSettings.categoryId, 'business');
      expect(
        remindersRepo.savedSettings.cadence,
        ReminderCadence.weeklyThreeTimes,
      );
    });

    test('rejects identical times when dailyTwice is selected', () async {
      cubit.selectCategory('business');
      cubit.setEnabled(true);
      cubit.changeTimesPerPeriod(2);
      cubit.updateTimeAt(0, const ReminderTime(hour: 9, minute: 0));
      cubit.updateTimeAt(1, const ReminderTime(hour: 9, minute: 0));

      await cubit.save(
        showTranslation: true,
        channelName: 'Idiom Reminders',
        channelDescription: 'Desc',
      );

      expect(cubit.state.feedback, IdiomReminderFeedback.duplicateTimes);
      expect(remindersRepo.applyCount, 0);
    });
  });

  group('IdiomReminderPage widget', () {
    testWidgets(
      'requires category, opens category picker without All, and configures daily/weekly options',
      (tester) async {
        tester.view.physicalSize = const Size(412, 915);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await sl.reset();
        SharedPreferences.setMockInitialValues({});
        await initDependencies();

        final settingsCubit = sl<SettingsCubit>();
        addTearDown(settingsCubit.close);

        final remindersRepo = _FakeRemindersRepository();
        final cubit = IdiomReminderCubit(
          getSettings: GetReminderSettingsUseCase(remindersRepo),
          saveAndSchedule: SaveAndScheduleReminderUseCase(remindersRepo),
          watchCategories: WatchCategoriesUseCase(
            _FakeIdiomsRepository(testCategories),
          ),
        )..load();
        addTearDown(cubit.close);

        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<SettingsCubit>.value(value: settingsCubit),
              BlocProvider<IdiomReminderCubit>.value(value: cubit),
            ],
            child: MaterialApp(
              navigatorKey: AppNavigator.key,
              theme: const MaterialTheme().light(),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const IdiomReminderPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Idiom Reminder'), findsOneWidget);
        expect(find.text('Choose a category (Required)'), findsOneWidget);

        // Enable switch opens category picker automatically when no category is chosen.
        await tester.tap(find.text('Enable Reminder'));
        await tester.pumpAndSettle();

        expect(find.byType(SelectCategorySheet), findsOneWidget);
        // Should NOT include the 'All' option since a specific category is required.
        expect(find.text('All'), findsNothing);
        expect(find.text('Business'), findsOneWidget);
        expect(find.text('Emotions'), findsOneWidget);

        await tester.tap(find.text('Emotions'));
        await tester.pumpAndSettle();

        expect(
          find.descendant(
            of: find.byType(ReminderCategoryCard),
            matching: find.text('Emotions'),
          ),
          findsOneWidget,
        );

        // Switch to Daily Twice -> shows First Reminder & Second Reminder
        await tester.tap(find.text('Twice'));
        await tester.pumpAndSettle();
        expect(find.text('First Reminder'), findsOneWidget);
        expect(find.text('Second Reminder'), findsOneWidget);

        // Switch to Weekly -> shows 3 Times option and weekday selector
        await tester.tap(find.text('Weekly'));
        await tester.pumpAndSettle();
        expect(find.text('3 Times'), findsOneWidget);
        await tester.tap(find.text('3 Times'));
        await tester.pumpAndSettle();
        expect(find.text('Select 3 days (3/3)'), findsOneWidget);

        // Save reminder
        await tester.tap(find.text('Save Reminder'));
        await tester.pumpAndSettle();

        expect(remindersRepo.applyCount, 1);
        expect(remindersRepo.savedSettings.categoryId, 'emotions');
        expect(
          remindersRepo.savedSettings.cadence,
          ReminderCadence.weeklyThreeTimes,
        );
        expect(remindersRepo.savedSettings.isEnabled, isTrue);

        // Advance past ToastHelper auto-dismiss duration so no pending timers remain.
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();
      },
    );
  });
}
