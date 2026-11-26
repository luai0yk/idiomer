import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/di/injection.dart';
import 'package:idiomer/core/utils/helpers/ui/app_navigator.dart';
import 'package:idiomer/features/app_shell/presentation/pages/app_shell_page.dart';
import 'package:idiomer/features/db_setup/presentation/cubit/db_setup_cubit.dart';
import 'package:idiomer/features/db_setup/presentation/pages/db_setup_page.dart';
import 'package:idiomer/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:idiomer/features/favorites/presentation/pages/favorites_page.dart';
import 'package:idiomer/features/flashcards/domain/usecases/get_group_study_cards_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/watch_flashcard_group_usecase.dart';
import 'package:idiomer/features/flashcards/presentation/cubit/flashcards_cubit.dart';
import 'package:idiomer/features/flashcards/presentation/pages/flashcard_study_page.dart';
import 'package:idiomer/features/flashcards/presentation/pages/flashcards_page.dart';
import 'package:idiomer/features/home/presentation/cubit/home_cubit.dart';
import 'package:idiomer/features/home/presentation/pages/home_page.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_bloc.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_event.dart';
import 'package:idiomer/features/idioms/presentation/cubit/idiom_detail_cubit.dart';
import 'package:idiomer/features/idioms/presentation/pages/idiom_detail_page.dart';
import 'package:idiomer/features/idioms/presentation/pages/idioms_page.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_overview_cubit.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_review_cubit.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_session_cubit.dart';
import 'package:idiomer/features/quiz/presentation/pages/quiz_overview_page.dart';
import 'package:idiomer/features/quiz/presentation/pages/quiz_review_page.dart';
import 'package:idiomer/features/quiz/presentation/pages/quiz_session_page.dart';
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
                  path: AppRoutes.home,
                  name: AppRoutes.home,
                  builder: (context, state) => BlocProvider(
                    create: (_) => sl<HomeCubit>()..watchHome(),
                    child: const HomePage(),
                  ),
                ),
              ],
            ),
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
                  builder: (context, state) => BlocProvider(
                    create: (_) => sl<FlashcardsCubit>()..watchAll(),
                    child: const FlashcardsPage(),
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.settings,
          name: AppRoutes.settings,
          builder: (context, state) => const SettingsPage(withLeading: true),
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
        GoRoute(
          path: '${AppRoutes.flashcardStudy}/:id',
          name: AppRoutes.flashcardStudy,
          builder: (context, state) {
            final groupId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
            return FlashcardStudyPage(
              groupId: groupId,
              getStudyCards: sl<GetGroupStudyCardsUseCase>(),
              watchGroup: sl<WatchFlashcardGroupUseCase>(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.quizOverview,
          name: AppRoutes.quizOverview,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<QuizOverviewCubit>()..watchStats(),
            child: const QuizOverviewPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.quizSession,
          name: AppRoutes.quizSession,
          builder: (context, state) {
            final groupId = int.tryParse(
              state.uri.queryParameters['groupId'] ?? '',
            );
            final groupName = state.uri.queryParameters['groupName'];
            return BlocProvider(
              create: (_) =>
                  sl<QuizSessionCubit>()..startQuiz(flashcardGroupId: groupId),
              child: QuizSessionPage(title: groupName),
            );
          },
        ),
        GoRoute(
          path: '${AppRoutes.quizReview}/:id',
          name: AppRoutes.quizReview,
          builder: (context, state) {
            final attemptId =
                int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
            return BlocProvider(
              create: (_) => sl<QuizReviewCubit>(),
              child: QuizReviewPage(attemptId: attemptId),
            );
          },
        ),
      ],
    );
  }
}
