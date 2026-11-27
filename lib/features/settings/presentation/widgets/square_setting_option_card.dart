import 'package:flutter/material.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';

class SquareSettingOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SquareSettingOptionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final primary = colorScheme.primary;
    final baseSurface = colorScheme.surfaceContainerLow;

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyIcon(
          icon: icon,
          size: context.iconL,
          color: isSelected ? primary : colorScheme.onSurfaceVariant,
        ),
        context.verticalSpace(8),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.labelMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? primary : colorScheme.onSurface,
          ),
        ),
      ],
    );

    if (isSelected) {
      return MyCard.bordered(
        color: Color.alphaBlend(primary.withValues(alpha: 0.08), baseSurface),
        borderColor: primary.withValues(alpha: 0.22),
        borderWidth: context.setSize(1.2),
        borderRadius: context.brXl,
        padding: context.insetsAllS,
        onTap: onTap,
        child: content,
      );
    }

    return MyCard.filled(
      borderRadius: context.brXl,
      padding: context.insetsAllS,
      onTap: onTap,
      child: content,
    );
  }
}
