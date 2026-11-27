import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/home/presentation/cubit/home_cubit.dart';
import 'package:idiomer/features/home/presentation/cubit/home_state.dart';
import 'package:idiomer/features/home/presentation/widgets/home_quiz_card.dart';
import 'package:idiomer/features/home/presentation/widgets/home_welcome_header.dart';
import 'package:idiomer/features/home/presentation/widgets/idiom_of_the_day_card.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';
import 'package:idiomer/shared/widgets/misc/my_loading_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.initial ||
              state.status == HomeStatus.loading) {
            return SafeArea(
              child: Center(child: MyLoadingState(label: l10n.loading)),
            );
          }

          if (state.status == HomeStatus.error) {
            return SafeArea(
              child: Center(
                child: MyEmptyState(
                  icon: AppIcons.error,
                  title: l10n.loadErrorTitle,
                  subtitle: l10n.loadErrorSubtitle,
                  actionText: l10n.retry,
                  onAction: () => context.read<HomeCubit>().watchHome(),
                ),
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.only(bottom: context.spaceXl),
            children: [
              HomeWelcomeHeader(
                greeting: _greetingForHour(DateTime.now().hour, l10n),
                subtitle: l10n.homeMotivationalSubtitle,
                onOpenSettings: () => context.push(AppRoutes.settings),
              ),
              context.verticalSpace(6),
              Padding(
                padding: context.insetsHorizontalM,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    context.verticalSpace(8),
                    if (state.idiomOfTheDay != null) ...[
                      IdiomOfTheDayCard(
                        idiom: state.idiomOfTheDay!,
                        onTap: () => context.push(
                          AppRoutes.idiomDetailPath(state.idiomOfTheDay!.id),
                        ),
                        onToggleFavorite: () => context
                            .read<HomeCubit>()
                            .toggleIdiomOfTheDayFavorite(),
                      ),
                      context.verticalSpace(16),
                    ],
                    HomeQuizCard(
                      stats: state.quizStats,
                      onTap: () {
                        if (state.quizStats.hasCompletedQuiz) {
                          context.push(AppRoutes.quizOverview);
                        } else {
                          context.push(AppRoutes.quizSession);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _greetingForHour(int hour, AppLocalizations l10n) {
    if (hour < 12) return l10n.goodMorning;
    if (hour < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }
}
