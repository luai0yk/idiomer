import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_entity.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';
import 'package:idiomer/shared/widgets/texts/highlighted_markup_text.dart';

/// List card displaying an idiom, its Arabic translation, favorite indicator,
/// and an optional highlighted usage example.
class IdiomCard extends StatelessWidget {
  final IdiomEntity idiom;
  final VoidCallback onTap;

  const IdiomCard({super.key, required this.idiom, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final extendedColors = context.extendedColors;

    final example = idiom.englishExample?.trim();
    final hasExample = example != null && example.isNotEmpty;

    return MyCard.filled(
      borderRadius: context.brXl,
      padding: context.insetsAllL,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (idiom.isFavorite) ...[
                    MyIcon(
                      icon: AppIcons.favoriteFilled,
                      size: context.iconXs,
                      color: extendedColors.danger.color,
                    ),
                  ],
                  Expanded(
                    child: Text(
                      idiom.englishText,
                      textDirection: TextDirection.ltr,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
              context.verticalSpace(4),
              Text(
                idiom.arabicText,
                textDirection: TextDirection.rtl,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          if (hasExample) ...[
            context.verticalSpace(12),
            MyCard.bordered(
              color: Color.alphaBlend(
                colorScheme.primary.withValues(alpha: 0.045),
                colorScheme.surfaceContainer,
              ),
              borderColor: colorScheme.primary.withValues(alpha: 0.14),
              borderRadius: context.brL,
              padding: EdgeInsets.symmetric(
                horizontal: context.spaceM,
                vertical: context.spaceS + context.spaceXxs,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: context.spaceXxs),
                    child: MyIcon(
                      icon: AppIcons.quoteUp,
                      size: context.iconS,
                      color: colorScheme.primary.withValues(alpha: 0.7),
                    ),
                  ),
                  context.horizontalSpace(8),
                  Expanded(
                    child: HighlightedMarkupText(
                      '"$example"',
                      textDirection: TextDirection.ltr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                      highlightStyle: textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
