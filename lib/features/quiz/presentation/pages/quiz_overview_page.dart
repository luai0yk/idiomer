import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_overview_cubit.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_overview_state.dart';
import 'package:idiomer/features/quiz/presentation/widgets/quiz_attempt_history_card.dart';
import 'package:idiomer/features/quiz/presentation/widgets/quiz_header.dart';
import 'package:idiomer/features/quiz/presentation/widgets/quiz_stat_card.dart';
import 'package:idiomer/shared/widgets/buttons/my_floating_button.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';
import 'package:idiomer/shared/widgets/misc/my_progress_indicator.dart';

class QuizOverviewPage extends StatelessWidget {
  const QuizOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      floatingActionButton: MyFloatingButton.extended(
        label: l10n.newQuiz,
        icon: AppIcons.add,
        onPressed: () => context.push(AppRoutes.quizSession),
      ),
      body: Column(
        children: [
          QuizHeader(title: l10n.quizOverview),
          Expanded(
            child: BlocBuilder<QuizOverviewCubit, QuizOverviewState>(
              builder: (context, state) {
                if (state.status == QuizOverviewStatus.initial ||
                    state.status == QuizOverviewStatus.loading) {
                  return const Center(child: MyProgressIndicator());
                }

                if (state.status == QuizOverviewStatus.error) {
                  return Center(
                    child: MyEmptyState(
                      icon: AppIcons.error,
                      title: l10n.loadErrorTitle,
                      subtitle: l10n.loadErrorSubtitle,
                      actionText: l10n.retry,
                      onAction: () =>
                          context.read<QuizOverviewCubit>().watchStats(),
                    ),
                  );
                }

                final stats = state.stats;
                if (!stats.hasCompletedQuiz) {
                  return Center(
                    child: Padding(
                      padding: context.insetsAllM,
                      child: MyEmptyState(
                        icon: AppIcons.help,
                        title: l10n.noQuizzesYet,
                        subtitle: l10n.noQuizzesSubtitle,
                        actionText: l10n.startQuiz,
                        onAction: () => context.push(AppRoutes.quizSession),
                      ),
                    ),
                  );
                }

                return ListView(
                  padding: EdgeInsets.fromLTRB(
                    context.spaceM,
                    context.spaceS,
                    context.spaceM,
                    context.spaceXxxl + context.spaceXl,
                  ),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: QuizStatCard(
                            icon: AppIcons.chart,
                            label: l10n.totalQuizzes,
                            value: '${stats.totalQuizzes}',
                            accentColor: colorScheme.primary,
                          ),
                        ),
                        context.horizontalSpace(12),
                        Expanded(
                          child: QuizStatCard(
                            icon: AppIcons.star,
                            label: l10n.averageScore,
                            value: '${stats.averagePercentage.round()}%',
                            accentColor: colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    context.verticalSpace(22),
                    Text(
                      l10n.quizHistory,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    context.verticalSpace(10),
                    for (int i = 0; i < stats.attempts.length; i++) ...[
                      if (i > 0) context.verticalSpace(10),
                      QuizAttemptHistoryCard(
                        attempt: stats.attempts[i],
                        onTap: () => context.push(
                          AppRoutes.quizReviewPath(stats.attempts[i].id),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
