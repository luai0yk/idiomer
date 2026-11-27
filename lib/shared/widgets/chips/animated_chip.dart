import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/animations/my_animated_fade_switcher.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';

class AnimatedChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  /// When true, shows a checkmark icon.
  /// Defaults to `false`.
  final bool showIcon;

  /// Custom border radius.
  /// Defaults to [context.brCircular].
  final BorderRadius? borderRadius;

  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final EdgeInsets? padding;
  final double? fontSize;
  final double? iconSize;

  const AnimatedChip({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.showIcon = false,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.padding,
    this.fontSize,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final double resolvedIconSize = iconSize ?? context.setSize(14);
    final double resolvedFontSize = fontSize ?? context.setSize(13);

    return MyAnimatedFadeSwitcher(
      child: MyCard.filled(
        key: ValueKey<bool>(isSelected),
        padding:
            padding ??
            EdgeInsets.symmetric(
              horizontal: context.spaceM,
              vertical: context.spaceS,
            ),
        color: isSelected
            ? context.colorScheme.primary
            : colors.surfaceContainer,
        borderRadius: borderRadius ?? context.brL,
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefix != null) ...[
              prefix!,
              SizedBox(width: context.setSize(6)),
            ] else if (prefixIcon != null) ...[
              MyIcon(
                icon: prefixIcon!,
                color: isSelected ? colors.onPrimary : colors.onSurface,
                size: resolvedIconSize,
              ),
              SizedBox(width: context.setSize(6)),
            ] else if (isSelected && showIcon) ...[
              MyIcon(
                icon: AppIcons.checkCircle,
                color: colors.onPrimary,
                size: resolvedIconSize,
              ),
              SizedBox(width: context.setSize(6)),
            ],
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? colors.onPrimary : colors.onSurface,
                  fontSize: resolvedFontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (suffix != null) ...[
              SizedBox(width: context.setSize(6)),
              suffix!,
            ] else if (suffixIcon != null) ...[
              SizedBox(width: context.setSize(4)),
              MyIcon(
                icon: suffixIcon!,
                color: isSelected ? colors.onPrimary : colors.onSurface,
                size: resolvedIconSize,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
