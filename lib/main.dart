import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/core/constants/app_constants.dart';

import 'app/di/injection.dart';
import 'app/l10n/app_locale_config.dart';
import 'app/routes/app_router.dart';
import 'app/theme/material_theme.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  final GoRouter? router;

  const MyApp({super.key, this.router});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Keep GoRouter instance stable across SettingsCubit theme/locale rebuilds.
  late final GoRouter _router = widget.router ?? AppRouter.createRouter();

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
