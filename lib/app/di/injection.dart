import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:idiomer/core/database/app_database.dart';
import 'package:idiomer/core/database/database_paths.dart';
import 'package:idiomer/core/services/cash/cash_service.dart';
import 'package:idiomer/features/db_setup/data/datasources/db_setup_local_datasource.dart';
import 'package:idiomer/features/db_setup/data/datasources/db_setup_remote_datasource.dart';
import 'package:idiomer/features/db_setup/data/repositories/db_setup_repository_impl.dart';
import 'package:idiomer/features/db_setup/domain/repositories/db_setup_repository.dart';
import 'package:idiomer/features/db_setup/domain/usecases/initialize_database_usecase.dart';
import 'package:idiomer/features/db_setup/presentation/cubit/db_setup_cubit.dart';
import 'package:idiomer/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:idiomer/features/flashcards/data/datasources/flashcards_local_datasource.dart';
import 'package:idiomer/features/flashcards/data/repositories/flashcards_repository_impl.dart';
import 'package:idiomer/features/flashcards/domain/repositories/flashcards_repository.dart';
import 'package:idiomer/features/flashcards/domain/usecases/add_idiom_to_default_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/add_idiom_to_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/clear_all_flashcard_groups_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/create_flashcard_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/delete_flashcard_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/get_group_study_cards_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/move_idiom_to_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/remove_idiom_from_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/rename_flashcard_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/watch_flashcard_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/watch_flashcard_groups_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/watch_group_idioms_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/watch_groups_for_idiom_usecase.dart';
import 'package:idiomer/features/flashcards/presentation/cubit/flashcards_cubit.dart';
import 'package:idiomer/features/home/presentation/cubit/home_cubit.dart';
import 'package:idiomer/features/idioms/data/datasources/idioms_local_datasource.dart';
import 'package:idiomer/features/idioms/data/repositories/idioms_repository_impl.dart';
import 'package:idiomer/features/idioms/domain/repositories/idioms_repository.dart';
import 'package:idiomer/features/idioms/domain/usecases/clear_all_favorites_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/toggle_favorite_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_categories_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_idiom_detail_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_idiom_of_the_day_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_idioms_usecase.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_bloc.dart';
import 'package:idiomer/features/idioms/presentation/cubit/idiom_detail_cubit.dart';
import 'package:idiomer/features/quiz/data/datasources/quiz_local_datasource.dart';
import 'package:idiomer/features/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:idiomer/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:idiomer/features/quiz/domain/usecases/generate_quiz_usecase.dart';
import 'package:idiomer/features/quiz/domain/usecases/get_quiz_attempt_review_usecase.dart';
import 'package:idiomer/features/quiz/domain/usecases/save_quiz_attempt_usecase.dart';
import 'package:idiomer/features/quiz/domain/usecases/watch_quiz_stats_usecase.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_overview_cubit.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_review_cubit.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_session_cubit.dart';
import 'package:idiomer/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:idiomer/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:idiomer/features/settings/domain/repositories/settings_repository.dart';
import 'package:idiomer/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:idiomer/features/settings/domain/usecases/update_language_usecase.dart';
import 'package:idiomer/features/settings/domain/usecases/update_theme_mode_usecase.dart';
import 'package:idiomer/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies({
  SharedPreferences? prefs,
  AppDatabase? database,
  DbSetupRepository? dbSetupRepository,
}) async {
  await CashService.instance.init(prefs);

  _initCore(database: database);
  _initSettings();
  _initDbSetup(dbSetupRepository: dbSetupRepository);
  _initIdioms();
  _initFlashcards();
  _initQuiz();
  _initHome();
}

