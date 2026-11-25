import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/di/injection.dart';
import 'package:idiomer/core/utils/helpers/ui/app_navigator.dart';
import 'package:idiomer/features/app_shell/presentation/pages/app_shell_page.dart';
import 'package:idiomer/features/db_setup/presentation/cubit/db_setup_cubit.dart';
import 'package:idiomer/features/db_setup/presentation/pages/db_setup_page.dart';
import 'package:idiomer/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:idiomer/features/favorites/presentation/pages/favorites_page.dart';
import 'package:idiomer/features/flashcards/presentation/pages/flashcards_page.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_bloc.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_event.dart';
import 'package:idiomer/features/idioms/presentation/cubit/idiom_detail_cubit.dart';
import 'package:idiomer/features/idioms/presentation/pages/idiom_detail_page.dart';
import 'package:idiomer/features/idioms/presentation/pages/idioms_page.dart';
import 'package:idiomer/features/settings/presentation/pages/settings_page.dart';

import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static GoRouter createRouter({String initialLocation = AppRoutes.dbSetup}) {
    return GoRouter(
      navigatorKey: AppNavigator.key,
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: AppRoutes.dbSetup,
          name: AppRoutes.dbSetup,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<DbSetupCubit>(),
            child: const DbSetupPage(),
          ),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AppShellPage(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.idioms,
                  name: AppRoutes.idioms,
                  builder: (context, state) => BlocProvider(
                    create: (_) => sl<IdiomsBloc>()..add(const IdiomsStarted()),
                    child: const IdiomsPage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.favorites,
                  name: AppRoutes.favorites,
                  builder: (context, state) => BlocProvider(
                    create: (_) =>
                        sl<FavoritesBloc>()..add(const IdiomsStarted()),
                    child: const FavoritesPage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.flashcards,
                  name: AppRoutes.flashcards,
                  builder: (context, state) => const FlashcardsPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.settings,
                  name: AppRoutes.settings,
                  builder: (context, state) => const SettingsPage(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '${AppRoutes.idiomDetail}/:id',
          name: AppRoutes.idiomDetail,
          builder: (context, state) {
            final idiomId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
            return BlocProvider(
              create: (_) => sl<IdiomDetailCubit>(),
              child: IdiomDetailPage(idiomId: idiomId),
            );
          },
        ),
      ],
    );
  }
}
