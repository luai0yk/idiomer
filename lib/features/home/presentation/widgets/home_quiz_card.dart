import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_stats_entity.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';

class HomeQuizCard extends StatelessWidget {
  final QuizStatsEntity stats;
  final VoidCallback onTap;

  const HomeQuizCard({super.key, required this.stats, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    final hasCompleted = stats.hasCompletedQuiz;
    final subtitle = hasCompleted
        ? l10n.quizOverviewSubtitle(
            stats.totalQuizzes,
            stats.averagePercentage.round(),
          )
        : l10n.quizFirstTimeSubtitle;

    final primary = colorScheme.primary;
    final baseSurface = colorScheme.surfaceContainerLow;

    return MyCard.bordered(
      color: Color.alphaBlend(primary.withValues(alpha: 0.08), baseSurface),
      borderColor: primary.withValues(alpha: 0.22),
      borderRadius: context.brXl,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Stack(
        children: [
          PositionedDirectional(
            end: -context.setSize(10),
            top: -context.setSize(16),
            child: Transform.rotate(
              angle: -0.18,
              child: MyIcon(
                icon: AppIcons.help,
                size: context.setSize(120),
                color: primary.withValues(alpha: 0.11),
              ),
            ),
          ),
          Padding(
            padding: context.insetsAllL,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dailyQuizTitle,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                context.verticalSpace(6),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                context.verticalSpace(16),
                MyCard.filled(
                  color: primary,
                  borderRadius: context.brCircular,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spaceM,
                    vertical: context.spaceS,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        hasCompleted ? l10n.viewProgress : l10n.startQuiz,
                        style: textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      context.horizontalSpace(6),
                      MyIcon(
                        icon: AppIcons.arrowForward(context),
                        color: colorScheme.onPrimary,
                        size: context.iconS,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
