import 'package:flutter/material.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/texts/highlighted_markup_text.dart';

class FlashcardBackCard extends StatelessWidget {
  final IdiomDetailEntity card;

  const FlashcardBackCard({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final meaning = card.definitions.firstOrNull;
    final example = card.examples.firstOrNull;

    return MyCard.filled(
      width: double.infinity,
      height: double.infinity,
      color: colorScheme.primaryContainer.withValues(alpha: 0.16),
      borderColor: colorScheme.primary.withValues(alpha: 0.3),
      borderRadius: context.brXl,
      padding: context.insetsAllXl,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                card.englishText,
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              context.verticalSpace(12),
              Text(
                card.arabicText,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
              if (meaning != null) ...[
                context.verticalSpace(20),
                Divider(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
                context.verticalSpace(14),
                HighlightedMarkupText(
                  meaning.englishMeaning,
                  textDirection: TextDirection.ltr,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                if (meaning.arabicMeaning.trim().isNotEmpty) ...[
                  context.verticalSpace(6),
                  HighlightedMarkupText(
                    meaning.arabicMeaning,
                    textDirection: TextDirection.rtl,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
              if (example != null) ...[
                context.verticalSpace(14),
                MyCard.filled(
                  color: colorScheme.surface.withValues(alpha: 0.7),
                  borderRadius: context.brM,
                  padding: context.insetsAllM,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HighlightedMarkupText(
                        '"${example.englishSentence}"',
                        textDirection: TextDirection.ltr,
                        style: textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: colorScheme.onSurface,
                        ),
                        highlightStyle: textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.primary,
                        ),
                      ),
                      if (example.arabicSentence.trim().isNotEmpty) ...[
                        context.verticalSpace(4),
                        HighlightedMarkupText(
                          example.arabicSentence,
                          textDirection: TextDirection.rtl,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
