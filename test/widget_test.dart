import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
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
import 'package:idiomer/features/flashcards/presentation/pages/flashcards_page.dart';
import 'package:idiomer/features/idioms/presentation/pages/idiom_detail_page.dart';
import 'package:idiomer/features/idioms/presentation/pages/idioms_page.dart';
import 'package:idiomer/features/settings/presentation/pages/settings_page.dart';
import 'package:idiomer/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/idioms/idioms_local_datasource_test.dart';

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
    await seedTestDatabase(testDb);
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets(
    'DbSetupPage shows error retry and navigates to AppShell when ready',
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

      expect(find.byType(IdiomsPage), findsOneWidget);
      expect(find.text('Break the ice'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );

  testWidgets(
    'App mounts explorer, filters categories, views details, manages favorites, and switches tabs',
    (WidgetTester tester) async {
      await initDependencies(database: testDb);

      final router = AppRouter.createRouter(initialLocation: AppRoutes.idioms);
      addTearDown(router.dispose);

      await tester.pumpWidget(MyApp(router: router));
      await tester.pumpAndSettle();

      // Explorer displays centered app name, search, categories, and idiom cards.
      expect(find.byType(IdiomsPage), findsOneWidget);
      expect(find.text('Idiomer'), findsOneWidget);
      expect(find.text('Break the ice'), findsOneWidget);
      expect(find.text('Call it a day'), findsOneWidget);

      // Sticky expand/collapse toggle switches horizontal categories into Wrap.
      await tester.tap(find.byIcon(AppIcons.arrowDown));
      await tester.pumpAndSettle();
      expect(find.byIcon(AppIcons.arrowUp), findsOneWidget);

      // Category filtering works.
      await tester.tap(find.text('Business'));
      await tester.pump();
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pumpAndSettle();
      expect(find.text('Call it a day'), findsOneWidget);
      expect(find.text('Break the ice'), findsNothing);

      // Clear category filter via 'All'.
      await tester.tap(find.text('All'));
      await tester.pump();
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pumpAndSettle();
      expect(find.text('Break the ice'), findsOneWidget);

      // Navigate to Idiom Details and toggle favorite.
      await tester.tap(find.text('Break the ice'));
      await tester.pumpAndSettle();
      expect(find.byType(IdiomDetailPage), findsOneWidget);
      expect(
        find.text('To start a friendly conversation and relieve tension.'),
        findsOneWidget,
      );

      await tester.tap(find.byIcon(AppIcons.favorite));
      await tester.pumpAndSettle();
      expect(find.byIcon(AppIcons.favoriteFilled), findsOneWidget);

      // Go back to Explorer and switch to Favorites tab.
      await tester.tap(
        find.byIcon(
          AppIcons.arrowBack(tester.element(find.byType(IdiomDetailPage))),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();
      expect(find.byType(FavoritesPage), findsOneWidget);
      expect(find.text('Break the ice'), findsOneWidget);

      // Switch to Flashcards & Settings tabs.
      await tester.tap(find.text('Flashcards'));
      await tester.pumpAndSettle();
      expect(find.byType(FlashcardsPage), findsOneWidget);
      expect(find.text('No Flashcards Yet'), findsOneWidget);

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);

      await tester.tap(find.text('Theme'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );
}
