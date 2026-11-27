import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/app/di/injection.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/services/tts/tts_service.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/settings_helper.dart';
import 'package:idiomer/core/utils/helpers/ui/snackbar_helper.dart';
import 'package:idiomer/core/utils/helpers/ui/toast_helper.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/flashcards/presentation/widgets/flashcard_group_picker_sheet.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/presentation/cubit/idiom_detail_cubit.dart';
import 'package:idiomer/features/idioms/presentation/cubit/idiom_detail_state.dart';
import 'package:idiomer/features/idioms/presentation/widgets/idiom_detail_header.dart';
import 'package:idiomer/features/idioms/presentation/widgets/idiom_detail_hero_card.dart';
import 'package:idiomer/features/idioms/presentation/widgets/idiom_share_sheet.dart';
import 'package:idiomer/shared/widgets/appbars/my_gradient_header.dart';
import 'package:idiomer/shared/widgets/buttons/my_favorite_button.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';
import 'package:idiomer/shared/widgets/misc/my_loading_state.dart';
import 'package:idiomer/shared/widgets/misc/my_snackbar.dart';
import 'package:idiomer/shared/widgets/misc/my_toast.dart';
import 'package:idiomer/shared/widgets/texts/highlighted_markup_text.dart';

class IdiomDetailPage extends StatefulWidget {
  final int idiomId;

  const IdiomDetailPage({super.key, required this.idiomId});

  @override
  State<IdiomDetailPage> createState() => _IdiomDetailPageState();
}

class _IdiomDetailPageState extends State<IdiomDetailPage> {
  TtsService? _ttsService;

