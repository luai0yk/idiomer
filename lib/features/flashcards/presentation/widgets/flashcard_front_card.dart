import 'package:flutter/material.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';

class FlashcardFrontCard extends StatelessWidget {
  final IdiomDetailEntity card;

  const FlashcardFrontCard({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return MyCard.filled(
      width: double.infinity,
      height: double.infinity,
      borderRadius: context.brXl,
      padding: context.insetsAllXl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            card.englishText,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          Text(
            l10n.tapCardToFlip,
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
