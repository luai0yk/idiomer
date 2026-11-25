import 'package:go_router/go_router.dart';
import 'package:idiomer/core/utils/helpers/ui/app_navigator.dart';
import 'package:idiomer/features/app_shell/presentation/pages/app_shell_page.dart';
import 'package:idiomer/features/favorites/presentation/pages/favorites_page.dart';
import 'package:idiomer/features/flashcards/presentation/pages/flashcards_page.dart';
import 'package:idiomer/features/idioms/presentation/pages/idioms_page.dart';
import 'package:idiomer/features/settings/presentation/pages/settings_page.dart';

import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static GoRouter createRouter({String initialLocation = AppRoutes.idioms}) {
    return GoRouter(
      navigatorKey: AppNavigator.key,
      initialLocation: initialLocation,
      routes: [
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
                  builder: (context, state) => const IdiomsPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.favorites,
                  name: AppRoutes.favorites,
                  builder: (context, state) => const FavoritesPage(),
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
      ],
    );
  }
}
