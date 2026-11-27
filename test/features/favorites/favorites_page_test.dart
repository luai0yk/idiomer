import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/app/theme/material_theme.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/services/cash/cash_service.dart';
import 'package:idiomer/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:idiomer/features/favorites/presentation/pages/favorites_page.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_entity.dart';
import 'package:idiomer/features/idioms/domain/repositories/idioms_repository.dart';
import 'package:idiomer/features/idioms/domain/usecases/clear_all_favorites_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/toggle_favorite_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_categories_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_idioms_usecase.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _StubIdiomsRepository implements IdiomsRepository {
  final List<IdiomEntity> favorites;

  _StubIdiomsRepository(this.favorites);

  @override
  Stream<List<CategoryEntity>> watchCategories() => Stream.value(const []);

  @override
  Stream<List<IdiomEntity>> watchIdioms({
    String query = '',
    String? categoryId,
    int limit = 50,
    bool favoritesOnly = false,
  }) => Stream.value(favorites);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await CashService.instance.init();
  });

  testWidgets(
    'FavoritesPage shows settings icon in empty and populated states and navigates to settings',
    (tester) async {
      final emptyRepo = _StubIdiomsRepository(const []);
      final emptyBloc = FavoritesBloc(
        watchIdioms: WatchIdiomsUseCase(emptyRepo),
        watchCategories: WatchCategoriesUseCase(emptyRepo),
        toggleFavorite: ToggleFavoriteUseCase(emptyRepo),
        clearAllFavorites: ClearAllFavoritesUseCase(emptyRepo),
      )..add(const IdiomsStarted());
      addTearDown(emptyBloc.close);

      final emptyRouter = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => BlocProvider.value(
              value: emptyBloc,
              child: const FavoritesPage(),
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

      final populatedRepo = _StubIdiomsRepository(const [
        IdiomEntity(
          id: 1,
          englishText: 'Break the ice',
          arabicText: 'كسر الجليد',
          isFavorite: true,
        ),
      ]);
      final populatedBloc = FavoritesBloc(
        watchIdioms: WatchIdiomsUseCase(populatedRepo),
        watchCategories: WatchCategoriesUseCase(populatedRepo),
        toggleFavorite: ToggleFavoriteUseCase(populatedRepo),
        clearAllFavorites: ClearAllFavoritesUseCase(populatedRepo),
      )..add(const IdiomsStarted());
      addTearDown(populatedBloc.close);

      final populatedRouter = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => BlocProvider.value(
              value: populatedBloc,
              child: const FavoritesPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (_, _) => const Scaffold(body: Text('Settings Target')),
          ),
        ],
      );
      addTearDown(populatedRouter.dispose);

      await tester.pumpWidget(
        MaterialApp.router(
          theme: const MaterialTheme().light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: populatedRouter,
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
