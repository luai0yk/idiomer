import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/misc/share_helper.dart';
import 'package:idiomer/core/utils/helpers/ui/toast_helper.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/presentation/cubit/idiom_detail_cubit.dart';
import 'package:idiomer/features/idioms/presentation/cubit/idiom_detail_state.dart';
import 'package:idiomer/shared/widgets/appbars/my_app_bar.dart';
import 'package:idiomer/shared/widgets/buttons/my_favorite_button.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/chips/animated_chip.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';
import 'package:idiomer/shared/widgets/misc/my_progress_indicator.dart';
import 'package:idiomer/shared/widgets/misc/my_toast.dart';

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
          appBar: MyAppBar(
            centerTitle: false,
            title: l10n.idiomDetails,
            actions: idiom == null
                ? null
                : [
                    MyFavoriteButton(
                      initialIsFavorite: idiom.isFavorite,
                      onChanged: (_) =>
                          context.read<IdiomDetailCubit>().toggleFavorite(),
                    ),
                    context.horizontalSpace(8),
                    MyIconButton.solid(
                      icon: AppIcons.copy,
                      tooltip: l10n.copyAll,
                      onPressed: () => _copyText(
                        _formatShareText(idiom),
                        l10n.copiedToClipboard,
                      ),
                    ),
                    context.horizontalSpace(8),
                    MyIconButton.solid(
                      icon: AppIcons.share,
                      tooltip: l10n.share,
                      onPressed: () => ShareHelper.shareText(
                        _formatShareText(idiom),
                        subject: idiom.englishText,
                      ),
                    ),
                  ],
          ),
          body: _buildBody(context, state, l10n),
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
      return const Center(child: MyProgressIndicator());
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
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return SelectionArea(
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          context.spaceM,
          context.spaceM,
          context.spaceM,
          context.spaceXxl,
        ),
        children: [
          _buildHeroCard(context, idiom, textTheme, colorScheme, l10n),
          if (idiom.categories.isNotEmpty) ...[
            context.verticalSpace(16),
            _buildSectionTitle(
              context,
              l10n.categoriesLabel,
              AppIcons.category,
              textTheme,
              colorScheme,
            ),
            context.verticalSpace(8),
            Wrap(
              spacing: context.spaceS,
              runSpacing: context.spaceS,
              children: [
                for (final category in idiom.categories)
                  AnimatedChip(
                    text: category.localizedName(isArabic: isArabic),
                    isSelected: false,
                    onTap: () {},
                  ),
              ],
            ),
          ],
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

  Widget _buildHeroCard(
    BuildContext context,
    IdiomDetailEntity idiom,
    TextTheme textTheme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    return MyCard.filled(
      color: colorScheme.primaryContainer.withValues(alpha: 0.14),
      borderRadius: context.brL,
      padding: context.insetsAllL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.idiomLabel,
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    context.verticalSpace(4),
                    Text(
                      idiom.englishText,
                      textDirection: TextDirection.ltr,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              MyIconButton.ghost(
                icon: AppIcons.copy,
                tooltip: l10n.copy,
                onPressed: () => _copyText(
                  '${idiom.englishText}\n${idiom.arabicText}',
                  l10n.copiedToClipboard,
                ),
              ),
            ],
          ),
          context.verticalSpace(14),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          context.verticalSpace(14),
          Text(
            idiom.arabicText,
            textDirection: TextDirection.rtl,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
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
      color: colorScheme.surfaceContainerLow,
      borderRadius: context.brM,
      padding: context.insetsAllM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
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
                  '${definition.englishMeaning}\n${definition.arabicMeaning}',
                  l10n.copiedToClipboard,
                ),
              ),
            ],
          ),
          if (definition.arabicMeaning.trim().isNotEmpty) ...[
            context.verticalSpace(8),
            Text(
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
      color: colorScheme.surfaceContainerLow,
      borderRadius: context.brM,
      padding: context.insetsAllM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
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
                  '${example.englishSentence}\n${example.arabicSentence}',
                  l10n.copiedToClipboard,
                ),
              ),
            ],
          ),
          if (example.arabicSentence.trim().isNotEmpty) ...[
            context.verticalSpace(8),
            Text(
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
      color: colorScheme.surfaceContainerLow,
      borderRadius: context.brM,
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

  String _formatShareText(IdiomDetailEntity idiom) {
    final buffer = StringBuffer()
      ..writeln(idiom.englishText)
      ..writeln(idiom.arabicText);

    if (idiom.definitions.isNotEmpty) {
      buffer.writeln();
      for (final def in idiom.definitions) {
        buffer.writeln('- ${def.englishMeaning}');
        if (def.arabicMeaning.trim().isNotEmpty) {
          buffer.writeln('  ${def.arabicMeaning}');
        }
      }
    }

    if (idiom.examples.isNotEmpty) {
      buffer.writeln();
      for (final ex in idiom.examples) {
        buffer.writeln('• ${ex.englishSentence}');
        if (ex.arabicSentence.trim().isNotEmpty) {
          buffer.writeln('  ${ex.arabicSentence}');
        }
      }
    }

    return buffer.toString().trim();
  }
}
