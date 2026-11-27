import 'package:flutter/material.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/settings/presentation/widgets/setting_icon_badge.dart';
import 'package:idiomer/features/settings/presentation/widgets/square_setting_option_card.dart';
import 'package:idiomer/shared/widgets/tiles/my_expansion_tile.dart';

class SettingOptionItem<T> {
  final T value;
  final String label;
  final IconData icon;

  const SettingOptionItem({
    required this.value,
    required this.label,
    required this.icon,
  });
}

class ExpandableSettingCard<T> extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String selectedLabel;
  final T selectedValue;
  final List<SettingOptionItem<T>> options;
  final ValueChanged<T> onSelect;

  const ExpandableSettingCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.selectedLabel,
    required this.selectedValue,
    required this.options,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return MyExpansionTile(
      title: title,
      subtitle: selectedLabel,
      subtitleStyle: textTheme.bodySmall?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      leading: SettingIconBadge(icon: icon, color: iconColor),
      backgroundColor: colorScheme.surfaceContainer,
      collapsedBackgroundColor: colorScheme.surfaceContainer,
      borderRadius: context.brXl,
      childrenPadding: EdgeInsets.fromLTRB(
        context.spaceM,
        context.spaceXs,
        context.spaceM,
        context.spaceM,
      ),
      children: [
        Row(
          children: [
            for (int i = 0; i < options.length; i++) ...[
              if (i > 0) context.horizontalSpace(8),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: context.setSize(124),
                      maxHeight: context.setSize(124),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: SquareSettingOptionCard(
                        icon: options[i].icon,
                        label: options[i].label,
                        isSelected: options[i].value == selectedValue,
                        onTap: () => onSelect(options[i].value),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
