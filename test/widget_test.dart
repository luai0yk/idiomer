import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/app/di/injection.dart';
import 'package:idiomer/app/routes/app_router.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/database/app_database.dart';
import 'package:idiomer/features/db_setup/domain/entities/db_setup_progress.dart';
import 'package:idiomer/features/db_setup/domain/repositories/db_setup_repository.dart';
import 'package:idiomer/features/db_setup/presentation/pages/db_setup_page.dart';
import 'package:idiomer/features/favorites/presentation/pages/favorites_page.dart';
import 'package:idiomer/features/flashcards/presentation/pages/flashcard_study_page.dart';
import 'package:idiomer/features/flashcards/presentation/pages/flashcards_page.dart';
import 'package:idiomer/features/flashcards/presentation/widgets/flashcard_back_card.dart';
import 'package:idiomer/features/flashcards/presentation/widgets/flashcard_front_card.dart';
import 'package:idiomer/features/home/presentation/pages/home_page.dart';
import 'package:idiomer/features/idioms/presentation/pages/idiom_detail_page.dart';
import 'package:idiomer/features/idioms/presentation/pages/idioms_page.dart';
import 'package:idiomer/features/idioms/presentation/widgets/idiom_share_card.dart';
import 'package:idiomer/features/idioms/presentation/widgets/idiom_share_sheet.dart';
import 'package:idiomer/features/idioms/presentation/widgets/select_category_sheet.dart';
import 'package:idiomer/features/quiz/presentation/pages/quiz_overview_page.dart';
import 'package:idiomer/features/quiz/presentation/pages/quiz_review_page.dart';
import 'package:idiomer/features/quiz/presentation/pages/quiz_session_page.dart';
import 'package:idiomer/features/quiz/presentation/widgets/quiz_option_card.dart';
import 'package:idiomer/features/settings/presentation/pages/settings_page.dart';
import 'package:idiomer/main.dart';
import 'package:idiomer/shared/widgets/buttons/my_floating_button.dart';
import 'package:idiomer/shared/widgets/input/my_text_field.dart';
import 'package:idiomer/shared/widgets/misc/my_bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/quiz/quiz_test.dart';

class _FakeDbSetupRepository implements DbSetupRepository {
  final Stream<DbSetupProgress> Function() onInitialize;

  _FakeDbSetupRepository(this.onInitialize);

  @override
  Stream<DbSetupProgress> initializeDatabase() => onInitialize();
}

