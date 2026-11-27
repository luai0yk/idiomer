import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_overview_cubit.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_overview_state.dart';
import 'package:idiomer/features/quiz/presentation/widgets/quiz_attempt_history_card.dart';
import 'package:idiomer/features/quiz/presentation/widgets/quiz_header.dart';
import 'package:idiomer/features/quiz/presentation/widgets/quiz_stat_card.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';
import 'package:idiomer/shared/widgets/misc/my_loading_state.dart';

class QuizOverviewPage extends StatelessWidget {
  const QuizOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          QuizHeader(title: l10n.quizOverview),
          Expanded(
            child: BlocBuilder<QuizOverviewCubit, QuizOverviewState>(
              builder: (context, state) {
                if (state.status == QuizOverviewStatus.initial ||
                    state.status == QuizOverviewStatus.loading) {
                  return Center(
                    child: MyLoadingState(label: l10n.loadingQuizOverview),
                  );
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
                    context.spaceXl,
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
                    context.verticalSpace(12),
                    _StartQuizCard(
                      title: l10n.newQuiz,
                      subtitle: l10n.quizFirstTimeSubtitle,
                      onTap: () => context.push(AppRoutes.quizSession),
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

class _StartQuizCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _StartQuizCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final primary = colorScheme.primary;
    final baseSurface = colorScheme.surfaceContainerLow;

    return MyCard.bordered(
      color: Color.alphaBlend(primary.withValues(alpha: 0.08), baseSurface),
      borderColor: primary.withValues(alpha: 0.22),
      borderRadius: context.brXl,
      padding: EdgeInsets.symmetric(
        horizontal: context.spaceL,
        vertical: context.spaceM,
      ),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: context.setSize(38),
            height: context.setSize(38),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.14),
              borderRadius: context.brL * 0.92,
            ),
            child: Center(
              child: MyIcon(
                icon: AppIcons.help,
                color: primary,
                size: context.iconM,
              ),
            ),
          ),
          context.horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                context.verticalSpace(2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          context.horizontalSpace(8),
          MyIcon(
            icon: AppIcons.arrowForward(context),
            color: primary,
            size: context.iconM,
          ),
        ],
      ),
    );
  }
}
