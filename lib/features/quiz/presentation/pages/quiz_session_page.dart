import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/ui/dialog_helper.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_question_entity.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_session_cubit.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_session_state.dart';
import 'package:idiomer/features/quiz/presentation/widgets/quiz_header.dart';
import 'package:idiomer/features/quiz/presentation/widgets/quiz_option_card.dart';
import 'package:idiomer/features/quiz/presentation/widgets/quiz_question_card.dart';
import 'package:idiomer/shared/widgets/buttons/my_button.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/dialogs/my_dialog.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';
import 'package:idiomer/shared/widgets/misc/my_progress_indicator.dart';
import 'package:idiomer/shared/widgets/texts/highlighted_markup_text.dart';

class QuizSessionPage extends StatelessWidget {
  final String? title;

  const QuizSessionPage({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return BlocBuilder<QuizSessionCubit, QuizSessionState>(
      builder: (context, state) {
        final isInProgress = state.status == QuizSessionStatus.inProgress;

        return PopScope(
          canPop: !isInProgress,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && isInProgress) {
              _confirmExit(context, l10n);
            }
          },
          child: Scaffold(
            backgroundColor: colorScheme.surface,
            body: Column(
              children: [
                QuizHeader(
                  title: title ?? l10n.dailyQuizTitle,
                  trailing: isInProgress
                      ? _Timer(remainingSeconds: state.remainingSeconds)
                      : null,
                ),
                Expanded(child: _buildBody(context, state, l10n)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    QuizSessionState state,
    AppLocalizations l10n,
  ) {
    if (state.status == QuizSessionStatus.initial ||
        state.status == QuizSessionStatus.loading) {
      return const Center(child: MyProgressIndicator());
    }

    if (state.status == QuizSessionStatus.error) {
      return Center(
        child: MyEmptyState(
          icon: AppIcons.error,
          title: l10n.loadErrorTitle,
          subtitle: l10n.loadErrorSubtitle,
          actionText: l10n.retry,
          onAction: () => context.read<QuizSessionCubit>().restartQuiz(),
        ),
      );
    }

    if (state.status == QuizSessionStatus.empty) {
      return Center(
        child: Padding(
          padding: context.insetsAllM,
          child: MyEmptyState(
            icon: AppIcons.help,
            title: l10n.noIdiomsTitle,
            subtitle: l10n.notEnoughIdiomsForQuiz,
          ),
        ),
      );
    }

    if (state.status == QuizSessionStatus.completed) {
      return _QuizResultView(state: state, l10n: l10n);
    }

    return _QuizQuestionView(state: state, l10n: l10n);
  }

  void _confirmExit(BuildContext context, AppLocalizations l10n) {
    DialogHelper.show(
      child: MyDialog(
        status: DialogStatus.warning,
        title: l10n.exitQuizTitle,
        content: l10n.exitQuizMessage,
        primaryButton: DialogButton(
          text: l10n.leave,
          onPressed: () {
            if (context.mounted) {
              context.pop();
            }
          },
        ),
        secondaryButton: DialogButton(text: l10n.stay),
      ),
    );
  }
}

class _Timer extends StatelessWidget {
  final int remainingSeconds;

  const _Timer({required this.remainingSeconds});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final extendedColors = context.extendedColors;

    final Color badgeColor;
    if (remainingSeconds <= 10) {
      badgeColor = extendedColors.danger.color;
    } else if (remainingSeconds <= 30) {
      badgeColor = extendedColors.warning.color;
    } else {
      badgeColor = colorScheme.primary;
    }

    final mins = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (remainingSeconds % 60).toString().padLeft(2, '0');

    return MyCard.filled(
      color: badgeColor.withValues(alpha: 0.12),
      borderRadius: context.brCircular,
      padding: EdgeInsets.symmetric(
        horizontal: context.spaceM,
        vertical: context.spaceXs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyIcon(icon: AppIcons.time, size: context.iconS, color: badgeColor),
          context.horizontalSpace(6),
          Text(
            '$mins:$secs',
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizQuestionView extends StatelessWidget {
  final QuizSessionState state;
  final AppLocalizations l10n;

  const _QuizQuestionView({required this.state, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final question = state.currentQuestion;
    if (question == null) return const SizedBox.shrink();

    final cubit = context.read<QuizSessionCubit>();

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.spaceM,
          context.spaceS,
          context.spaceM,
          context.spaceM,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _QuestionStepPills(
              total: state.totalQuestions,
              currentIndex: state.currentIndex,
              selectedAnswers: state.selectedAnswers,
              onSelectStep: cubit.jumpToQuestion,
            ),
            context.verticalSpace(8),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Reserve space for the 4 non-scrollable choice cards so long
                  // definitions never trigger a RenderFlex overflow on short screens.
                  final maxQuestionHeight = (constraints.maxHeight - 302.0)
                      .clamp(80.0, constraints.maxHeight);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: maxQuestionHeight,
                        ),
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: QuizQuestionCard(
                            prompt: l10n.quizQuestionPrompt,
                            englishMeaning: question.englishMeaning,
                            questionCounterLabel:
                                '${state.currentIndex + 1} / ${state.totalQuestions}',
                          ),
                        ),
                      ),
                      const Spacer(),
                      for (int i = 0; i < question.options.length; i++) ...[
                        if (i > 0) context.verticalSpace(6),
                        QuizOptionCard(
                          text: question.options[i].englishText,
                          isSelected:
                              state.currentSelectedOptionId ==
                              question.options[i].idiomId,
                          textDirection: TextDirection.ltr,
                          onTap: () =>
                              cubit.selectOption(question.options[i].idiomId),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
            context.verticalSpace(8),
            Row(
              children: [
                Expanded(
                  child: MyButton.outlinedNeutral(
                    text: l10n.previous,
                    isDisabled: !state.canGoPrevious || state.isSubmitting,
                    onPressed: cubit.previousQuestion,
                  ),
                ),
                context.horizontalSpace(10),
                Expanded(
                  child: MyButton.primary(
                    text: l10n.next,
                    isDisabled:
                        state.isSubmitting ||
                        (!state.allAnswered && !state.canGoNext),
                    onPressed: state.allAnswered
                        ? () => cubit.submitQuiz()
                        : cubit.nextQuestion,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionStepPills extends StatelessWidget {
  final int total;
  final int currentIndex;
  final Map<int, int> selectedAnswers;
  final ValueChanged<int> onSelectStep;

  const _QuestionStepPills({
    required this.total,
    required this.currentIndex,
    required this.selectedAnswers,
    required this.onSelectStep,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Row(
      children: [
        for (int i = 0; i < total; i++) ...[
          if (i > 0) context.horizontalSpace(6),
          Expanded(
            child: MyCard.filled(
              padding: EdgeInsets.symmetric(vertical: context.setSize(6)),
              borderRadius: context.brCircular,
              color: i == currentIndex
                  ? colorScheme.primary
                  : (selectedAnswers.containsKey(i)
                        ? colorScheme.primary.withValues(alpha: 0.16)
                        : colorScheme.surfaceContainer),
              onTap: () => onSelectStep(i),
              child: Center(
                child: Text(
                  '${i + 1}',
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: i == currentIndex
                        ? colorScheme.onPrimary
                        : (selectedAnswers.containsKey(i)
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _QuizResultView extends StatelessWidget {
  final QuizSessionState state;
  final AppLocalizations l10n;

  const _QuizResultView({required this.state, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final extendedColors = context.extendedColors;

    final attempt = state.savedAttempt;
    final correct = attempt?.correctAnswers ?? state.correctAnswersCount;
    final total = attempt?.totalQuestions ?? state.totalQuestions;
    final duration = attempt?.durationSeconds ?? 0;
    final pct = total > 0 ? ((correct / total) * 100).round() : 0;

    return SafeArea(
      top: false,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          context.spaceM,
          context.spaceS,
          context.spaceM,
          context.spaceM,
        ),
        children: [
          MyCard.filled(
            color: colorScheme.primaryContainer.withValues(alpha: 0.16),
            borderRadius: context.brXl,
            padding: context.insetsAllXl,
            child: Column(
              children: [
                MyIcon(
                  icon: state.timedOut ? AppIcons.time : AppIcons.checkCircle,
                  size: context.iconXxl,
                  color: state.timedOut
                      ? extendedColors.warning.color
                      : colorScheme.primary,
                ),
                context.verticalSpace(12),
                Text(
                  state.timedOut ? l10n.timeUpTitle : l10n.quizCompletedTitle,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                context.verticalSpace(8),
                Text(
                  l10n.scoreOutOf(correct, total),
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                  ),
                ),
                context.verticalSpace(4),
                Text(
                  '$pct% • ${l10n.completionTime}: ${_formatDuration(duration)}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          context.verticalSpace(16),
          Row(
            children: [
              Expanded(
                child: MyButton.outlined(
                  text: l10n.tryAgain,
                  onPressed: () =>
                      context.read<QuizSessionCubit>().restartQuiz(),
                ),
              ),
              context.horizontalSpace(10),
              Expanded(
                child: MyButton.primary(
                  text: l10n.backToOverview,
                  onPressed: () =>
                      context.pushReplacement(AppRoutes.quizOverview),
                ),
              ),
            ],
          ),
          context.verticalSpace(22),
          Text(
            l10n.reviewAnswers,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          context.verticalSpace(10),
          for (int i = 0; i < state.questions.length; i++) ...[
            if (i > 0) context.verticalSpace(10),
            _ReviewItemCard(
              question: state.questions[i],
              selectedIdiomId: state.selectedAnswers[i],
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

class _ReviewItemCard extends StatelessWidget {
  final QuizQuestionEntity question;
  final int? selectedIdiomId;
  final AppLocalizations l10n;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final Color successColor;
  final Color dangerColor;

  const _ReviewItemCard({
    required this.question,
    required this.selectedIdiomId,
    required this.l10n,
    required this.textTheme,
    required this.colorScheme,
    required this.successColor,
    required this.dangerColor,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = selectedIdiomId == question.correctIdiomId;
    final statusColor = isCorrect ? successColor : dangerColor;

    final selectedOption = question.options
        .where((o) => o.idiomId == selectedIdiomId)
        .firstOrNull;
    final correctOption = question.options
        .where((o) => o.idiomId == question.correctIdiomId)
        .firstOrNull;

    final selectedText = selectedOption?.englishText ?? l10n.unanswered;
    final correctText = correctOption?.englishText ?? question.englishText;

    return MyCard.filled(
      color: colorScheme.surfaceContainerLow,
      borderColor: statusColor.withValues(alpha: 0.35),
      borderRadius: context.brL,
      padding: context.insetsAllM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: HighlightedMarkupText(
                  question.englishMeaning,
                  textDirection: TextDirection.ltr,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              MyIcon(
                icon: isCorrect ? AppIcons.checkCircle : AppIcons.error,
                color: statusColor,
                size: context.iconM,
              ),
            ],
          ),
          context.verticalSpace(6),
          Text(
            selectedText,
            textDirection: selectedOption != null ? TextDirection.ltr : null,
            style: textTheme.bodySmall?.copyWith(color: statusColor),
          ),
          if (!isCorrect) ...[
            context.verticalSpace(4),
            Text(
              l10n.correctAnswerLabel(correctText),
              style: textTheme.bodySmall?.copyWith(
                color: successColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
