import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/settings_helper.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';
import 'package:idiomer/shared/widgets/texts/highlighted_markup_text.dart';

/// Back face of a study flashcard styled after the Idiom of the Day card.
class FlashcardBackCard extends StatelessWidget {
  final IdiomDetailEntity card;

  const FlashcardBackCard({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final showTranslation = SettingsHelper.watchShowTranslation(context);

    final primary = colorScheme.primary;
    final tertiary = colorScheme.tertiary;
    final onPrimary = colorScheme.onPrimary;
    final meaning = card.definitions.firstOrNull;
    final example = card.examples.firstOrNull;
    final categoryName = card.categories.firstOrNull?.localizedName(
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
      width: double.infinity,
      height: double.infinity,
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
      child: Stack(
        fit: StackFit.expand,
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
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        context.spaceXl,
                        context.spaceXl,
                        context.spaceXl,
                        categoryName != null ? context.spaceM : context.spaceXl,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            card.englishText,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            style: textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: onPrimary,
                              height: 1.25,
                            ),
                          ),
                          if (showTranslation &&
                              card.arabicText.trim().isNotEmpty) ...[
                            context.verticalSpace(6),
                            Text(
                              card.arabicText,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: onPrimary.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                          if (meaning != null) ...[
                            context.verticalSpace(18),
                            _buildFrostedPanel(
                              context: context,
                              icon: AppIcons.info,
                              label: l10n.meaningLabel,
                              englishText: meaning.englishMeaning,
                              arabicText: showTranslation
                                  ? meaning.arabicMeaning
                                  : null,
                              italicEnglish: false,
                              fillAlpha: 0.13,
                              textTheme: textTheme,
                              onPrimary: onPrimary,
                            ),
                          ],
                          if (example != null) ...[
                            context.verticalSpace(12),
                            _buildFrostedPanel(
                              context: context,
                              icon: AppIcons.text,
                              label: l10n.exampleLabel,
                              englishText: '"${example.englishSentence}"',
                              arabicText: showTranslation
                                  ? example.arabicSentence
                                  : null,
                              italicEnglish: true,
                              fillAlpha: 0.10,
                              textTheme: textTheme,
                              onPrimary: onPrimary,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                if (categoryName != null)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      context.spaceL,
                      0,
                      context.spaceL,
                      context.spaceL,
                    ),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: _buildCategoryPill(
                        context,
                        categoryName,
                        textTheme,
                        onPrimary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPill(
    BuildContext context,
    String categoryName,
    TextTheme textTheme,
    Color onPrimary,
  ) {
    return MyCard.filled(
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
          fontWeight: FontWeight.w600,
          color: onPrimary.withValues(alpha: 0.95),
        ),
      ),
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
}
