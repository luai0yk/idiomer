import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/settings/presentation/widgets/setting_icon_badge.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/tiles/my_list_tile.dart';

class ReminderCategoryCard extends StatelessWidget {
  final CategoryEntity? selectedCategory;
  final bool hasError;
  final VoidCallback onTap;

  const ReminderCategoryCard({
    super.key,
    required this.selectedCategory,
    required this.hasError,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final extendedColors = context.extendedColors;
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    final badgeColor = hasError
        ? extendedColors.danger.color
        : colorScheme.primary;
    final subtitle =
        selectedCategory?.localizedName(isArabic: isArabic) ??
        l10n.reminderCategoryRequiredHint;
    final subtitleColor = selectedCategory != null
        ? colorScheme.primary
        : (hasError
              ? extendedColors.danger.color
              : colorScheme.onSurfaceVariant);

    return MyCard.bordered(
      color: colorScheme.surfaceContainer,
      borderColor: hasError ? extendedColors.danger.color : Colors.transparent,
      borderWidth: hasError ? 1.5 : 1.0,
      borderRadius: context.brXl,
      padding: EdgeInsets.zero,
      child: MyListTile(
        leading: SettingIconBadge(icon: AppIcons.category, color: badgeColor),
        borderRadius: context.brXl,
        title: l10n.reminderCategoryTitle,
        subtitle: subtitle,
        subtitleColor: subtitleColor,
        trailingIcon: AppIcons.arrowForward(context),
        onTap: onTap,
      ),
    );
  }
}
