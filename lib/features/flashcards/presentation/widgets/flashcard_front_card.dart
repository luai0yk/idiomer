import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';

class FlashcardFrontCard extends StatelessWidget {
  final IdiomDetailEntity card;

  const FlashcardFrontCard({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return MyCard.bordered(
      width: double.infinity,
      height: double.infinity,
      color: colorScheme.surfaceContainerLow,
      borderColor: colorScheme.primary.withValues(alpha: 0.25),
      borderRadius: context.brXl,
      padding: context.insetsAllXl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyIcon(
            icon: AppIcons.flashcards,
            color: colorScheme.primary,
            size: context.iconXl,
          ),
          context.verticalSpace(20),
          Text(
            card.englishText,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          context.verticalSpace(20),
          Text(
            l10n.tapCardToFlip,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
