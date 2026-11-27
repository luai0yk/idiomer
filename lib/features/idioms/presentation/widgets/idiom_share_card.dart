import 'package:flutter/material.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/core/constants/app_assets.dart';
import 'package:idiomer/core/constants/app_constants.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/settings_helper.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/images/my_image.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';
import 'package:idiomer/shared/widgets/texts/highlighted_markup_text.dart';

/// Designed editorial card previewing the idiom, translation, definition,
/// and example for image capture and sharing.
class IdiomShareCard extends StatelessWidget {
  final IdiomDetailEntity idiom;
  final GlobalKey? boundaryKey;
  final Animation<double>? animation;
  final double? maxWidth;

  const IdiomShareCard({
    super.key,
    required this.idiom,
    this.boundaryKey,
    this.animation,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final showTranslation = SettingsHelper.watchShowTranslation(context);

    final cardWidth = maxWidth ?? context.setSize(360);
    final primary = colorScheme.primary;
    final tertiary = colorScheme.tertiary;
    final onPrimary = colorScheme.onPrimary;
    final primaryDefinition = idiom.definitions.firstOrNull;
    final primaryExample = idiom.examples.firstOrNull;
    final primaryCategory = idiom.categories.firstOrNull;

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

    // Keep the captured boundary square-edged (no borderRadius or outer shadow)
    // while clipping the on-screen preview with rounded corners outside it.
    Widget captureContent = Container(
      width: double.infinity,
      decoration: BoxDecoration(gradient: cardGradient),
      child: Stack(
        clipBehavior: Clip.hardEdge,
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(
                  context,
                  textTheme,
                  onPrimary,
                  primaryCategory?.localizedName(isArabic: isArabic),
                ),
                context.verticalSpace(16),
                Text(
                  idiom.englishText,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: onPrimary,
                    height: 1.25,
                  ),
                ),
                if (showTranslation && idiom.arabicText.trim().isNotEmpty) ...[
                  context.verticalSpace(6),
                  Text(
                    idiom.arabicText,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: onPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                ],
                if (primaryDefinition != null) ...[
                  context.verticalSpace(18),
                  _buildFrostedPanel(
                    context: context,
                    icon: AppIcons.info,
                    label: l10n.meaningLabel,
                    englishText: primaryDefinition.englishMeaning,
                    arabicText: showTranslation
                        ? primaryDefinition.arabicMeaning
                        : null,
                    italicEnglish: false,
                    fillAlpha: 0.13,
                    textTheme: textTheme,
                    onPrimary: onPrimary,
                  ),
                ],
                if (primaryExample != null) ...[
                  context.verticalSpace(12),
                  _buildFrostedPanel(
                    context: context,
                    icon: AppIcons.text,
                    label: l10n.exampleLabel,
                    englishText: '"${primaryExample.englishSentence}"',
                    arabicText: showTranslation
                        ? primaryExample.arabicSentence
                        : null,
                    italicEnglish: true,
                    fillAlpha: 0.10,
                    textTheme: textTheme,
                    onPrimary: onPrimary,
                  ),
                ],
                context.verticalSpace(14),
                _buildFooter(context, l10n, textTheme, onPrimary),
              ],
            ),
          ),
        ],
      ),
    );

    if (boundaryKey != null) {
      captureContent = RepaintBoundary(key: boundaryKey, child: captureContent);
    }

    Widget card = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: cardWidth),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: context.brXl,
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.24),
              blurRadius: context.setSize(22),
              offset: Offset(0, context.setSize(10)),
            ),
          ],
        ),
        child: ClipRRect(borderRadius: context.brXl, child: captureContent),
      ),
    );

    if (animation != null) {
      final curved = CurvedAnimation(
        parent: animation!,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      card = FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.88, end: 1.0).animate(curved),
          child: card,
        ),
      );
    }

    return card;
  }

  Widget _buildHeader(
    BuildContext context,
    TextTheme textTheme,
    Color onPrimary,
    String? categoryName,
  ) {
    // app_icon.png is 512x512 with the 384x128 pill centered inside transparent
    // margins, so overflow-clipping at 4/3x width reveals the pill cleanly.
    final pillHeight = context.setSize(26);
    final pillWidth = pillHeight * 3;
    final assetSize = pillHeight * 4;

    return Row(
      children: [
        SizedBox(
          width: pillWidth,
          height: pillHeight,
          child: ClipRect(
            child: OverflowBox(
              minWidth: assetSize,
              maxWidth: assetSize,
              minHeight: assetSize,
              maxHeight: assetSize,
              child: MyImage.asset(
                asset: AppAssets.appIcon,
                width: assetSize,
                height: assetSize,
                fit: BoxFit.contain,
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ),
        const Spacer(),
        if (categoryName != null)
          MyCard.filled(
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
      ],
    );
  }

  Widget _buildFrostedPanel({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String englishText,
    required String? arabicText,
    required bool italicEnglish,
    required double fillAlpha,
    required TextTheme textTheme,
    required Color onPrimary,
  }) {
    final fontStyle = italicEnglish ? FontStyle.italic : FontStyle.normal;
    final highlightColor = onPrimary.withValues(alpha: 0.7);
    final hasArabic = arabicText != null && arabicText.trim().isNotEmpty;

    return MyCard.bordered(
      color: onPrimary.withValues(alpha: fillAlpha),
      borderColor: onPrimary.withValues(alpha: 0.2),
      borderRadius: context.brL,
      padding: context.insetsAllM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              MyIcon(
                icon: icon,
                size: context.iconS,
                color: onPrimary.withValues(alpha: 0.92),
              ),
              context.horizontalSpace(6),
              Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: onPrimary.withValues(alpha: 0.92),
                ),
              ),
            ],
          ),
          context.verticalSpace(6),
          HighlightedMarkupText(
            englishText,
            textDirection: TextDirection.ltr,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              fontStyle: fontStyle,
              color: onPrimary.withValues(alpha: 0.9),
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
          if (hasArabic) ...[
            context.verticalSpace(6),
            HighlightedMarkupText(
              arabicText,
              textDirection: TextDirection.rtl,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(
                color: onPrimary.withValues(alpha: 0.84),
                height: 1.4,
              ),
              highlightStyle: textTheme.bodySmall?.copyWith(
                color: onPrimary,
                fontWeight: FontWeight.w800,
                decoration: TextDecoration.underline,
                decorationColor: highlightColor,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    AppLocalizations l10n,
    TextTheme textTheme,
    Color onPrimary,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(height: 1, color: onPrimary.withValues(alpha: 0.14)),
        context.verticalSpace(10),
        Text(
          l10n.sharedByIdiomer,
          textAlign: TextAlign.center,
          style: textTheme.labelSmall?.copyWith(
            color: onPrimary.withValues(alpha: 0.85),
            fontWeight: FontWeight.w600,
          ),
        ),
        context.verticalSpace(2),
        Text(
          AppConstants.appUrl,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          style: textTheme.labelSmall?.copyWith(
            color: onPrimary.withValues(alpha: 0.72),
          ),
        ),
      ],
    );
  }
}
