import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/core/constants/app_durations.dart';
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
import 'package:idiomer/shared/widgets/animations/my_animated_scale_fade_switcher.dart';
import 'package:idiomer/shared/widgets/buttons/my_button.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/dialogs/my_dialog.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';
import 'package:idiomer/shared/widgets/misc/my_loading_state.dart';
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
      return Center(child: MyLoadingState(label: l10n.preparingQuiz));
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

class _QuizQuestionView extends StatefulWidget {
  final QuizSessionState state;
  final AppLocalizations l10n;

  const _QuizQuestionView({required this.state, required this.l10n});

  @override
  State<_QuizQuestionView> createState() => _QuizQuestionViewState();
}

class _QuizQuestionViewState extends State<_QuizQuestionView> {
  late final PageController _pageController;
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.state.currentIndex);
  }

  @override
  void didUpdateWidget(covariant _QuizQuestionView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldIndex = oldWidget.state.currentIndex;
    final newIndex = widget.state.currentIndex;
    if (oldIndex != newIndex && _pageController.hasClients) {
      final currentPage = _pageController.page?.round();
      if (currentPage != newIndex) {
        final jumpDistance = (newIndex - oldIndex).abs();
        if (jumpDistance > 1) {
          _pageController.jumpToPage(newIndex);
        } else {
          _pageController.animateToPage(
            newIndex,
            duration: AppDurations.medium,
            curve: Curves.easeOutCubic,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _cancelAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;
  }

  void _goToQuestion(QuizSessionCubit cubit, int index) {
    _cancelAutoAdvance();
    cubit.jumpToQuestion(index);
  }

  void _handleOptionTap({
    required QuizSessionCubit cubit,
    required int questionIndex,
    required int optionIdiomId,
  }) {
    if (widget.state.isSubmitting) return;
    _cancelAutoAdvance();
    cubit.selectOption(optionIdiomId, questionIndex: questionIndex);

    // Pause briefly so the user sees the option selection animation before sliding.
    if (questionIndex < widget.state.totalQuestions - 1) {
      _autoAdvanceTimer = Timer(AppDurations.fast, () {
        if (!mounted) return;
        final latest = cubit.state;
        if (latest.status == QuizSessionStatus.inProgress &&
            !latest.isSubmitting &&
            latest.currentIndex == questionIndex &&
            questionIndex + 1 < latest.totalQuestions) {
          cubit.jumpToQuestion(questionIndex + 1);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final l10n = widget.l10n;
    if (state.questions.isEmpty) return const SizedBox.shrink();

    final cubit = context.read<QuizSessionCubit>();
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(top: context.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: context.insetsHorizontalM,
              child: _QuestionStepPills(
                total: state.totalQuestions,
                currentIndex: state.currentIndex,
                selectedAnswers: state.selectedAnswers,
                onSelectStep: (index) => _goToQuestion(cubit, index),
              ),
            ),
            context.verticalSpace(20),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                pageSnapping: true,
                clipBehavior: Clip.none,
                itemCount: state.totalQuestions,
                onPageChanged: (index) {
                  _cancelAutoAdvance();
                  if (cubit.state.currentIndex != index) {
                    cubit.jumpToQuestion(index);
                  }
                },
                itemBuilder: (context, index) {
                  final question = state.questions[index];
                  return _QuestionSlide(
                    question: question,
                    questionNumber: index + 1,
                    totalQuestions: state.totalQuestions,
                    selectedOptionId: state.selectedAnswers[index],
                    canGoPrevious: index > 0,
                    canGoNext: index < state.totalQuestions - 1,
                    isSubmitting: state.isSubmitting,
                    bottomSpacing: state.allAnswered
                        ? context.spaceM
                        : context.spaceXxl,
                    l10n: l10n,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    onPrevious: () => _goToQuestion(cubit, index - 1),
                    onNext: () => _goToQuestion(cubit, index + 1),
                    onSelectOption: (optionId) => _handleOptionTap(
                      cubit: cubit,
                      questionIndex: index,
                      optionIdiomId: optionId,
                    ),
                  );
                },
              ),
            ),
            MyAnimatedScaleFadeSwitcher(
              duration: AppDurations.fast,
              child: state.allAnswered
                  ? Padding(
                      key: const ValueKey('submit_quiz_wrapper'),
                      padding: EdgeInsets.fromLTRB(
                        context.spaceM,
                        context.spaceS,
                        context.spaceM,
                        context.spaceM,
                      ),
                      child: MyButton.primary(
                        text: l10n.submitQuiz,
                        isDisabled: state.isSubmitting,
                        onPressed: () {
                          _cancelAutoAdvance();
                          cubit.submitQuiz();
                        },
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('no_submit_quiz')),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionSlide extends StatelessWidget {
  final QuizQuestionEntity question;
  final int questionNumber;
  final int totalQuestions;
  final int? selectedOptionId;
  final bool canGoPrevious;
  final bool canGoNext;
  final bool isSubmitting;
  final double bottomSpacing;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<int> onSelectOption;

  const _QuestionSlide({
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    required this.selectedOptionId,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.isSubmitting,
    required this.bottomSpacing,
    required this.l10n,
    required this.colorScheme,
    required this.textTheme,
    required this.onPrevious,
    required this.onNext,
    required this.onSelectOption,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            context.spaceM,
            0,
            context.spaceM,
            bottomSpacing,
          ),
          sliver: SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                QuizQuestionCard(
                  prompt: l10n.quizQuestionPrompt,
                  englishMeaning: question.englishMeaning,
                ),
                const Spacer(),
                context.verticalSpace(16),
                _QuestionNavRow(
                  questionNumber: questionNumber,
                  totalQuestions: totalQuestions,
                  canGoPrevious: canGoPrevious,
                  canGoNext: canGoNext,
                  isSubmitting: isSubmitting,
                  l10n: l10n,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  onPrevious: onPrevious,
                  onNext: onNext,
                ),
                context.verticalSpace(12),
                for (int i = 0; i < question.options.length; i++) ...[
                  if (i > 0) context.verticalSpace(10),
                  QuizOptionCard(
                    text: question.options[i].englishText,
                    isSelected: selectedOptionId == question.options[i].idiomId,
                    textDirection: TextDirection.ltr,
                    onTap: () => onSelectOption(question.options[i].idiomId),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestionNavRow extends StatelessWidget {
  final int questionNumber;
  final int totalQuestions;
  final bool canGoPrevious;
  final bool canGoNext;
  final bool isSubmitting;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _QuestionNavRow({
    required this.questionNumber,
    required this.totalQuestions,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.isSubmitting,
    required this.l10n,
    required this.colorScheme,
    required this.textTheme,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = context.setSize(36);
    final iconSize = context.iconM;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyIconButton.ghost(
            icon: AppIcons.arrowBack(context),
            tooltip: l10n.previous,
            buttonSize: buttonSize,
            iconSize: iconSize,
            iconColor: colorScheme.primary,
            disabled: !canGoPrevious || isSubmitting,
            onPressed: onPrevious,
          ),
          context.horizontalSpace(4),
          Text(
            l10n.questionProgress(questionNumber, totalQuestions),
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          context.horizontalSpace(4),
          MyIconButton.ghost(
            icon: AppIcons.arrowForward(context),
            tooltip: l10n.next,
            buttonSize: buttonSize,
            iconSize: iconSize,
            iconColor: colorScheme.primary,
            disabled: !canGoNext || isSubmitting,
            onPressed: onNext,
          ),
        ],
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
              padding: EdgeInsets.symmetric(vertical: context.spaceS),
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
