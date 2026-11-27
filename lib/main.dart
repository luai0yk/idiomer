import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/core/constants/app_constants.dart';
import 'package:idiomer/core/utils/helpers/settings_helper.dart';

import 'app/di/injection.dart';
import 'app/l10n/app_locale_config.dart';
import 'app/routes/app_router.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/material_theme.dart';
import 'features/db_setup/domain/usecases/check_database_ready_usecase.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_state.dart';

Future<String> resolveInitialLocation({
  required CheckDatabaseReadyUseCase checkDatabaseReady,
}) async {
  try {
    final isDbReady = await checkDatabaseReady();
    if (isDbReady) {
      return SettingsHelper.routeForDefaultTab(SettingsHelper.defaultTab);
    }
  } catch (error, stackTrace) {
    if (kDebugMode) {
      debugPrint('Failed to check database readiness: $error\n$stackTrace');
    }
  }
  return AppRoutes.dbSetup;
}

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Keep native splash visible until dependencies and pre-downloaded DB check complete.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  var initialLocation = AppRoutes.dbSetup;
  try {
    await initDependencies();
    initialLocation = await resolveInitialLocation(
      checkDatabaseReady: sl<CheckDatabaseReadyUseCase>(),
    );
  } finally {
    FlutterNativeSplash.remove();
  }

  runApp(MyApp(initialLocation: initialLocation));
}

class MyApp extends StatefulWidget {
  final GoRouter? router;
  final String? initialLocation;

  const MyApp({super.key, this.router, this.initialLocation});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Keep GoRouter instance stable across SettingsCubit theme/locale rebuilds.
  late final GoRouter _router =
      widget.router ??
      AppRouter.createRouter(
        initialLocation: widget.initialLocation ?? AppRoutes.dbSetup,
      );

  @override
  void dispose() {
    if (widget.router == null) {
      _router.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(create: (_) => sl<SettingsCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp.router(
            routerConfig: _router,
            title: 'Idiomer',
            debugShowCheckedModeBanner: false,
            theme: const MaterialTheme().light(),
            darkTheme: const MaterialTheme().dark(),
            themeMode: settingsState.themeMode,
            supportedLocales: AppLocaleConfig.supportedLocales,
            localizationsDelegates: AppLocaleConfig.localizationsDelegates,
            localeResolutionCallback: AppLocaleConfig.resolve,
            locale: settingsState.locale,
            builder: (context, child) {
              final theme = Theme.of(context);

              final textTheme = MaterialTheme.responsiveTextTheme(context)
                  .apply(
                    bodyColor: theme.colorScheme.onSurface,
                    displayColor: theme.colorScheme.onSurface,
                    fontFamily: AppConstants.fontFamily,
                  );

              final systemOverlayStyle = SystemUiOverlayStyle(
                systemNavigationBarColor: theme.colorScheme.surface,
                systemNavigationBarIconBrightness:
                    theme.brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light,
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: theme.brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light,
                statusBarBrightness: theme.brightness == Brightness.light
                    ? Brightness.light
                    : Brightness.dark,
              );

              return Theme(
                data: theme.copyWith(textTheme: textTheme),
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: systemOverlayStyle,
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
