import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/routes/app_router.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/app/theme/material_theme.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/services/cash/cash_service.dart';
import 'package:idiomer/core/utils/helpers/ui/app_navigator.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/flashcards/domain/repositories/flashcards_repository.dart';
import 'package:idiomer/features/flashcards/domain/usecases/watch_flashcard_groups_usecase.dart';
import 'package:idiomer/features/home/presentation/cubit/home_cubit.dart';
import 'package:idiomer/features/home/presentation/pages/home_page.dart';
import 'package:idiomer/features/home/presentation/widgets/home_categories_section.dart';
import 'package:idiomer/features/home/presentation/widgets/home_flashcards_section.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/domain/repositories/idioms_repository.dart';
import 'package:idiomer/features/idioms/domain/usecases/toggle_favorite_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_categories_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_idiom_of_the_day_usecase.dart';
import 'package:idiomer/features/idioms/presentation/widgets/explore_header.dart';
import 'package:idiomer/features/idioms/presentation/widgets/select_category_sheet.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_stats_entity.dart';
import 'package:idiomer/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:idiomer/features/quiz/domain/usecases/watch_quiz_stats_usecase.dart';
import 'package:idiomer/shared/widgets/appbars/my_gradient_header.dart';
import 'package:idiomer/shared/widgets/chips/animated_chip.dart';
import 'package:idiomer/shared/widgets/misc/my_bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _StubIdiomsRepository implements IdiomsRepository {
  final List<CategoryEntity> categories;

  _StubIdiomsRepository({required this.categories});

  @override
  Stream<IdiomDetailEntity?> watchIdiomOfTheDay({DateTime? date}) =>
      Stream.value(null);

  @override
  Stream<List<CategoryEntity>> watchCategories() => Stream.value(categories);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _StubFlashcardsRepository implements FlashcardsRepository {
  final List<FlashcardGroupEntity> groups;

  _StubFlashcardsRepository(this.groups);

  @override
  Stream<List<FlashcardGroupEntity>> watchGroups() => Stream.value(groups);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _StubQuizRepository implements QuizRepository {
  @override
  Stream<QuizStatsEntity> watchQuizStats() =>
      Stream.value(const QuizStatsEntity());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await CashService.instance.init();
  });

  Widget buildHome(HomeCubit cubit) {
    return MaterialApp(
      theme: const MaterialTheme().light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider(create: (_) => cubit, child: const HomePage()),
    );
  }

  const categories = [
    CategoryEntity(
      id: 'business',
      displayOrder: 1,
      englishName: 'Business',
      arabicName: 'الأعمال',
    ),
    CategoryEntity(
      id: 'daily_life',
      displayOrder: 2,
      englishName: 'Daily Life',
      arabicName: 'الحياة اليومية',
    ),
  ];

  testWidgets(
    'HomePage hides Continue Studying when no studyable decks exist and shows Browse Categories',
    (tester) async {
      final idiomsRepo = _StubIdiomsRepository(categories: categories);
      final flashcardsRepo = _StubFlashcardsRepository([
        FlashcardGroupEntity(
          id: 1,
          name: 'Empty Deck',
          idiomCount: 0,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      ]);
      final cubit = HomeCubit(
        watchIdiomOfTheDay: WatchIdiomOfTheDayUseCase(idiomsRepo),
        watchQuizStats: WatchQuizStatsUseCase(_StubQuizRepository()),
        watchFlashcardGroups: WatchFlashcardGroupsUseCase(flashcardsRepo),
        watchCategories: WatchCategoriesUseCase(idiomsRepo),
        toggleFavorite: ToggleFavoriteUseCase(idiomsRepo),
      )..watchHome();

      await tester.pumpWidget(buildHome(cubit));
      await tester.pump();
      await tester.pump();

      expect(find.byType(HomeFlashcardsSection), findsNothing);
      expect(find.text('Continue Studying'), findsNothing);
      expect(find.byType(HomeCategoriesSection), findsOneWidget);
      expect(find.text('Browse Categories'), findsOneWidget);
      expect(find.widgetWithText(AnimatedChip, 'Business'), findsOneWidget);
      expect(find.widgetWithText(AnimatedChip, 'Daily Life'), findsOneWidget);
    },
  );

  testWidgets(
    'HomePage displays Continue Studying decks when studyable groups are available',
    (tester) async {
      final idiomsRepo = _StubIdiomsRepository(categories: categories);
      final flashcardsRepo = _StubFlashcardsRepository([
        FlashcardGroupEntity(
          id: 1,
          name: 'Travel Idioms',
          idiomCount: 5,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
        FlashcardGroupEntity(
          id: 2,
          name: 'Empty Deck',
          idiomCount: 0,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      ]);
      final cubit = HomeCubit(
        watchIdiomOfTheDay: WatchIdiomOfTheDayUseCase(idiomsRepo),
        watchQuizStats: WatchQuizStatsUseCase(_StubQuizRepository()),
        watchFlashcardGroups: WatchFlashcardGroupsUseCase(flashcardsRepo),
        watchCategories: WatchCategoriesUseCase(idiomsRepo),
        toggleFavorite: ToggleFavoriteUseCase(idiomsRepo),
      )..watchHome();

      await tester.pumpWidget(buildHome(cubit));
      await tester.pump();
      await tester.pump();

      expect(find.byType(HomeFlashcardsSection), findsOneWidget);
      expect(find.text('Continue Studying'), findsOneWidget);
      expect(find.text('Travel Idioms'), findsOneWidget);
      expect(find.text('5 idioms'), findsOneWidget);
      expect(find.text('Empty Deck'), findsNothing);
    },
  );

  test('AppRouter configures Flashcards as the 3rd shell branch', () {
    final router = AppRouter.createRouter(initialLocation: AppRoutes.dbSetup);
    addTearDown(router.dispose);

    final shellRoute = router.configuration.routes
        .whereType<StatefulShellRoute>()
        .single;
    final branchPaths = shellRoute.branches
        .map((b) => (b.routes.first as GoRoute).path)
        .toList();

    expect(branchPaths, [
      AppRoutes.home,
      AppRoutes.idioms,
      AppRoutes.flashcards,
      AppRoutes.favorites,
    ]);
    expect(MyBottomNavigationBar, isNotNull);
  });

  testWidgets(
    'HomePage View All on Browse Categories opens SelectCategorySheet',
    (tester) async {
      final idiomsRepo = _StubIdiomsRepository(categories: categories);
      final flashcardsRepo = _StubFlashcardsRepository(const []);
      final cubit = HomeCubit(
        watchIdiomOfTheDay: WatchIdiomOfTheDayUseCase(idiomsRepo),
        watchQuizStats: WatchQuizStatsUseCase(_StubQuizRepository()),
        watchFlashcardGroups: WatchFlashcardGroupsUseCase(flashcardsRepo),
        watchCategories: WatchCategoriesUseCase(idiomsRepo),
        toggleFavorite: ToggleFavoriteUseCase(idiomsRepo),
      )..watchHome();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: AppNavigator.key,
          theme: const MaterialTheme().light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider(create: (_) => cubit, child: const HomePage()),
        ),
      );
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('View All'));
      await tester.pumpAndSettle();

      expect(find.byType(SelectCategorySheet), findsOneWidget);
      expect(find.text('Select Category'), findsOneWidget);

      await tester.tap(find.byIcon(AppIcons.close));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'ExploreFixedHeader stays fixed above CustomScrollView while ExploreSearchHeader floats below it',
    (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      String? selectedCategory = 'Business';

      await tester.pumpWidget(
        MaterialApp(
          theme: const MaterialTheme().light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(padding: const EdgeInsets.only(top: 44)),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Scaffold(
                      body: Column(
                        children: [
                          const ExploreFixedHeader(title: 'Explore'),
                          Expanded(
                            child: CustomScrollView(
                              slivers: [
                                ExploreSearchHeader(
                                  searchController: controller,
                                  onSearchChanged: (_) {},
                                  hasCategories: true,
                                  hasActiveCategoryFilter:
                                      selectedCategory != null,
                                  selectedCategoryName: selectedCategory,
                                  onClearCategory: () =>
                                      setState(() => selectedCategory = null),
                                  onOpenCategorySheet: () {},
                                ),
                                SliverList.builder(
                                  itemCount: 30,
                                  itemBuilder: (context, index) => SizedBox(
                                    height: 60,
                                    child: Text('Item $index'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      );

      final chipFinder = find.widgetWithText(AnimatedChip, 'Business');
      expect(chipFinder, findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);

      await tester.tap(chipFinder);
      await tester.pumpAndSettle();

      expect(selectedCategory, isNull);
      expect(find.widgetWithText(AnimatedChip, 'Business'), findsNothing);

      // Scroll down: fixed header remains visible while floating search bar scrolls out.
      await tester.timedDrag(
        find.byType(CustomScrollView),
        const Offset(0, -300),
        const Duration(milliseconds: 200),
      );
      await tester.pumpAndSettle();
      expect(find.text('Explore'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);

      // Scroll back slightly: floating search bar reappears below fixed header (never behind it).
      await tester.timedDrag(
        find.byType(CustomScrollView),
        const Offset(0, 120),
        const Duration(milliseconds: 200),
      );
      await tester.pumpAndSettle();
      expect(find.text('Explore'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(
        tester.getTopLeft(find.byType(TextField)).dy,
        greaterThanOrEqualTo(
          tester.getBottomLeft(find.byType(ExploreFixedHeader)).dy,
        ),
      );
    },
  );

  testWidgets(
    'ScrollUnderHeaderColumn adds bottom border to MyGradientHeader when scrolled',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: const MaterialTheme().light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ScrollUnderHeaderColumn(
              headerBuilder: (context, showBottomBorder) => MyGradientHeader(
                title: 'Flashcards',
                showBottomBorder: showBottomBorder,
              ),
              body: ListView.builder(
                itemCount: 30,
                itemBuilder: (context, index) =>
                    SizedBox(height: 60, child: Text('Row $index')),
              ),
            ),
          ),
        ),
      );

      BoxDecoration headerDecoration() {
        final container = tester.widget<AnimatedContainer>(
          find.descendant(
            of: find.byType(MyGradientHeader),
            matching: find.byType(AnimatedContainer),
          ),
        );
        return container.decoration! as BoxDecoration;
      }

      expect(headerDecoration().border, isNull);

      await tester.drag(find.byType(ListView), const Offset(0, -150));
      await tester.pumpAndSettle();

      expect(headerDecoration().border, isNotNull);
    },
  );
}