void main() {
  late AppDatabase testDb;

  setUp(() async {
    await sl.reset();
    SharedPreferences.setMockInitialValues({});
    testDb = AppDatabase(NativeDatabase.memory());
    await seedQuizIdioms(testDb, total: 10);
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets(
    'DbSetupPage shows error retry and navigates to Home tab when ready',
    (WidgetTester tester) async {
      var attempt = 0;
      final fakeRepo = _FakeDbSetupRepository(() async* {
        attempt++;
        yield const DbSetupProgress.checking();
        if (attempt == 1) {
          yield const DbSetupProgress.error(
            errorType: DbSetupErrorType.noInternet,
          );
        } else {
          yield const DbSetupProgress.ready();
        }
      });

      await initDependencies(database: testDb, dbSetupRepository: fakeRepo);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(DbSetupPage), findsOneWidget);
      expect(find.text('No Internet Connection'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.ensureVisible(find.text('Retry'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text('Idiom of the Day'), findsOneWidget);
      expect(find.text('Idiom Quiz'), findsOneWidget);
      // Daily card now shows idiom, translation, and example (no Meaning label).
      expect(find.text('Meaning'), findsNothing);
      expect(find.text('Example'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      final resetFuture = sl.reset();
      await tester.pump(const Duration(milliseconds: 50));
      await resetFuture;
    },
  );

  testWidgets(
    '4-tab bottom nav, Home quiz first-time flow -> overview, Settings from Home, Explore bottom sheet filter, and Flashcards flow',
    (WidgetTester tester) async {
      await initDependencies(database: testDb);

      final router = AppRouter.createRouter(initialLocation: AppRoutes.home);
      addTearDown(router.dispose);

      await tester.pumpWidget(MyApp(router: router));
      await tester.pumpAndSettle();

      // Verify exactly 4 bottom navigation destinations: Home, Explore, Favorites, Flashcards.
      final navBar = tester.widget<MyBottomNavigationBar>(
        find.byType(MyBottomNavigationBar),
      );
      expect(navBar.items.map((i) => i.title).toList(), [
        'Home',
        'Explore',
        'Favorites',
        'Flashcards',
      ]);

      // Settings is accessible from the Home header.
      await tester.tap(find.byIcon(AppIcons.settings));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsPage), findsOneWidget);

      await tester.tap(find.text('Theme'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();
      expect(find.text('Dark'), findsOneWidget);

      await tester.tap(
        find.byIcon(
          AppIcons.arrowBack(tester.element(find.byType(SettingsPage))),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);

      // First-time quiz tap starts QuizSessionPage directly instead of QuizOverviewPage.
      await tester.tap(find.text('Idiom Quiz'));
      await tester.pumpAndSettle();
      expect(find.byType(QuizSessionPage), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.text('Question 1 of 8'), findsNothing);
      expect(find.text('Which idiom matches this definition?'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);

      // Answer all 8 questions; Next stays disabled on Q8 until answered, then submits.
      expect(find.text('Submit Quiz'), findsNothing);
      for (int i = 0; i < 8; i++) {
        if (i == 7) {
          final nextButton = tester.widget<TextButton>(
            find.widgetWithText(TextButton, 'Next'),
          );
          expect(nextButton.onPressed, isNull);
        }

        // Pick the first QuizOptionCard.
        final firstOption = find.byType(QuizOptionCard).first;
        await tester.ensureVisible(firstOption);
        await tester.tap(firstOption);
        await tester.pumpAndSettle();

        if (i < 7) {
          await tester.tap(find.text('Next'));
          await tester.pumpAndSettle();
        }
      }
      await tester.ensureVisible(find.text('Next'));
      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Quiz Completed!'), findsOneWidget);
      await tester.tap(find.text('View Overview'));
      await tester.pumpAndSettle();
      expect(find.byType(QuizOverviewPage), findsOneWidget);
      expect(find.text('Total Quizzes'), findsOneWidget);
      expect(find.text('Average Score'), findsOneWidget);
      expect(find.textContaining('out of 8 in'), findsOneWidget);

      await tester.tap(
        find.byIcon(
          AppIcons.arrowBack(tester.element(find.byType(QuizOverviewPage))),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);

      // Subsequent tap on Home Quiz Card now opens QuizOverviewPage.
      await tester.tap(find.text('Idiom Quiz'));
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      expect(find.byType(QuizOverviewPage), findsOneWidget);

      // Tapping a taken exam opens read-only QuizReviewPage.
      await tester.tap(find.textContaining('out of 8 in').first);
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      expect(find.byType(QuizReviewPage), findsOneWidget);
      expect(find.text('Review Only'), findsOneWidget);
      expect(find.text('Submit Quiz'), findsNothing);

      await tester.tap(
        find.byIcon(
          AppIcons.arrowBack(tester.element(find.byType(QuizReviewPage))),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(QuizOverviewPage), findsOneWidget);

      await tester.tap(
        find.byIcon(
          AppIcons.arrowBack(tester.element(find.byType(QuizOverviewPage))),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Favorites tab disables search & hides clear button when empty.
      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();
      expect(find.byType(FavoritesPage), findsOneWidget);
      final emptyFavSearchFinder = find.descendant(
        of: find.byType(FavoritesPage),
        matching: find.byType(MyTextField),
      );
      expect(emptyFavSearchFinder, findsOneWidget);
      expect(tester.widget<MyTextField>(emptyFavSearchFinder).enabled, isFalse);
      expect(
        find.descendant(
          of: find.byType(FavoritesPage),
          matching: find.byIcon(AppIcons.clear),
        ),
        findsNothing,
      );

      // Verify Flashcards tab hides floating & clear buttons when empty.
      await tester.tap(find.text('Flashcards'));
      await tester.pumpAndSettle();
      expect(find.byType(FlashcardsPage), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(FlashcardsPage),
          matching: find.byType(MyFloatingButton),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byType(FlashcardsPage),
          matching: find.byIcon(AppIcons.clear),
        ),
        findsNothing,
      );

      // Switch to Explore tab and verify settings button + filter button inside search field.
      await tester.tap(find.text('Explore'));
      await tester.pumpAndSettle();
      expect(find.byType(IdiomsPage), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(IdiomsPage),
          matching: find.byIcon(AppIcons.settings),
        ),
        findsOneWidget,
      );
      expect(find.text('Break the ice'), findsOneWidget);
      expect(find.text('Call it a day'), findsOneWidget);

      await tester.tap(find.byIcon(AppIcons.filter));
      await tester.pumpAndSettle();
      expect(find.byType(SelectCategorySheet), findsOneWidget);
      expect(find.text('Select Category'), findsOneWidget);
      await tester.tap(find.text('Business'));
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Call it a day'), findsOneWidget);
      expect(find.text('Break the ice'), findsNothing);

      // Clear category filter via 'All' in the category sheet.
      await tester.tap(find.byIcon(AppIcons.filter));
      await tester.pumpAndSettle();
      await tester.tap(find.text('All'));
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Break the ice'), findsOneWidget);

      // Open Idiom Details, toggle favorite, save to flashcard group, and open share sheet.
      await tester.tap(find.text('Break the ice'));
      await tester.pumpAndSettle();
      expect(find.byType(IdiomDetailPage), findsOneWidget);

      await tester.tap(find.byIcon(AppIcons.favorite));
      await tester.pumpAndSettle();
      expect(find.byIcon(AppIcons.favoriteFilled), findsOneWidget);

      await tester.tap(find.byIcon(AppIcons.flashcards));
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Saved to "Daily Life"'), findsOneWidget);
      expect(find.text('Change'), findsOneWidget);

      await tester.tap(find.byIcon(AppIcons.share));
      await tester.pumpAndSettle();
      expect(find.byType(IdiomShareSheet), findsOneWidget);
      expect(find.byType(IdiomShareCard), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(IdiomShareCard),
          matching: find.byIcon(AppIcons.quoteUp),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(IdiomShareCard),
          matching: find.byIcon(AppIcons.quoteDown),
        ),
        findsOneWidget,
      );
      expect(find.text('WhatsApp'), findsOneWidget);
      expect(find.text('Copy'), findsOneWidget);
      expect(find.text('Save Image'), findsOneWidget);
      expect(find.text('Share Image'), findsOneWidget);
      expect(find.text('Share Text'), findsOneWidget);
      expect(find.text('Other'), findsOneWidget);

      await tester.tap(find.byIcon(AppIcons.close));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byIcon(
          AppIcons.arrowBack(tester.element(find.byType(IdiomDetailPage))),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Favorites tab shows search, filter icon, and clear button when non-empty.
      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();
      expect(find.byType(FavoritesPage), findsOneWidget);
      expect(find.text('Break the ice'), findsOneWidget);
      final favSearchFinder = find.descendant(
        of: find.byType(FavoritesPage),
        matching: find.byType(MyTextField),
      );
      expect(favSearchFinder, findsOneWidget);
      expect(tester.widget<MyTextField>(favSearchFinder).enabled, isTrue);
      expect(
        find.descendant(
          of: find.byType(FavoritesPage),
          matching: find.byIcon(AppIcons.filter),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(FavoritesPage),
          matching: find.byIcon(AppIcons.clear),
        ),
        findsOneWidget,
      );

      // Verify Flashcards tab shows auto-created 'Daily Life' group, clear, and floating button.
      await tester.tap(find.text('Flashcards'));
      await tester.pumpAndSettle();
      expect(find.byType(FlashcardsPage), findsOneWidget);
      expect(find.text('Daily Life'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(FlashcardsPage),
          matching: find.byType(MyFloatingButton),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(FlashcardsPage),
          matching: find.byIcon(AppIcons.clear),
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Daily Life'));
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      expect(find.byType(FlashcardStudyPage), findsOneWidget);
      expect(find.text('Break the ice'), findsOneWidget);
      expect(find.text('Flip Card'), findsNothing);
      final frontSize = tester.getSize(find.byType(FlashcardFrontCard));

      // Tap the card to flip it and verify front/back share the same height.
      await tester.tap(find.text('Break the ice'));
      await tester.pumpAndSettle();
      expect(find.text('يكسر الجليد'), findsOneWidget);
      final backSize = tester.getSize(find.byType(FlashcardBackCard));
      expect(backSize.height, frontSize.height);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      final resetFuture = sl.reset();
      await tester.pump(const Duration(milliseconds: 50));
      await resetFuture;
    },
  );
}