  @override
  void initState() {
    super.initState();
    _ttsService = sl.isRegistered<TtsService>() ? sl<TtsService>() : null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<IdiomDetailCubit>().watchIdiom(widget.idiomId);
      }
    });
  }

  @override
  void dispose() {
    final tts = _ttsService;
    if (tts != null && tts.activeUtteranceId.value != null) {
      Future.microtask(tts.stop);
    }
    super.dispose();
  }

  Future<void> _speakText(String text, {required String utteranceId}) async {
    final tts = _ttsService;
    if (tts == null) return;
    final config = SettingsHelper.readTtsConfig(context);
    await tts.speak(
      text,
      utteranceId: utteranceId,
      accent: config.accent,
      speechRate: config.speechRate,
      voiceName: config.voiceName,
      voiceLocale: config.voiceLocale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return BlocBuilder<IdiomDetailCubit, IdiomDetailState>(
      builder: (context, state) {
        final idiom = state.idiom;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: ScrollUnderHeaderColumn(
            headerBuilder: (context, showBottomBorder) => IdiomDetailHeader(
              title: l10n.idiomDetails,
              showBottomBorder: showBottomBorder,
              actions: idiom == null
                  ? const []
                  : [
                      MyFavoriteButton(
                        initialIsFavorite: idiom.isFavorite,
                        iconColor: colorScheme.primary,
                        onChanged: (_) =>
                            context.read<IdiomDetailCubit>().toggleFavorite(),
                      ),
                      MyIconButton.ghost(
                        icon: state.isInFlashcards
                            ? AppIcons.flashcardsFilled
                            : AppIcons.flashcards,
                        iconColor: colorScheme.primary,
                        tooltip: l10n.addToFlashcards,
                        autoLoading: false,
                        onPressed: () => _handleFlashcardAction(
                          context,
                          state,
                          idiom,
                          l10n,
                        ),
                      ),
                      MyIconButton.ghost(
                        icon: AppIcons.share,
                        autoLoading: false,
                        iconColor: colorScheme.primary,
                        tooltip: l10n.share,
                        onPressed: () => IdiomShareSheet.show(
                          context: context,
                          idiom: idiom,
                        ),
                      ),
                    ],
            ),
            body: _buildBody(context, state, l10n),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    IdiomDetailState state,
    AppLocalizations l10n,
  ) {
    if (state.status == IdiomDetailStatus.initial ||
        state.status == IdiomDetailStatus.loading) {
      return Center(child: MyLoadingState(label: l10n.loadingIdiomDetails));
    }

    if (state.status == IdiomDetailStatus.error) {
      return Center(
        child: MyEmptyState(
          icon: AppIcons.error,
          title: l10n.loadErrorTitle,
          subtitle: l10n.loadErrorSubtitle,
          actionText: l10n.retry,
          onAction: () => context.read<IdiomDetailCubit>().retry(),
        ),
      );
    }

    final idiom = state.idiom;
    if (state.status == IdiomDetailStatus.notFound || idiom == null) {
      return Center(
        child: MyEmptyState(
          icon: AppIcons.idioms,
          title: l10n.idiomNotFoundTitle,
          subtitle: l10n.idiomNotFoundSubtitle,
        ),
      );
    }

    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final showTranslation = SettingsHelper.watchShowTranslation(context);

    Widget buildContent(String? activeUtteranceId) {
      final heroUtteranceId = 'idiom_${idiom.id}';
      return SelectionArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            context.spaceM,
            context.spaceM,
            context.spaceM,
            context.spaceXxl,
          ),
          children: [
            IdiomDetailHeroCard(
              idiom: idiom,
              isSpeaking: activeUtteranceId == heroUtteranceId,
              onSpeak: _ttsService == null
                  ? null
                  : () => _speakText(
                      idiom.englishText,
                      utteranceId: heroUtteranceId,
                    ),
              onCopy: () => _copyText(
                showTranslation && idiom.arabicText.trim().isNotEmpty
                    ? '${idiom.englishText}\n${idiom.arabicText}'
                    : idiom.englishText,
                l10n.copiedToClipboard,
              ),
            ),
            if (idiom.definitions.isNotEmpty) ...[
              context.verticalSpace(20),
              _buildSectionTitle(
                context,
                idiom.definitions.length > 1
                    ? l10n.meaningsLabel
                    : l10n.meaningLabel,
                AppIcons.info,
                textTheme,
                colorScheme,
              ),
              context.verticalSpace(8),
              ..._buildDefinitions(
                context,
                idiom,
                textTheme,
                colorScheme,
                l10n,
                showTranslation: showTranslation,
                activeUtteranceId: activeUtteranceId,
              ),
            ],
            if (idiom.examples.isNotEmpty) ...[
              context.verticalSpace(20),
              _buildSectionTitle(
                context,
                idiom.examples.length > 1
                    ? l10n.examplesLabel
                    : l10n.exampleLabel,
                AppIcons.text,
                textTheme,
                colorScheme,
              ),
              context.verticalSpace(8),
              ..._buildExamples(
                context,
                idiom,
                textTheme,
                colorScheme,
                l10n,
                showTranslation: showTranslation,
                activeUtteranceId: activeUtteranceId,
              ),
            ],
            if (_hasNotes(idiom, showTranslation: showTranslation)) ...[
              context.verticalSpace(20),
              _buildSectionTitle(
                context,
                l10n.notesLabel,
                AppIcons.notes,
                textTheme,
                colorScheme,
              ),
              context.verticalSpace(8),
              _buildNotesCard(
                context,
                idiom,
                textTheme,
                colorScheme,
                showTranslation: showTranslation,
              ),
            ],
          ],
        ),
      );
    }

    if (_ttsService == null) {
      return buildContent(null);
    }

    return ValueListenableBuilder<String?>(
      valueListenable: _ttsService!.activeUtteranceId,
      builder: (context, activeId, _) => buildContent(activeId),
    );
  }

  List<Widget> _buildDefinitions(
    BuildContext context,
    IdiomDetailEntity idiom,
    TextTheme textTheme,
    ColorScheme colorScheme,
    AppLocalizations l10n, {
    required bool showTranslation,
    required String? activeUtteranceId,
  }) {
    return [
      for (int i = 0; i < idiom.definitions.length; i++) ...[
        if (i > 0) context.verticalSpace(8),
        _buildDefinitionCard(
          context,
          idiom.definitions[i],
          showIndex: idiom.definitions.length > 1,
          index: i + 1,
          textTheme: textTheme,
          colorScheme: colorScheme,
          l10n: l10n,
          showTranslation: showTranslation,
          activeUtteranceId: activeUtteranceId,
        ),
      ],
    ];
  }

  Widget _buildDefinitionCard(
    BuildContext context,
    IdiomDefinitionEntity definition, {
    required bool showIndex,
    required int index,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
    required AppLocalizations l10n,
    required bool showTranslation,
    required String? activeUtteranceId,
  }) {
    final hasArabicMeaning =
        showTranslation && definition.arabicMeaning.trim().isNotEmpty;
    final utteranceId = 'def_${definition.id}';
    final isSpeaking = activeUtteranceId == utteranceId;

    return MyCard.filled(
      borderRadius: context.brXl,
      padding: context.insetsAllM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: HighlightedMarkupText(
                  showIndex
                      ? '$index. ${definition.englishMeaning}'
                      : definition.englishMeaning,
                  textDirection: TextDirection.ltr,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              if (_ttsService != null)
                MyIconButton.ghost(
                  icon: isSpeaking ? AppIcons.stop : AppIcons.volume,
                  iconSize: context.iconS,
                  iconColor: isSpeaking
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  tooltip: isSpeaking ? l10n.stopSpeaking : l10n.listen,
                  autoLoading: false,
                  onPressed: () => _speakText(
                    definition.englishMeaning,
                    utteranceId: utteranceId,
                  ),
                ),
              MyIconButton.ghost(
                icon: AppIcons.copy,
                iconSize: context.iconS,
                tooltip: l10n.copy,
                onPressed: () => _copyText(
                  HighlightedMarkupText.stripMarkers(
                    hasArabicMeaning
                        ? '${definition.englishMeaning}\n${definition.arabicMeaning}'
                        : definition.englishMeaning,
                  ),
                  l10n.copiedToClipboard,
                ),
              ),
            ],
          ),
          if (hasArabicMeaning) ...[
            context.verticalSpace(8),
            HighlightedMarkupText(
              definition.arabicMeaning,
              textDirection: TextDirection.rtl,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildExamples(
    BuildContext context,
    IdiomDetailEntity idiom,
    TextTheme textTheme,
    ColorScheme colorScheme,
    AppLocalizations l10n, {
    required bool showTranslation,
    required String? activeUtteranceId,
  }) {
    return [
      for (int i = 0; i < idiom.examples.length; i++) ...[
        if (i > 0) context.verticalSpace(8),
        _buildExampleCard(
          context,
          idiom.examples[i],
          showIndex: idiom.examples.length > 1,
          index: i + 1,
          textTheme: textTheme,
          colorScheme: colorScheme,
          l10n: l10n,
          showTranslation: showTranslation,
          activeUtteranceId: activeUtteranceId,
        ),
      ],
    ];
  }

  Widget _buildExampleCard(
    BuildContext context,
    IdiomExampleEntity example, {
    required bool showIndex,
    required int index,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
    required AppLocalizations l10n,
    required bool showTranslation,
    required String? activeUtteranceId,
  }) {
    final hasArabicSentence =
        showTranslation && example.arabicSentence.trim().isNotEmpty;
    final utteranceId = 'ex_${example.id}';
    final isSpeaking = activeUtteranceId == utteranceId;

    return MyCard.filled(
      borderRadius: context.brXl,
      padding: context.insetsAllM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: HighlightedMarkupText(
                  showIndex
                      ? '$index. ${example.englishSentence}'
                      : example.englishSentence,
                  textDirection: TextDirection.ltr,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              if (_ttsService != null)
                MyIconButton.ghost(
                  icon: isSpeaking ? AppIcons.stop : AppIcons.volume,
                  iconSize: context.iconS,
                  iconColor: isSpeaking
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  tooltip: isSpeaking ? l10n.stopSpeaking : l10n.listen,
                  autoLoading: false,
                  onPressed: () => _speakText(
                    example.englishSentence,
                    utteranceId: utteranceId,
                  ),
                ),
              MyIconButton.ghost(
                icon: AppIcons.copy,
                iconSize: context.iconS,
                tooltip: l10n.copy,
                onPressed: () => _copyText(
                  HighlightedMarkupText.stripMarkers(
                    hasArabicSentence
                        ? '${example.englishSentence}\n${example.arabicSentence}'
                        : example.englishSentence,
                  ),
                  l10n.copiedToClipboard,
                ),
              ),
            ],
          ),
          if (hasArabicSentence) ...[
            context.verticalSpace(8),
            HighlightedMarkupText(
              example.arabicSentence,
              textDirection: TextDirection.rtl,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotesCard(
    BuildContext context,
    IdiomDetailEntity idiom,
    TextTheme textTheme,
    ColorScheme colorScheme, {
    required bool showTranslation,
  }) {
    final hasEn =
        idiom.englishNotes != null && idiom.englishNotes!.trim().isNotEmpty;
    final hasAr =
        showTranslation &&
        idiom.arabicNotes != null &&
        idiom.arabicNotes!.trim().isNotEmpty;

    return MyCard.filled(
      borderRadius: context.brXl,
      padding: context.insetsAllM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasEn)
            Text(
              idiom.englishNotes!,
              textDirection: TextDirection.ltr,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          if (hasEn && hasAr) context.verticalSpace(8),
          if (hasAr)
            Text(
              idiom.arabicNotes!,
              textDirection: TextDirection.rtl,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    IconData icon,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        MyIcon(icon: icon, size: context.iconM, color: colorScheme.primary),
        context.horizontalSpace(8),
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  bool _hasNotes(IdiomDetailEntity idiom, {required bool showTranslation}) {
    return (idiom.englishNotes != null &&
            idiom.englishNotes!.trim().isNotEmpty) ||
        (showTranslation &&
            idiom.arabicNotes != null &&
            idiom.arabicNotes!.trim().isNotEmpty);
  }

  Future<void> _copyText(String text, String toastMessage) async {
    await Clipboard.setData(ClipboardData(text: text));
    ToastHelper.show(msg: toastMessage, status: ToastStatus.success);
  }

  Future<void> _handleFlashcardAction(
    BuildContext context,
    IdiomDetailState state,
    IdiomDetailEntity idiom,
    AppLocalizations l10n,
  ) async {
    final cubit = context.read<IdiomDetailCubit>();
    if (state.flashcardGroups.isNotEmpty) {
      await _showChangeGroupSheet(
        context,
        cubit: cubit,
        currentGroup: state.flashcardGroups.first,
        l10n: l10n,
      );
      return;
    }

    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final firstCategory = idiom.categories.firstOrNull;
    final defaultGroupName =
        firstCategory?.localizedName(isArabic: isArabic) ?? l10n.generalGroup;

    final result = await cubit.saveToDefaultFlashcardGroup(
      groupName: defaultGroupName,
      categoryId: firstCategory?.id,
    );
    if (result == null || !context.mounted) return;

    SnackBarHelper.show(
      msg: l10n.savedToGroup(result.group.name),
      status: SnackBarStatus.success,
      actionText: l10n.changeGroup,
      onAction: () {
        if (!context.mounted) return;
        _showChangeGroupSheet(
          context,
          cubit: cubit,
          currentGroup: result.group,
          l10n: l10n,
        );
      },
    );
  }

  Future<void> _showChangeGroupSheet(
    BuildContext context, {
    required IdiomDetailCubit cubit,
    required FlashcardGroupEntity currentGroup,
    required AppLocalizations l10n,
  }) {
    final allGroups = cubit.state.allFlashcardGroups;
    return FlashcardGroupPickerSheet.show(
      context: context,
      title: l10n.chooseFlashcardGroup,
      groups: allGroups.isEmpty ? [currentGroup] : allGroups,
      selectedGroup: currentGroup,
      onGroupSelected: (targetGroup) async {
        if (targetGroup.id == currentGroup.id) return;
        await cubit.moveToFlashcardGroup(
          fromGroupId: currentGroup.id,
          toGroupId: targetGroup.id,
        );
        ToastHelper.show(
          msg: l10n.movedToGroup(targetGroup.name),
          status: ToastStatus.success,
        );
      },
      onCreateGroupAndSelect: (newGroupName) async {
        final created = await cubit.createAndMoveToFlashcardGroup(
          fromGroupId: currentGroup.id,
          newGroupName: newGroupName,
        );
        if (created != null) {
          ToastHelper.show(
            msg: l10n.movedToGroup(created.name),
            status: ToastStatus.success,
          );
        }
      },
      onRemoveFromGroup: () async {
        await cubit.removeFromFlashcardGroup(currentGroup.id);
        ToastHelper.show(msg: l10n.removedFromGroup, status: ToastStatus.info);
      },
    );
  }
}
