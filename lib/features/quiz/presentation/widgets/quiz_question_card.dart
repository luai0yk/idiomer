import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';
import 'package:idiomer/shared/widgets/texts/highlighted_markup_text.dart';

/// Editorial prompt card for a quiz question with a `primary` → `tertiary`
/// gradient and translucent [AppIcons.help] watermarks in the background.
class QuizQuestionCard extends StatelessWidget {
  final String prompt;
  final String englishMeaning;
  final String? questionCounterLabel;
  final EdgeInsetsGeometry? padding;

  const QuizQuestionCard({
    super.key,
    required this.prompt,
    required this.englishMeaning,
    this.questionCounterLabel,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final primary = colorScheme.primary;
    final tertiary = colorScheme.tertiary;
    final onPrimary = colorScheme.onPrimary;

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

    return MyCard.filled(
      gradient: cardGradient,
      borderRadius: context.brXl,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          PositionedDirectional(
            top: -context.setSize(38),
            end: -context.setSize(28),
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
          PositionedDirectional(
            top: context.setSize(12),
            start: -context.setSize(14),
            child: Transform.rotate(
              angle: -0.14,
              child: MyIcon(
                icon: AppIcons.help,
                size: context.setSize(72),
                color: onPrimary.withValues(alpha: 0.08),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: -context.setSize(18),
            end: -context.setSize(4),
            child: Transform.rotate(
              angle: 0.12,
              child: MyIcon(
                icon: AppIcons.help,
                size: context.setSize(108),
                color: onPrimary.withValues(alpha: 0.1),
              ),
            ),
          ),
          Padding(
            padding:
                padding ??
                EdgeInsets.symmetric(
                  horizontal: context.spaceL,
                  vertical: context.setSize(20),
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        prompt,
                        style: textTheme.labelMedium?.copyWith(
                          color: onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (questionCounterLabel != null) ...[
                      context.horizontalSpace(8),
                      Text(
                        questionCounterLabel!,
                        style: textTheme.labelMedium?.copyWith(
                          color: onPrimary.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
                context.verticalSpace(14),
                HighlightedMarkupText(
                  englishMeaning,
                  textDirection: TextDirection.ltr,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: onPrimary,
                    height: 1.4,
                  ),
                  highlightStyle: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: onPrimary,
                    decoration: TextDecoration.underline,
                    decorationColor: onPrimary.withValues(alpha: 0.65),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
