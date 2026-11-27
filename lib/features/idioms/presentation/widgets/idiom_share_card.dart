import 'package:flutter/material.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
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

    final cardWidth = maxWidth ?? context.setSize(360);
    final primary = colorScheme.primary;
    final onPrimary = colorScheme.onPrimary;
    final primaryDefinition = idiom.definitions.firstOrNull;
    final primaryExample = idiom.examples.firstOrNull;
    final primaryCategory = idiom.categories.firstOrNull;

    // Keep the captured boundary square-edged (no borderRadius or outer shadow)
    // while clipping the on-screen preview with rounded corners outside it.
    Widget captureContent = Container(
      width: double.infinity,
      color: primary,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            top: context.setSize(28),
            left: -context.setSize(12),
            child: Transform.rotate(
              angle: -0.1,
              child: MyIcon(
                icon: AppIcons.quoteUp,
                size: context.setSize(96),
                color: onPrimary.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -context.setSize(14),
            right: context.setSize(8),
            child: Transform.rotate(
              angle: -0.08,
              child: MyIcon(
                icon: AppIcons.quoteDown,
                size: context.setSize(96),
                color: onPrimary.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: context.insetsAllXl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(
                  context,
                  l10n,
                  textTheme,
                  onPrimary,
                  primaryCategory?.localizedName(isArabic: isArabic),
                ),
                context.verticalSpace(18),
                Text(
                  idiom.englishText,
                  textDirection: TextDirection.ltr,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: onPrimary,
                    height: 1.25,
                  ),
                ),
                context.verticalSpace(6),
                Text(
                  idiom.arabicText,
                  textDirection: TextDirection.rtl,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: onPrimary.withValues(alpha: 0.9),
                  ),
                ),
                if (primaryDefinition != null) ...[
                  context.verticalSpace(16),
                  _buildDefinitionPanel(
                    context,
                    primaryDefinition,
                    textTheme,
                    onPrimary,
                    l10n,
                  ),
                ],
                if (primaryExample != null) ...[
                  context.verticalSpace(10),
                  _buildExamplePanel(
                    context,
                    primaryExample,
                    textTheme,
                    onPrimary,
                    l10n,
                  ),
                ],
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
              color: primary.withValues(alpha: 0.28),
              blurRadius: context.setSize(28),
              offset: Offset(0, context.setSize(12)),
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
    AppLocalizations l10n,
    TextTheme textTheme,
    Color onPrimary,
    String? categoryName,
  ) {
    return Row(
      children: [
        MyIcon(
          icon: AppIcons.idiomsFilled,
          size: context.iconM,
          color: onPrimary,
        ),
        context.horizontalSpace(6),
        Text(
          l10n.appName,
          style: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: onPrimary,
            letterSpacing: 0.3,
          ),
        ),
        const Spacer(),
        if (categoryName != null)
          MyCard.filled(
            color: onPrimary.withValues(alpha: 0.16),
            borderRadius: context.brCircular,
            padding: EdgeInsets.symmetric(
              horizontal: context.spaceM,
              vertical: context.spaceXs,
            ),
            child: Text(
              categoryName,
              style: textTheme.labelSmall?.copyWith(
                color: onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDefinitionPanel(
    BuildContext context,
    IdiomDefinitionEntity definition,
    TextTheme textTheme,
    Color onPrimary,
    AppLocalizations l10n,
  ) {
    return MyCard.filled(
      color: onPrimary.withValues(alpha: 0.13),
      borderRadius: context.brL,
      padding: context.insetsAllM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              MyIcon(
                icon: AppIcons.info,
                size: context.iconS,
                color: onPrimary,
              ),
              context.horizontalSpace(6),
              Text(
                l10n.meaningLabel,
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: onPrimary,
                ),
              ),
            ],
          ),
          context.verticalSpace(6),
          HighlightedMarkupText(
            definition.englishMeaning,
            textDirection: TextDirection.ltr,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              color: onPrimary.withValues(alpha: 0.88),
              height: 1.4,
            ),
            highlightStyle: textTheme.bodyMedium?.copyWith(
              color: onPrimary,
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.underline,
              decorationColor: onPrimary.withValues(alpha: 0.65),
              height: 1.4,
            ),
          ),
          if (definition.arabicMeaning.trim().isNotEmpty) ...[
            context.verticalSpace(4),
            HighlightedMarkupText(
              definition.arabicMeaning,
              textDirection: TextDirection.rtl,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(
                color: onPrimary.withValues(alpha: 0.82),
                height: 1.4,
              ),
              highlightStyle: textTheme.bodySmall?.copyWith(
                color: onPrimary,
                fontWeight: FontWeight.w800,
                decoration: TextDecoration.underline,
                decorationColor: onPrimary.withValues(alpha: 0.65),
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExamplePanel(
    BuildContext context,
    IdiomExampleEntity example,
    TextTheme textTheme,
    Color onPrimary,
    AppLocalizations l10n,
  ) {
    return MyCard.bordered(
      color: onPrimary.withValues(alpha: 0.08),
      borderColor: onPrimary.withValues(alpha: 0.16),
      borderRadius: context.brL,
      padding: context.insetsAllM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              MyIcon(
                icon: AppIcons.text,
                size: context.iconS,
                color: onPrimary.withValues(alpha: 0.9),
              ),
              context.horizontalSpace(6),
              Text(
                l10n.exampleLabel,
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: onPrimary.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          context.verticalSpace(6),
          HighlightedMarkupText(
            '"${example.englishSentence}"',
            textDirection: TextDirection.ltr,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: onPrimary.withValues(alpha: 0.88),
              height: 1.4,
            ),
            highlightStyle: textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: onPrimary,
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.underline,
              decorationColor: onPrimary.withValues(alpha: 0.65),
              height: 1.4,
            ),
          ),
          if (example.arabicSentence.trim().isNotEmpty) ...[
            context.verticalSpace(4),
            HighlightedMarkupText(
              example.arabicSentence,
              textDirection: TextDirection.rtl,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(
                color: onPrimary.withValues(alpha: 0.82),
                height: 1.4,
              ),
              highlightStyle: textTheme.bodySmall?.copyWith(
                color: onPrimary,
                fontWeight: FontWeight.w800,
                decoration: TextDecoration.underline,
                decorationColor: onPrimary.withValues(alpha: 0.65),
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