void _initCore({AppDatabase? database}) {
  if (!sl.isRegistered<CashService>()) {
    sl.registerSingleton<CashService>(CashService.instance);
  }
  if (!sl.isRegistered<DatabasePaths>()) {
    sl.registerLazySingleton<DatabasePaths>(() => const DatabasePaths());
  }
  if (!sl.isRegistered<AppDatabase>()) {
    if (database != null) {
      sl.registerSingleton<AppDatabase>(database, dispose: (db) => db.close());
    } else {
      sl.registerLazySingleton<AppDatabase>(
        () => AppDatabase(null, sl()),
        dispose: (db) => db.close(),
      );
    }
  }
}

void _initSettings() {
  sl
    ..registerLazySingleton<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(cashService: sl()),
    )
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton<GetSettingsUseCase>(() => GetSettingsUseCase(sl()))
    ..registerLazySingleton<UpdateThemeModeUseCase>(
      () => UpdateThemeModeUseCase(sl()),
    )
    ..registerLazySingleton<UpdateLanguageUseCase>(
      () => UpdateLanguageUseCase(sl()),
    )
    ..registerFactory<SettingsCubit>(
      () => SettingsCubit(
        getSettings: sl(),
        updateThemeMode: sl(),
        updateLanguage: sl(),
      ),
    );
}

void _initDbSetup({DbSetupRepository? dbSetupRepository}) {
  sl
    ..registerLazySingleton<DbSetupLocalDataSource>(
      () => DbSetupLocalDataSourceImpl(paths: sl(), database: sl()),
    )
    ..registerLazySingleton<DbSetupRemoteDataSource>(
      () => DbSetupRemoteDataSourceImpl(
        dio: Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(minutes: 2),
            sendTimeout: const Duration(seconds: 20),
          ),
        ),
        connectivity: Connectivity(),
      ),
    )
    ..registerLazySingleton<DbSetupRepository>(
      () =>
          dbSetupRepository ?? DbSetupRepositoryImpl(local: sl(), remote: sl()),
    )
    ..registerLazySingleton<InitializeDatabaseUseCase>(
      () => InitializeDatabaseUseCase(sl()),
    )
    ..registerFactory<DbSetupCubit>(
      () => DbSetupCubit(initializeDatabase: sl()),
    );
}

