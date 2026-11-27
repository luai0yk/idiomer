import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/app/theme/material_theme.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/database/app_database.dart';
import 'package:idiomer/core/utils/helpers/ui/app_navigator.dart';
import 'package:idiomer/features/flashcards/data/datasources/flashcards_local_datasource.dart';
import 'package:idiomer/features/flashcards/data/repositories/flashcards_repository_impl.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/flashcards/domain/repositories/flashcards_repository.dart';
import 'package:idiomer/features/flashcards/domain/usecases/clear_all_flashcard_groups_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/create_flashcard_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/delete_flashcard_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/get_group_study_cards_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/rename_flashcard_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/watch_flashcard_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/watch_flashcard_groups_usecase.dart';
import 'package:idiomer/features/flashcards/presentation/cubit/flashcards_cubit.dart';
import 'package:idiomer/features/flashcards/presentation/pages/flashcard_study_page.dart';
import 'package:idiomer/features/flashcards/presentation/pages/flashcards_page.dart';
import 'package:idiomer/features/flashcards/presentation/widgets/flashcard_group_card.dart';
import 'package:idiomer/features/flashcards/presentation/widgets/flashcard_group_idioms_sheet.dart';
import 'package:idiomer/features/flashcards/presentation/widgets/flashcard_group_picker_sheet.dart';
import 'package:idiomer/features/idioms/data/datasources/idioms_local_datasource.dart';

import '../idioms/idioms_local_datasource_test.dart';
import '../quiz/quiz_test.dart';

class _StubFlashcardsRepository implements FlashcardsRepository {
  final List<FlashcardGroupEntity> groups;

  _StubFlashcardsRepository(this.groups);

  @override
  Stream<List<FlashcardGroupEntity>> watchGroups() => Stream.value(groups);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets(
    'FlashcardStudyPage shows group name title, disabled Take Quiz when < 8, supports swipe, and opens idioms sheet',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      await seedTestDatabase(db);

      final idiomsDs = IdiomsLocalDataSourceImpl(database: db);
      final flashcardsDs = FlashcardsLocalDataSourceImpl(
        database: db,
        idiomsLocalDataSource: idiomsDs,
      );
      final repository = FlashcardsRepositoryImpl(
        localDataSource: flashcardsDs,
      );

      final group = await repository.createGroup(name: 'Travel Idioms');
      await repository.addIdiomToGroup(groupId: group.id, idiomId: 1);
      await repository.addIdiomToGroup(groupId: group.id, idiomId: 2);

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: AppNavigator.key,
          theme: const MaterialTheme().light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: FlashcardStudyPage(
            groupId: group.id,
            getStudyCards: GetGroupStudyCardsUseCase(repository),
            watchGroup: WatchFlashcardGroupUseCase(repository),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Header title shows the group name instead of "Study".
      expect(find.text('Travel Idioms'), findsOneWidget);
      expect(find.text('Study'), findsNothing);

      // Swipe horizontally to move from card 1 to card 2.
      expect(find.text('Break the ice'), findsOneWidget);
      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();
      expect(find.text('Call it a day'), findsOneWidget);

      // Swipe back to card 1.
      await tester.fling(find.byType(PageView), const Offset(400, 0), 1000);
      await tester.pumpAndSettle();
      expect(find.text('Break the ice'), findsOneWidget);

      // Open popup menu: group has 2 idioms (< 8), so Take Quiz is visible but disabled.
      await tester.tap(find.byIcon(AppIcons.more));
      await tester.pumpAndSettle();

      expect(find.text('Show Idioms'), findsOneWidget);
      final takeQuizFinder = find.text('Take Quiz');
      expect(takeQuizFinder, findsOneWidget);
      final takeQuizItem = tester.widget<PopupMenuItem<Object?>>(
        find.ancestor(
          of: takeQuizFinder,
          matching: find.byWidgetPredicate((w) => w is PopupMenuItem),
        ),
      );
      expect(takeQuizItem.enabled, isFalse);

      // Open bottom sheet listing idioms in the group and jump to card 2.
      await tester.tap(find.text('Show Idioms'));
      await tester.pumpAndSettle();

      expect(find.byType(FlashcardGroupIdiomsSheet), findsOneWidget);
      expect(find.text('Call it a day'), findsOneWidget);

      await tester.tap(find.text('Call it a day'));
      await tester.pumpAndSettle();

      expect(find.byType(FlashcardGroupIdiomsSheet), findsNothing);
      expect(find.text('Call it a day'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 50));
      await db.close();
    },
  );

