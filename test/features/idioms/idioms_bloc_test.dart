import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/core/database/app_database.dart';
import 'package:idiomer/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:idiomer/features/idioms/data/datasources/idioms_local_datasource.dart';
import 'package:idiomer/features/idioms/data/repositories/idioms_repository_impl.dart';
import 'package:idiomer/features/idioms/domain/usecases/clear_all_favorites_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/toggle_favorite_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_categories_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_idioms_usecase.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_bloc.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_event.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_state.dart';

import 'idioms_local_datasource_test.dart';

void main() {
  late AppDatabase db;
  late IdiomsRepositoryImpl repository;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await seedTestDatabase(db);
    repository = IdiomsRepositoryImpl(
      localDataSource: IdiomsLocalDataSourceImpl(database: db),
    );
  });

  tearDown(() async {
    await db.close();
  });

  blocTest<IdiomsBloc, IdiomsState>(
    'IdiomsBloc loads categories and idioms, filters, and toggles favorite',
    build: () => IdiomsBloc(
      watchIdioms: WatchIdiomsUseCase(repository),
      watchCategories: WatchCategoriesUseCase(repository),
      toggleFavorite: ToggleFavoriteUseCase(repository),
    ),
    act: (bloc) async {
      bloc.add(const IdiomsStarted());
      await Future<void>.delayed(const Duration(milliseconds: 50));
      bloc.add(const IdiomsCategorySelected('business'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      bloc.add(const IdiomsFavoriteToggled(2));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    },
    verify: (bloc) {
      expect(bloc.state.status, IdiomsStatus.loaded);
      expect(bloc.state.categories.length, 2);
      expect(bloc.state.selectedCategoryId, 'business');
      expect(bloc.state.idioms.length, 1);
      expect(bloc.state.idioms.first.id, 2);
      expect(bloc.state.idioms.first.isFavorite, isTrue);
    },
  );

  blocTest<FavoritesBloc, IdiomsState>(
    'FavoritesBloc reflects saved favorites and clears all favorites',
    build: () => FavoritesBloc(
      watchIdioms: WatchIdiomsUseCase(repository),
      watchCategories: WatchCategoriesUseCase(repository),
      toggleFavorite: ToggleFavoriteUseCase(repository),
      clearAllFavorites: ClearAllFavoritesUseCase(repository),
    ),
    act: (bloc) async {
      await repository.setFavorite(1, isFavorite: true);
      bloc.add(const IdiomsStarted());
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.idioms.length, 1);
      bloc.add(const FavoritesClearedRequested());
      await Future<void>.delayed(const Duration(milliseconds: 50));
    },
    verify: (bloc) {
      expect(bloc.state.status, IdiomsStatus.loaded);
      expect(bloc.state.idioms, isEmpty);
    },
  );

  blocTest<FavoritesBloc, IdiomsState>(
    'FavoritesBloc marks isApplyingFilter during clear filters until stream refreshes',
    build: () => FavoritesBloc(
      watchIdioms: WatchIdiomsUseCase(repository),
      watchCategories: WatchCategoriesUseCase(repository),
      toggleFavorite: ToggleFavoriteUseCase(repository),
      clearAllFavorites: ClearAllFavoritesUseCase(repository),
    ),
    act: (bloc) async {
      await repository.setFavorite(1, isFavorite: true);
      bloc.add(const IdiomsStarted());
      await Future<void>.delayed(const Duration(milliseconds: 50));
      bloc.add(const IdiomsSearchChanged('no_match_query'));
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(bloc.state.idioms, isEmpty);
      expect(bloc.state.hasActiveFilters, isTrue);

      bloc.add(const IdiomsFiltersCleared());
      await Future<void>.delayed(const Duration(milliseconds: 50));
    },
    verify: (bloc) {
      expect(bloc.state.hasActiveFilters, isFalse);
      expect(bloc.state.isApplyingFilter, isFalse);
      expect(bloc.state.idioms.length, 1);
    },
  );
}
