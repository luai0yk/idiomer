import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/animations/my_animated_scale_fade_switcher.dart';
import 'package:idiomer/shared/widgets/appbars/my_gradient_header.dart';
import 'package:idiomer/shared/widgets/appbars/sliver_header_delegate.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';
import 'package:idiomer/shared/widgets/chips/animated_chip.dart';
import 'package:idiomer/shared/widgets/input/my_text_field.dart';

/// Fixed title bar for Explore and Favorites pages, positioned above the
/// scrollable [CustomScrollView] so the floating search bar never slides behind it.
class ExploreFixedHeader extends StatelessWidget {
  final String? title;
  final Widget? trailing;
  final bool showBottomBorder;

  const ExploreFixedHeader({
    super.key,
    this.title,
    this.trailing,
    this.showBottomBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MyGradientHeader(
      title: title ?? l10n.explore,
      showBottomBorder: showBottomBorder,
      actions: trailing != null ? [trailing!] : const [],
    );
  }
}

/// Floating search-and-filter sliver using [MySliverHeader] / [SliverHeaderDelegate]
/// that scrolls away with the list and reappears immediately on reverse scroll.
class ExploreSearchHeader extends StatelessWidget {
  static double barHeight(BuildContext context) => context.setSize(68);
  final bool searchEnabled;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final bool hasCategories;
  final bool hasActiveCategoryFilter;
  final String? selectedCategoryName;
  final VoidCallback? onClearCategory;
  final VoidCallback onOpenCategorySheet;

  const ExploreSearchHeader({
    super.key,
    this.searchEnabled = true,
    required this.searchController,
    required this.onSearchChanged,
    required this.hasCategories,
    required this.hasActiveCategoryFilter,
    this.selectedCategoryName,
    this.onClearCategory,
    required this.onOpenCategorySheet,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;
    final primary = colorScheme.primary;
    final totalHeight = barHeight(context);

    return MySliverHeader(
      height: totalHeight,
      floating: true,
      pinned: false,
      withBlur: false,
      isElevated: false,
      backgroundColor: colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.spaceM,
          context.spaceXs,
          context.spaceM,
          context.spaceS,
        ),
        child: Center(
          child: MyTextField(
            controller: searchController,
            isSearch: true,
            enabled: searchEnabled,
            hintText: l10n.search,
            onChanged: onSearchChanged,
            suffixWidget: _buildSuffixWidget(context, primary, colorScheme),
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffixWidget(
    BuildContext context,
    Color primary,
    ColorScheme colorScheme,
  ) {
    final l10n = context.l10n;
    final hasChip =
        selectedCategoryName != null && selectedCategoryName!.trim().isNotEmpty;

    if (!hasCategories && !hasChip) return null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyAnimatedScaleFadeSwitcher(
          child: hasChip
              ? Padding(
                  key: ValueKey(selectedCategoryName),
                  padding: EdgeInsetsDirectional.only(end: context.spaceXs),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: context.screenWidth * 0.25,
                    ),
                    child: AnimatedChip(
                      text: selectedCategoryName!,
                      isSelected: true,
                      borderRadius: context.brCircular,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spaceS,
                        vertical: context.spaceXs,
                      ),
                      fontSize: context.setSize(11),
                      iconSize: context.iconXs,
                      suffixIcon: AppIcons.close,
                      onTap: () {
                        if (searchEnabled) {
                          onClearCategory?.call();
                        }
                      },
                    ),
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('no_category_chip')),
        ),
        if (hasCategories)
          MyIconButton.ghost(
            icon: AppIcons.filter,
            tooltip: l10n.selectCategory,
            buttonSize: context.setSize(38),
            iconSize: context.iconM,
            disabled: !searchEnabled,
            iconColor: hasActiveCategoryFilter
                ? primary
                : colorScheme.onSurfaceVariant,
            onPressed: searchEnabled ? onOpenCategorySheet : null,
          ),
      ],
    );
  }
}