  testWidgets(
    'FlashcardGroupCard shows disabled Take Quiz when < 8 and enabled when >= 8',
    (tester) async {
      var tookQuiz = false;

      final emptyishGroup = FlashcardGroupEntity(
        id: 1,
        name: 'Small',
        idiomCount: 3,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: const MaterialTheme().light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: FlashcardGroupCard(
              group: emptyishGroup,
              onTap: () {},
              onTakeQuiz: null,
              onRename: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(AppIcons.more));
      await tester.pumpAndSettle();

      final disabledQuizFinder = find.text('Take Quiz');
      expect(disabledQuizFinder, findsOneWidget);
      final disabledItem = tester.widget<PopupMenuItem<Object?>>(
        find.ancestor(
          of: disabledQuizFinder,
          matching: find.byWidgetPredicate((w) => w is PopupMenuItem),
        ),
      );
      expect(disabledItem.enabled, isFalse);
      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();

      final readyGroup = FlashcardGroupEntity(
        id: 2,
        name: 'Business',
        idiomCount: 8,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: const MaterialTheme().light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: FlashcardGroupCard(
              group: readyGroup,
              onTap: () {},
              onTakeQuiz: () => tookQuiz = true,
              onRename: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(AppIcons.more));
      await tester.pumpAndSettle();

      expect(find.text('Take Quiz'), findsOneWidget);
      await tester.tap(find.text('Take Quiz'));
      await tester.pumpAndSettle();

      expect(tookQuiz, isTrue);
    },
  );

  testWidgets('FlashcardStudyPage enables Take Quiz when group has 8 idioms', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    await seedQuizIdioms(db, total: 10);

    final idiomsDs = IdiomsLocalDataSourceImpl(database: db);
    final flashcardsDs = FlashcardsLocalDataSourceImpl(
      database: db,
      idiomsLocalDataSource: idiomsDs,
    );
    final repository = FlashcardsRepositoryImpl(localDataSource: flashcardsDs);

    final group = await repository.createGroup(name: 'Quiz Ready');
    for (int id = 1; id <= 8; id++) {
      await repository.addIdiomToGroup(groupId: group.id, idiomId: id);
    }

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: AppNavigator.key,
        theme: const MaterialTheme().light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: FlashcardStudyPage(
          groupId: group.id,
          getStudyCards: GetGroupStudyCardsUseCase(repository),
          watchGroup: WatchFlashcardGroupUseCase(repository),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(AppIcons.more));
    await tester.pumpAndSettle();

    expect(find.text('Show Idioms'), findsOneWidget);
    final quizFinder = find.text('Take Quiz');
    expect(quizFinder, findsOneWidget);
    final enabledItem = tester.widget<PopupMenuItem<Object?>>(
      find.ancestor(
        of: quizFinder,
        matching: find.byWidgetPredicate((w) => w is PopupMenuItem),
      ),
    );
    expect(enabledItem.enabled, isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 50));
    await db.close();
  });

