import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_durations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/animations/my_animated_scale_fade_switcher.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';

/// Borderless [MyCard.filled] quiz choice with smooth selection animation and a
/// leading checkmark indicator when selected.
class QuizOptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final TextDirection textDirection;
  final VoidCallback onTap;

  const QuizOptionCard({
    super.key,
    required this.text,
    required this.isSelected,
    required this.textDirection,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return MyCard.filled(
      borderRadius: context.brL,
      padding: EdgeInsets.zero,

      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        curve: Curves.easeOutCubic,
        padding: context.insetsAllL,
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.14)
              : colorScheme.primary.withValues(alpha: 0.0),
          borderRadius: context.brL,
          border: isSelected
              ? Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.4),
                  width: context.setSize(0.5),
                )
              : null,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.iconM),
          child: Directionality(
            textDirection: .ltr,
            child: Row(
              children: [
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: AppDurations.fast,
                    curve: Curves.easeOutCubic,
                    style: (textTheme.bodyLarge ?? const TextStyle()).copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                    child: Text(text, textDirection: textDirection),
                  ),
                ),
                AnimatedSize(
                  duration: AppDurations.fast,
                  curve: Curves.easeOutCubic,
                  child: MyAnimatedScaleFadeSwitcher(
                    duration: AppDurations.fast,
                    child: isSelected
                        ? Padding(
                            key: const ValueKey(true),
                            padding: EdgeInsetsDirectional.only(
                              end: context.spaceM,
                            ),
                            child: MyIcon(
                              icon: AppIcons.checkCircle,
                              color: colorScheme.primary,
                              size: context.iconM,
                            ),
                          )
                        : const SizedBox.shrink(key: ValueKey(false)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
