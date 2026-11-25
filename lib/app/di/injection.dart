import 'package:get_it/get_it.dart';
import 'package:idiomer/core/services/cash/cash_service.dart';
import 'package:idiomer/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:idiomer/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:idiomer/features/settings/domain/repositories/settings_repository.dart';
import 'package:idiomer/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:idiomer/features/settings/domain/usecases/update_language_usecase.dart';
import 'package:idiomer/features/settings/domain/usecases/update_theme_mode_usecase.dart';
import 'package:idiomer/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies({SharedPreferences? prefs}) async {
  await CashService.instance.init(prefs);

  _initCore();
  _initSettings();
}

void _initCore() {
  if (!sl.isRegistered<CashService>()) {
    sl.registerSingleton<CashService>(CashService.instance);
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
