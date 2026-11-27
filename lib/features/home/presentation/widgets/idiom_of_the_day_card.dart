import 'package:flutter/material.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/shared/widgets/buttons/my_favorite_button.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';
import 'package:idiomer/shared/widgets/texts/highlighted_markup_text.dart';

/// Featured editorial card on Home showcasing the daily idiom and an example.
class IdiomOfTheDayCard extends StatelessWidget {
  final IdiomDetailEntity idiom;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const IdiomOfTheDayCard({
    super.key,
    required this.idiom,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    final primary = colorScheme.primary;
    final tertiary = colorScheme.tertiary;
    final onPrimary = colorScheme.onPrimary;
    final primaryExample = idiom.examples.firstOrNull;
    final primaryDefinition = idiom.definitions.firstOrNull;
    final categoryName = idiom.categories.firstOrNull?.localizedName(
      isArabic: isArabic,
    );

    final cardGradient = LinearGradient(
      begin: AlignmentDirectional.topStart,
      end: AlignmentDirectional.bottomEnd,
      stops: const [0.0, 0.65, 1.0],
      colors: [
        primary,
        Color.lerp(primary, tertiary, 0.14) ?? primary,
        Color.lerp(primary, tertiary, 0.28) ?? primary,
      ],
    );

    return MyCard.elevated(
      gradient: cardGradient,
      borderRadius: context.brXl,
      padding: EdgeInsets.zero,
      customShadow: [
        BoxShadow(
          color: primary.withValues(alpha: 0.24),
          blurRadius: context.setSize(22),
          offset: Offset(0, context.setSize(10)),
        ),
      ],
      onTap: onTap,
      child: Stack(
        children: [
          PositionedDirectional(
            top: -context.setSize(38),
            end: -context.setSize(30),
            child: Container(
              width: context.setSize(148),
              height: context.setSize(148),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    onPrimary.withValues(alpha: 0.14),
                    onPrimary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: context.setSize(26),
            left: -context.setSize(12),
            child: Transform.rotate(
              angle: -0.1,
              child: MyIcon(
                icon: AppIcons.quoteUp,
                size: context.setSize(84),
                color: onPrimary.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -context.setSize(14),
            right: context.setSize(6),
            child: Transform.rotate(
              angle: -0.08,
              child: MyIcon(
                icon: AppIcons.quoteDown,
                size: context.setSize(88),
                color: onPrimary.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: context.insetsAllL,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTopRow(context, l10n, textTheme, onPrimary),
                context.verticalSpace(4),
                Text(
                  idiom.englishText,
                  textDirection: TextDirection.ltr,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: onPrimary,
                    height: 1.25,
                  ),
                ),
                context.verticalSpace(4),
                Text(
                  idiom.arabicText,
                  textDirection: TextDirection.rtl,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: onPrimary.withValues(alpha: 0.88),
                  ),
                ),
                if (primaryExample != null) ...[
                  context.verticalSpace(14),
                  _buildExamplePanel(
                    context,
                    primaryExample,
                    textTheme,
                    onPrimary,
                    l10n,
                  ),
                ] else if (primaryDefinition != null) ...[
                  context.verticalSpace(14),
                  _buildMeaningFallbackPanel(
                    context,
                    primaryDefinition,
                    textTheme,
                    onPrimary,
                    l10n,
                  ),
                ],
                context.verticalSpace(14),
                _buildFooterRow(
                  context,
                  l10n,
                  textTheme,
                  onPrimary,
                  categoryName,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopRow(
    BuildContext context,
    AppLocalizations l10n,
    TextTheme textTheme,
    Color onPrimary,
  ) {
    return Row(
      children: [
        MyCard.filled(
          color: onPrimary.withValues(alpha: 0.16),
          borderColor: onPrimary.withValues(alpha: 0.22),
          borderRadius: context.brCircular,
          padding: EdgeInsets.symmetric(
            horizontal: context.spaceM,
            vertical: context.spaceXs,
          ),
          child: Text(
            l10n.idiomOfTheDay,
            style: textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: onPrimary,
            ),
          ),
        ),
        const Spacer(),
        MyFavoriteButton(
          initialIsFavorite: idiom.isFavorite,
          iconColor: onPrimary,
          onChanged: (_) => onToggleFavorite(),
        ),
      ],
    );
  }

  Widget _buildExamplePanel(
    BuildContext context,
    IdiomExampleEntity example,
    TextTheme textTheme,
    Color onPrimary,
    AppLocalizations l10n,
  ) {
    return _buildFrostedPanel(
      context: context,
      icon: AppIcons.text,
      label: l10n.exampleLabel,
      englishText: '"${example.englishSentence}"',
      italicEnglish: true,
      textTheme: textTheme,
      onPrimary: onPrimary,
    );
  }

  Widget _buildMeaningFallbackPanel(
    BuildContext context,
    IdiomDefinitionEntity definition,
    TextTheme textTheme,
    Color onPrimary,
    AppLocalizations l10n,
  ) {
    return _buildFrostedPanel(
      context: context,
      icon: AppIcons.info,
      label: l10n.meaningLabel,
      englishText: definition.englishMeaning,
      italicEnglish: false,
      textTheme: textTheme,
      onPrimary: onPrimary,
    );
  }

  Widget _buildFrostedPanel({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String englishText,
    required bool italicEnglish,
    required TextTheme textTheme,
    required Color onPrimary,
  }) {
    final fontStyle = italicEnglish ? FontStyle.italic : FontStyle.normal;
    final highlightColor = onPrimary.withValues(alpha: 0.7);

    return MyCard.bordered(
      color: onPrimary.withValues(alpha: 0.11),
      borderColor: onPrimary.withValues(alpha: 0.2),
      borderRadius: context.brL,
      padding: context.insetsAllM,
      child: HighlightedMarkupText(
        englishText,
        textDirection: TextDirection.ltr,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodySmall?.copyWith(
          fontStyle: fontStyle,
          color: onPrimary.withValues(alpha: 0.88),
          height: 1.4,
        ),
        highlightStyle: textTheme.bodyMedium?.copyWith(
          fontStyle: fontStyle,
          color: onPrimary,
          fontWeight: FontWeight.w800,
          decoration: TextDecoration.underline,
          decorationColor: highlightColor,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildFooterRow(
    BuildContext context,
    AppLocalizations l10n,
    TextTheme textTheme,
    Color onPrimary,
    String? categoryName,
  ) {
    return Row(
      children: [
        if (categoryName != null)
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: MyCard.filled(
                color: onPrimary.withValues(alpha: 0.14),
                borderRadius: context.brCircular,
                padding: EdgeInsets.symmetric(
                  horizontal: context.spaceS,
                  vertical: context.spaceXs,
                ),
                child: Text(
                  categoryName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelSmall?.copyWith(
                    color: onPrimary.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        else
          const Spacer(),
        context.horizontalSpace(8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.viewDetails,
              style: textTheme.labelMedium?.copyWith(
                color: onPrimary.withValues(alpha: 0.95),
                fontWeight: FontWeight.w700,
              ),
            ),
            context.horizontalSpace(4),
            MyIcon(
              icon: AppIcons.arrowForward(context),
              size: context.iconXs,
              color: onPrimary.withValues(alpha: 0.95),
            ),
          ],
        ),
      ],
    );
  }
}
