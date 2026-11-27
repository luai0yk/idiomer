import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/core/constants/app_constants.dart';
import 'package:idiomer/core/constants/app_durations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/flashcards/domain/usecases/get_group_study_cards_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/watch_flashcard_group_usecase.dart';
import 'package:idiomer/features/flashcards/presentation/widgets/flashcard_back_card.dart';
import 'package:idiomer/features/flashcards/presentation/widgets/flashcard_front_card.dart';
import 'package:idiomer/features/flashcards/presentation/widgets/flashcard_group_idioms_sheet.dart';
import 'package:idiomer/features/flashcards/presentation/widgets/flashcards_header.dart';
import 'package:idiomer/features/flashcards/presentation/widgets/flippable_flashcard.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/shared/widgets/buttons/my_button.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';
import 'package:idiomer/shared/widgets/buttons/my_popup_menu.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';
import 'package:idiomer/shared/widgets/misc/my_loading_state.dart';
import 'package:idiomer/shared/widgets/misc/my_progress_bar.dart';

enum _StudyMenuAction { showIdioms, takeQuiz }

class FlashcardStudyPage extends StatefulWidget {
  final int groupId;
  final GetGroupStudyCardsUseCase getStudyCards;
  final WatchFlashcardGroupUseCase? watchGroup;

  const FlashcardStudyPage({
    super.key,
    required this.groupId,
    required this.getStudyCards,
    this.watchGroup,
  });

  @override
  State<FlashcardStudyPage> createState() => _FlashcardStudyPageState();
}

class _FlashcardStudyPageState extends State<FlashcardStudyPage> {
  late final PageController _pageController;
  StreamSubscription<FlashcardGroupEntity?>? _groupSub;
  String? _groupName;
  List<IdiomDetailEntity> _cards = const [];
  bool _isLoading = true;
  bool _hasError = false;
  int _currentIndex = 0;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _groupSub = widget.watchGroup?.call(widget.groupId).listen((group) {
      if (!mounted || group == null) return;
      if (_groupName != group.name) {
        setState(() => _groupName = group.name);
      }
    });
    _loadCards();
  }

  @override
  void dispose() {
    _groupSub?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadCards() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final cards = await widget.getStudyCards(widget.groupId);
      if (!mounted) return;
      setState(() {
        _cards = cards;
        _currentIndex = 0;
        _isFlipped = false;
        _isLoading = false;
      });
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _shuffleCards() {
    if (_cards.length < 2) return;
    final shuffled = List<IdiomDetailEntity>.from(_cards)..shuffle();
    setState(() {
      _cards = shuffled;
      _currentIndex = 0;
      _isFlipped = false;
    });
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  void _goTo(int index) {
    if (index < 0 || index >= _cards.length) return;
    final jumpDistance = (index - _currentIndex).abs();
    setState(() {
      _currentIndex = index;
      _isFlipped = false;
    });
    if (!_pageController.hasClients) return;
    if (jumpDistance > 1) {
      _pageController.jumpToPage(index);
    } else {
      _pageController.animateToPage(
        index,
        duration: AppDurations.medium,
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _showIdiomsSheet(AppLocalizations l10n) {
    if (_cards.isEmpty) return;
    FlashcardGroupIdiomsSheet.show(
      context: context,
      title: _groupName ?? l10n.idioms,
      cards: _cards,
      currentIndex: _currentIndex,
      onSelectCard: _goTo,
    );
  }

  void _startGroupQuiz() {
    if (_cards.length < AppConstants.quizQuestionCount) return;
    context.push(
      AppRoutes.groupQuizSessionPath(widget.groupId, groupName: _groupName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final canTakeQuiz = _cards.length >= AppConstants.quizQuestionCount;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          FlashcardsHeader(
            title: _groupName ?? l10n.studyFlashcards,
            withLeading: true,
            trailing: _cards.isEmpty
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_cards.length > 1)
                        MyIconButton.ghost(
                          icon: AppIcons.shuffle,
                          iconColor: colorScheme.primary,
                          tooltip: l10n.shuffle,
                          onPressed: _shuffleCards,
                        ),
                      MyPopupMenu<_StudyMenuAction>(
                        iconColor: colorScheme.primary,
                        items: [
                          MyPopupMenuItem(
                            value: _StudyMenuAction.showIdioms,
                            label: l10n.showIdiomsList,
                            icon: AppIcons.idioms,
                          ),
                          MyPopupMenuItem(
                            value: _StudyMenuAction.takeQuiz,
                            label: l10n.takeQuiz,
                            icon: AppIcons.help,
                            enabled: canTakeQuiz,
                          ),
                        ],
                        onSelected: (action) {
                          switch (action) {
                            case _StudyMenuAction.showIdioms:
                              _showIdiomsSheet(l10n);
                            case _StudyMenuAction.takeQuiz:
                              _startGroupQuiz();
                          }
                        },
                      ),
                    ],
                  ),
          ),
          Expanded(child: _buildBody(context, l10n)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    if (_isLoading) {
      return Center(child: MyLoadingState(label: l10n.loadingFlashcards));
    }

    if (_hasError) {
      return Center(
        child: MyEmptyState(
          icon: AppIcons.error,
          title: l10n.loadErrorTitle,
          subtitle: l10n.loadErrorSubtitle,
          actionText: l10n.retry,
          onAction: _loadCards,
        ),
      );
    }

    if (_cards.isEmpty) {
      return Center(
        child: MyEmptyState(
          icon: AppIcons.flashcards,
          title: l10n.noGroupIdiomsTitle,
          subtitle: l10n.noGroupIdiomsSubtitle,
        ),
      );
    }

    final progress = (_currentIndex + 1) / _cards.length;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(top: context.spaceS, bottom: context.spaceM),
        child: Column(
          children: [
            Padding(
              padding: context.insetsHorizontalM,
              child: MyProgressBar(
                value: progress,
                label: l10n.questionProgress(_currentIndex + 1, _cards.length),
                showPercentage: true,
              ),
            ),
            context.verticalSpace(8),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                pageSnapping: true,
                clipBehavior: Clip.none,
                itemCount: _cards.length,
                onPageChanged: (index) {
                  if (_currentIndex != index || _isFlipped) {
                    setState(() {
                      _currentIndex = index;
                      _isFlipped = false;
                    });
                  }
                },
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.spaceM,
                      vertical: context.spaceS,
                    ),
                    child: FlippableFlashcard(
                      cardId: card.id,
                      isFlipped: index == _currentIndex && _isFlipped,
                      onTap: () {
                        if (index == _currentIndex) {
                          setState(() => _isFlipped = !_isFlipped);
                        }
                      },
                      front: FlashcardFrontCard(card: card),
                      back: FlashcardBackCard(card: card),
                    ),
                  );
                },
              ),
            ),
            context.verticalSpace(8),
            Padding(
              padding: context.insetsHorizontalM,
              child: Row(
                children: [
                  Expanded(
                    child: MyButton.outlinedNeutral(
                      text: l10n.previous,
                      isDisabled: _currentIndex == 0,
                      onPressed: () => _goTo(_currentIndex - 1),
                    ),
                  ),
                  context.horizontalSpace(10),
                  Expanded(
                    child: MyButton.primary(
                      text: l10n.next,
                      isDisabled: _currentIndex >= _cards.length - 1,
                      onPressed: () => _goTo(_currentIndex + 1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
