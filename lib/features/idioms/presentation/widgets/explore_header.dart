import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';
import 'package:idiomer/shared/widgets/input/my_text_field.dart';

class ExploreHeader extends StatelessWidget {
  final String? title;
  final Widget? trailing;
  final bool searchEnabled;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final bool hasCategories;
  final bool hasActiveCategoryFilter;
  final VoidCallback onOpenCategorySheet;

  const ExploreHeader({
    super.key,
    this.title,
    this.trailing,
    this.searchEnabled = true,
    required this.searchController,
    required this.onSearchChanged,
    required this.hasCategories,
    required this.hasActiveCategoryFilter,
    required this.onOpenCategorySheet,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    final primary = colorScheme.primary;
    final tertiary = colorScheme.tertiary;
    final surface = colorScheme.surface;
    final statusBarHeight = MediaQuery.paddingOf(context).top;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.55, 1.0],
          colors: [
            Color.alphaBlend(primary.withValues(alpha: 0.16), surface),
            Color.alphaBlend(tertiary.withValues(alpha: 0.06), surface),
            surface,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.spaceM,
          statusBarHeight + context.spaceM,
          context.spaceM,
          context.spaceS,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title ?? l10n.explore,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                if (trailing != null) ...[
                  context.horizontalSpace(8),
                  trailing!,
                ],
              ],
            ),
            context.verticalSpace(12),
            MyTextField(
              controller: searchController,
              isSearch: true,
              enabled: searchEnabled,
              hintText: l10n.search,
              onChanged: onSearchChanged,
              suffixWidget: hasCategories
                  ? MyIconButton.ghost(
                      icon: AppIcons.filter,
                      tooltip: l10n.selectCategory,
                      buttonSize: context.setSize(38),
                      iconSize: context.iconM,
                      disabled: !searchEnabled,
                      iconColor: hasActiveCategoryFilter
                          ? primary
                          : colorScheme.onSurfaceVariant,
                      onPressed: searchEnabled ? onOpenCategorySheet : null,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