  testWidgets(
    'FlashcardsPage does not navigate when clicking zero-idiom group and shows clarifying message',
    (tester) async {
      final emptyGroup = FlashcardGroupEntity(
        id: 1,
        name: 'Empty Deck',
        idiomCount: 0,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );
      final repository = _StubFlashcardsRepository([emptyGroup]);

      final cubit = FlashcardsCubit(
        watchGroups: WatchFlashcardGroupsUseCase(repository),
        createGroup: CreateFlashcardGroupUseCase(repository),
        renameGroup: RenameFlashcardGroupUseCase(repository),
        deleteGroup: DeleteFlashcardGroupUseCase(repository),
        clearAllGroups: ClearAllFlashcardGroupsUseCase(repository),
      );
      addTearDown(cubit.close);

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: AppNavigator.key,
          theme: const MaterialTheme().light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider.value(
            value: cubit..watchAll(),
            child: const FlashcardsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Empty Deck'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.byType(FlashcardsPage), findsOneWidget);
      expect(find.byType(FlashcardStudyPage), findsNothing);
      expect(find.textContaining('No Idioms in This Group'), findsOneWidget);

      // Wait out toast dismiss duration so no pending timer remains.
      await tester.pump(const Duration(seconds: 4));
      await tester.pump(const Duration(milliseconds: 300));
    },
  );

  testWidgets(
    'FlashcardGroupPickerSheet renders FlashcardGroupCard items without menu and selects tapped group',
    (tester) async {
      final group1 = FlashcardGroupEntity(
        id: 1,
        name: 'Business',
        idiomCount: 4,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );
      final group2 = FlashcardGroupEntity(
        id: 2,
        name: 'Travel',
        idiomCount: 7,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

      FlashcardGroupEntity? pickedGroup;

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: AppNavigator.key,
          theme: const MaterialTheme().light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: FlashcardGroupPickerSheet(
              title: 'Choose Group',
              groups: [group1, group2],
              selectedGroup: group1,
              onGroupSelected: (group) async {
                pickedGroup = group;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FlashcardGroupCard), findsNWidgets(2));
      expect(find.byIcon(AppIcons.more), findsNothing);
      expect(find.byIcon(AppIcons.checkCircle), findsOneWidget);
      expect(find.text('Business'), findsOneWidget);
      expect(find.text('Travel'), findsOneWidget);

      await tester.tap(find.text('Travel'));
      await tester.pumpAndSettle();

      expect(pickedGroup, equals(group2));
    },
  );

  testWidgets(
    'FlashcardsPage shows settings icon in both empty and non-empty states and navigates to settings',
    (tester) async {
      final emptyRepo = _StubFlashcardsRepository(const []);
      final emptyCubit = FlashcardsCubit(
        watchGroups: WatchFlashcardGroupsUseCase(emptyRepo),
        createGroup: CreateFlashcardGroupUseCase(emptyRepo),
        renameGroup: RenameFlashcardGroupUseCase(emptyRepo),
        deleteGroup: DeleteFlashcardGroupUseCase(emptyRepo),
        clearAllGroups: ClearAllFlashcardGroupsUseCase(emptyRepo),
      );
      addTearDown(emptyCubit.close);

      final emptyRouter = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => BlocProvider.value(
              value: emptyCubit..watchAll(),
              child: const FlashcardsPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (_, _) => const Scaffold(body: Text('Settings Target')),
          ),
        ],
      );
      addTearDown(emptyRouter.dispose);

      await tester.pumpWidget(
        MaterialApp.router(
          theme: const MaterialTheme().light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: emptyRouter,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(AppIcons.settings), findsOneWidget);
      expect(find.byIcon(AppIcons.clear), findsNothing);

      final groupRepo = _StubFlashcardsRepository([
        FlashcardGroupEntity(
          id: 1,
          name: 'Travel Idioms',
          idiomCount: 2,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      ]);
      final groupCubit = FlashcardsCubit(
        watchGroups: WatchFlashcardGroupsUseCase(groupRepo),
        createGroup: CreateFlashcardGroupUseCase(groupRepo),
        renameGroup: RenameFlashcardGroupUseCase(groupRepo),
        deleteGroup: DeleteFlashcardGroupUseCase(groupRepo),
        clearAllGroups: ClearAllFlashcardGroupsUseCase(groupRepo),
      );
      addTearDown(groupCubit.close);

      final groupRouter = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => BlocProvider.value(
              value: groupCubit..watchAll(),
              child: const FlashcardsPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (_, _) => const Scaffold(body: Text('Settings Target')),
          ),
        ],
      );
      addTearDown(groupRouter.dispose);

      await tester.pumpWidget(
        MaterialApp.router(
          theme: const MaterialTheme().light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: groupRouter,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(AppIcons.clear), findsOneWidget);
      expect(find.byIcon(AppIcons.settings), findsOneWidget);

      await tester.tap(find.byIcon(AppIcons.settings));
      await tester.pumpAndSettle();

      expect(find.text('Settings Target'), findsOneWidget);
    },
  );
}
