import 'package:flutter/material.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/settings_helper.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';

/// Editorial hero card at the top of [IdiomDetailPage] showcasing the idiom,
/// its Arabic translation, category pills, and a quick copy action.
class IdiomDetailHeroCard extends StatelessWidget {
  final IdiomDetailEntity idiom;
  final VoidCallback onCopy;
  final VoidCallback? onSpeak;
  final bool isSpeaking;

  const IdiomDetailHeroCard({
    super.key,
    required this.idiom,
    required this.onCopy,
    this.onSpeak,
    this.isSpeaking = false,
  });

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
                _buildActionsRow(l10n, onPrimary, context),
                context.verticalSpace(4),
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
                if (idiom.categories.isNotEmpty) ...[
                  context.verticalSpace(16),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Wrap(
                      spacing: context.spaceS,
                      runSpacing: context.spaceS,
                      children: [
                        for (final category in idiom.categories)
                          _buildCategoryChip(
                            context,
                            category.localizedName(isArabic: isArabic),
                            textTheme,
                            onPrimary,
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsRow(
    AppLocalizations l10n,
    Color onPrimary,
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onSpeak != null) ...[
          MyIconButton.ghost(
            icon: isSpeaking ? AppIcons.stop : AppIcons.volume,
            iconColor: onPrimary,
            tooltip: isSpeaking ? l10n.stopSpeaking : l10n.listen,
            autoLoading: false,
            onPressed: onSpeak,
          ),
          context.horizontalSpace(2),
        ],
        MyIconButton.ghost(
          icon: AppIcons.copy,
          iconColor: onPrimary,
          tooltip: l10n.copy,
          onPressed: onCopy,
        ),
      ],
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String label,
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
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textTheme.labelSmall?.copyWith(
          color: onPrimary.withValues(alpha: 0.95),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
