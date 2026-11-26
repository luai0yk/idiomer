import 'package:flutter/material.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/formatters/date_time_formatter.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_attempt_entity.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';

class QuizAttemptHistoryCard extends StatelessWidget {
  final QuizAttemptEntity attempt;
  final VoidCallback onTap;

  const QuizAttemptHistoryCard({
    super.key,
    required this.attempt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final extendedColors = context.extendedColors;

    final pct = attempt.percentage.round();
    final badgeColor = pct >= 70
        ? extendedColors.success.color
        : (pct >= 40
              ? extendedColors.warning.color
              : extendedColors.danger.color);

    final durationText = _formatDurationText(attempt.durationSeconds, l10n);
    final subtitle = l10n.quizAttemptSubtitle(
      attempt.correctAnswers,
      attempt.totalQuestions,
      durationText,
    );

    return MyCard.filled(
      borderRadius: context.brXl,
      padding: context.insetsAllL,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateTimeFormatter.formatDateTime(attempt.completedAt),
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                context.verticalSpace(4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          context.horizontalSpace(8),
          Text(
            '$pct%',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDurationText(int totalSeconds, AppLocalizations l10n) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    if (minutes == 0) {
      return l10n.secondsCount(seconds);
    }
    if (seconds == 0) {
      return l10n.minutesCount(minutes);
    }
    return '${l10n.minutesCount(minutes)} ${l10n.secondsCount(seconds)}';
  }
}
