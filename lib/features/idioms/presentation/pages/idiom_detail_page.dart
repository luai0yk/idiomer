import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<IdiomDetailCubit>().watchIdiom(widget.idiomId);
      }
    });
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
            onCopy: () => _copyText(
              '${idiom.englishText}\n${idiom.arabicText}',
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
            ..._buildDefinitions(context, idiom, textTheme, colorScheme, l10n),
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
            ..._buildExamples(context, idiom, textTheme, colorScheme, l10n),
          ],
          if (_hasNotes(idiom)) ...[
            context.verticalSpace(20),
            _buildSectionTitle(
              context,
              l10n.notesLabel,
              AppIcons.notes,
              textTheme,
              colorScheme,
            ),
            context.verticalSpace(8),
            _buildNotesCard(context, idiom, textTheme, colorScheme),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildDefinitions(
    BuildContext context,
    IdiomDetailEntity idiom,
    TextTheme textTheme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
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
  }) {
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
              MyIconButton.ghost(
                icon: AppIcons.copy,
                iconSize: context.iconS,
                tooltip: l10n.copy,
                onPressed: () => _copyText(
                  HighlightedMarkupText.stripMarkers(
                    '${definition.englishMeaning}\n${definition.arabicMeaning}',
                  ),
                  l10n.copiedToClipboard,
                ),
              ),
            ],
          ),
          if (definition.arabicMeaning.trim().isNotEmpty) ...[
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
    AppLocalizations l10n,
  ) {
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
  }) {
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
              MyIconButton.ghost(
                icon: AppIcons.copy,
                iconSize: context.iconS,
                tooltip: l10n.copy,
                onPressed: () => _copyText(
                  HighlightedMarkupText.stripMarkers(
                    '${example.englishSentence}\n${example.arabicSentence}',
                  ),
                  l10n.copiedToClipboard,
                ),
              ),
            ],
          ),
          if (example.arabicSentence.trim().isNotEmpty) ...[
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
    ColorScheme colorScheme,
  ) {
    final hasEn =
        idiom.englishNotes != null && idiom.englishNotes!.trim().isNotEmpty;
    final hasAr =
        idiom.arabicNotes != null && idiom.arabicNotes!.trim().isNotEmpty;

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

  bool _hasNotes(IdiomDetailEntity idiom) {
    return (idiom.englishNotes != null &&
            idiom.englishNotes!.trim().isNotEmpty) ||
        (idiom.arabicNotes != null && idiom.arabicNotes!.trim().isNotEmpty);
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
