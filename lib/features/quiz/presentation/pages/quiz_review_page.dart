import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/formatters/date_time_formatter.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_attempt_review_entity.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_review_cubit.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_review_state.dart';
import 'package:idiomer/features/quiz/presentation/widgets/quiz_header.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';
import 'package:idiomer/shared/widgets/misc/my_loading_state.dart';
import 'package:idiomer/shared/widgets/texts/highlighted_markup_text.dart';

/// Read-only review screen for a previously completed quiz attempt.
class QuizReviewPage extends StatefulWidget {
  final int attemptId;

  const QuizReviewPage({super.key, required this.attemptId});

  @override
  State<QuizReviewPage> createState() => _QuizReviewPageState();
}

class _QuizReviewPageState extends State<QuizReviewPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<QuizReviewCubit>().loadReview(widget.attemptId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          QuizHeader(title: l10n.reviewAnswers),
          Expanded(
            child: BlocBuilder<QuizReviewCubit, QuizReviewState>(
              builder: (context, state) {
                if (state.status == QuizReviewStatus.initial ||
                    state.status == QuizReviewStatus.loading) {
                  return Center(
                    child: MyLoadingState(label: l10n.loadingQuizReview),
                  );
                }

                if (state.status == QuizReviewStatus.error) {
                  return Center(
                    child: MyEmptyState(
                      icon: AppIcons.error,
                      title: l10n.loadErrorTitle,
                      subtitle: l10n.loadErrorSubtitle,
                      actionText: l10n.retry,
                      onAction: () => context.read<QuizReviewCubit>().retry(),
                    ),
                  );
                }

                final review = state.review;
                if (state.status == QuizReviewStatus.notFound ||
                    review == null) {
                  return Center(
                    child: MyEmptyState(
                      icon: AppIcons.help,
                      title: l10n.reviewQuizNotFound,
                      subtitle: l10n.noDataSubtitle,
                    ),
                  );
                }

                return _buildReviewContent(context, review, l10n);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewContent(
    BuildContext context,
    QuizAttemptReviewEntity review,
    AppLocalizations l10n,
  ) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final extendedColors = context.extendedColors;

    final attempt = review.attempt;
    final pct = attempt.percentage.round();

    return SafeArea(
      top: false,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          context.spaceM,
          context.spaceS,
          context.spaceM,
          context.spaceXl,
        ),
      children: [
        MyCard.filled(
          color: colorScheme.primaryContainer.withValues(alpha: 0.16),
          borderRadius: context.brXl,
          padding: context.insetsAllL,
          child: Column(
            children: [
              MyCard.filled(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: context.brCircular,
                padding: EdgeInsets.symmetric(
                  horizontal: context.spaceM,
                  vertical: context.spaceXs,
                ),
                child: Text(
                  l10n.readOnlyReview,
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              context.verticalSpace(12),
              Text(
                l10n.scoreOutOf(attempt.correctAnswers, attempt.totalQuestions),
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
              context.verticalSpace(4),
              Text(
                '$pct% • ${_formatDuration(attempt.durationSeconds)}',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              context.verticalSpace(4),
              Text(
                DateTimeFormatter.formatDateTime(attempt.completedAt),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        context.verticalSpace(18),
        if (review.items.isEmpty)
          MyEmptyState(
            icon: AppIcons.help,
            title: l10n.noData,
            subtitle: l10n.noDataSubtitle,
            size: MyEmptyStateSize.small,
          )
        else
          for (int i = 0; i < review.items.length; i++) ...[
            if (i > 0) context.verticalSpace(12),
            _ReadOnlyQuestionCard(
              index: i + 1,
              total: review.items.length,
              item: review.items[i],
              l10n: l10n,
              textTheme: textTheme,
              colorScheme: colorScheme,
              successColor: extendedColors.success.color,
              dangerColor: extendedColors.danger.color,
            ),
          ],
        ],
      ),
    );
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}

class _ReadOnlyQuestionCard extends StatelessWidget {
  final int index;
  final int total;
  final QuizReviewItemEntity item;
  final AppLocalizations l10n;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final Color successColor;
  final Color dangerColor;

  const _ReadOnlyQuestionCard({
    required this.index,
    required this.total,
    required this.item,
    required this.l10n,
    required this.textTheme,
    required this.colorScheme,
    required this.successColor,
    required this.dangerColor,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = item.isCorrect;
    final statusColor = isCorrect ? successColor : dangerColor;
    final question = item.question;

    return MyCard.bordered(
      color: colorScheme.surfaceContainerLow,
      borderColor: statusColor.withValues(alpha: 0.35),
      borderRadius: context.brL,
      padding: context.insetsAllL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                l10n.questionProgress(index, total),
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (item.isUnanswered) ...[
                Text(
                  l10n.unanswered,
                  style: textTheme.labelSmall?.copyWith(
                    color: dangerColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                context.horizontalSpace(6),
              ],
              MyIcon(
                icon: isCorrect ? AppIcons.checkCircle : AppIcons.error,
                color: statusColor,
                size: context.iconM,
              ),
            ],
          ),
          context.verticalSpace(8),
          HighlightedMarkupText(
            question.englishMeaning,
            textDirection: TextDirection.ltr,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              height: 1.35,
            ),
          ),
          context.verticalSpace(12),
          for (int i = 0; i < question.options.length; i++) ...[
            if (i > 0) context.verticalSpace(8),
            _buildOptionRow(
              context,
              question.options[i].idiomId,
              question.options[i].englishText,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionRow(BuildContext context, int optionIdiomId, String text) {
    final isCorrectOption = optionIdiomId == item.question.correctIdiomId;
    final isSelectedOption = optionIdiomId == item.selectedIdiomId;

    Color bgColor = colorScheme.surface;
    Color borderColor = colorScheme.outlineVariant.withValues(alpha: 0.45);
    Color textColor = colorScheme.onSurface;
    IconData? trailingIcon;

    if (isCorrectOption) {
      bgColor = successColor.withValues(alpha: 0.12);
      borderColor = successColor;
      textColor = successColor;
      trailingIcon = AppIcons.checkCircle;
    } else if (isSelectedOption) {
      bgColor = dangerColor.withValues(alpha: 0.12);
      borderColor = dangerColor;
      textColor = dangerColor;
      trailingIcon = AppIcons.error;
    }

    // Read-only card: intentionally provides no onTap so taken answers cannot be edited.
    return MyCard.bordered(
      color: bgColor,
      borderColor: borderColor,
      borderRadius: context.brM,
      padding: context.insetsAllM,
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              textDirection: TextDirection.ltr,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: (isCorrectOption || isSelectedOption)
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
          if (trailingIcon != null) ...[
            context.horizontalSpace(8),
            MyIcon(icon: trailingIcon, color: textColor, size: context.iconS),
          ],
        ],
      ),
    );
  }
}