void _initIdioms() {
  sl
    ..registerLazySingleton<IdiomsLocalDataSource>(
      () => IdiomsLocalDataSourceImpl(database: sl()),
    )
    ..registerLazySingleton<IdiomsRepository>(
      () => IdiomsRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton<WatchCategoriesUseCase>(
      () => WatchCategoriesUseCase(sl()),
    )
    ..registerLazySingleton<WatchIdiomsUseCase>(() => WatchIdiomsUseCase(sl()))
    ..registerLazySingleton<WatchIdiomDetailUseCase>(
      () => WatchIdiomDetailUseCase(sl()),
    )
    ..registerLazySingleton<WatchIdiomOfTheDayUseCase>(
      () => WatchIdiomOfTheDayUseCase(sl()),
    )
    ..registerLazySingleton<ToggleFavoriteUseCase>(
      () => ToggleFavoriteUseCase(sl()),
    )
    ..registerLazySingleton<ClearAllFavoritesUseCase>(
      () => ClearAllFavoritesUseCase(sl()),
    )
    ..registerFactory<IdiomsBloc>(
      () => IdiomsBloc(
        watchIdioms: sl(),
        watchCategories: sl(),
        toggleFavorite: sl(),
      ),
    )
    ..registerFactory<FavoritesBloc>(
      () => FavoritesBloc(
        watchIdioms: sl(),
        watchCategories: sl(),
        toggleFavorite: sl(),
        clearAllFavorites: sl(),
      ),
    )
    ..registerFactory<IdiomDetailCubit>(
      () => IdiomDetailCubit(
        watchIdiomDetail: sl(),
        toggleFavorite: sl(),
        watchGroupsForIdiom: sl(),
        watchAllFlashcardGroups: sl(),
        addIdiomToDefaultGroup: sl(),
        moveIdiomToGroup: sl(),
        createFlashcardGroup: sl(),
        removeIdiomFromGroup: sl(),
      ),
    );
}

void _initFlashcards() {
  sl
    ..registerLazySingleton<FlashcardsLocalDataSource>(
      () => FlashcardsLocalDataSourceImpl(
        database: sl(),
        idiomsLocalDataSource: sl(),
      ),
    )
    ..registerLazySingleton<FlashcardsRepository>(
      () => FlashcardsRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton<WatchFlashcardGroupsUseCase>(
      () => WatchFlashcardGroupsUseCase(sl()),
    )
    ..registerLazySingleton<WatchFlashcardGroupUseCase>(
      () => WatchFlashcardGroupUseCase(sl()),
    )
    ..registerLazySingleton<WatchGroupIdiomsUseCase>(
      () => WatchGroupIdiomsUseCase(sl()),
    )
    ..registerLazySingleton<GetGroupStudyCardsUseCase>(
      () => GetGroupStudyCardsUseCase(sl()),
    )
    ..registerLazySingleton<WatchGroupsForIdiomUseCase>(
      () => WatchGroupsForIdiomUseCase(sl()),
    )
    ..registerLazySingleton<CreateFlashcardGroupUseCase>(
      () => CreateFlashcardGroupUseCase(sl()),
    )
    ..registerLazySingleton<RenameFlashcardGroupUseCase>(
      () => RenameFlashcardGroupUseCase(sl()),
    )
    ..registerLazySingleton<DeleteFlashcardGroupUseCase>(
      () => DeleteFlashcardGroupUseCase(sl()),
    )
    ..registerLazySingleton<ClearAllFlashcardGroupsUseCase>(
      () => ClearAllFlashcardGroupsUseCase(sl()),
    )
    ..registerLazySingleton<AddIdiomToGroupUseCase>(
      () => AddIdiomToGroupUseCase(sl()),
    )
    ..registerLazySingleton<AddIdiomToDefaultGroupUseCase>(
      () => AddIdiomToDefaultGroupUseCase(sl()),
    )
    ..registerLazySingleton<MoveIdiomToGroupUseCase>(
      () => MoveIdiomToGroupUseCase(sl()),
    )
    ..registerLazySingleton<RemoveIdiomFromGroupUseCase>(
      () => RemoveIdiomFromGroupUseCase(sl()),
    )
    ..registerFactory<FlashcardsCubit>(
      () => FlashcardsCubit(
        watchGroups: sl(),
        createGroup: sl(),
        renameGroup: sl(),
        deleteGroup: sl(),
        clearAllGroups: sl(),
      ),
    );
}

void _initQuiz() {
  sl
    ..registerLazySingleton<QuizLocalDataSource>(
      () => QuizLocalDataSourceImpl(database: sl()),
    )
    ..registerLazySingleton<QuizRepository>(
      () => QuizRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton<GenerateQuizUseCase>(
      () => GenerateQuizUseCase(sl()),
    )
    ..registerLazySingleton<WatchQuizStatsUseCase>(
      () => WatchQuizStatsUseCase(sl()),
    )
    ..registerLazySingleton<SaveQuizAttemptUseCase>(
      () => SaveQuizAttemptUseCase(sl()),
    )
    ..registerLazySingleton<GetQuizAttemptReviewUseCase>(
      () => GetQuizAttemptReviewUseCase(sl()),
    )
    ..registerFactory<QuizOverviewCubit>(
      () => QuizOverviewCubit(watchQuizStats: sl()),
    )
    ..registerFactory<QuizSessionCubit>(
      () => QuizSessionCubit(generateQuiz: sl(), saveQuizAttempt: sl()),
    )
    ..registerFactory<QuizReviewCubit>(
      () => QuizReviewCubit(getQuizAttemptReview: sl()),
    );
}

void _initHome() {
  sl.registerFactory<HomeCubit>(
    () => HomeCubit(
      watchIdiomOfTheDay: sl(),
      watchQuizStats: sl(),
      toggleFavorite: sl(),
    ),
  );
}
