import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_durations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';
import 'package:idiomer/shared/widgets/chips/animated_chip.dart';

/// Displays categories in either a single-row horizontal scrollable list
/// or an expanded wrapping layout, paired with a sticky expand/collapse toggle.
class CategoryFilterBar extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final bool isExpanded;
  final ValueChanged<String?> onCategorySelected;
  final VoidCallback onToggleExpand;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.isExpanded,
    required this.onCategorySelected,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: context.spaceM,
        end: context.spaceM,
        bottom: context.spaceS,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sticky expand/collapse toggle stays anchored beside the filter area.
          MyIconButton.solid(
            icon: isExpanded ? AppIcons.arrowUp : AppIcons.arrowDown,
            buttonSize: context.setSize(36),
            iconSize: context.iconS,
            tooltip: isExpanded
                ? l10n.collapseCategories
                : l10n.expandCategories,
            onPressed: onToggleExpand,
          ),
          context.horizontalSpace(8),
          Container(
            width: 1,
            height: context.setSize(28),
            margin: EdgeInsets.only(top: context.setSize(4)),
            color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
          context.horizontalSpace(8),
          Expanded(
            child: AnimatedSize(
              duration: AppDurations.fast,
              curve: Curves.easeOutCubic,
              alignment: AlignmentDirectional.topStart,
              child: isExpanded
                  ? _buildWrappedCategories(
                      context,
                      l10n.allCategories,
                      isArabic,
                    )
                  : _buildHorizontalCategories(
                      context,
                      l10n.allCategories,
                      isArabic,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCategories(
    BuildContext context,
    String allLabel,
    bool isArabic,
  ) {
    return SizedBox(
      height: context.setSize(38),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length + 1,
        separatorBuilder: (_, _) => context.horizontalSpace(8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return AnimatedChip(
              text: allLabel,
              isSelected: selectedCategoryId == null,
              onTap: () => onCategorySelected(null),
            );
          }
          final category = categories[index - 1];
          return AnimatedChip(
            text: category.localizedName(isArabic: isArabic),
            isSelected: selectedCategoryId == category.id,
            onTap: () => onCategorySelected(category.id),
          );
        },
      ),
    );
  }

  Widget _buildWrappedCategories(
    BuildContext context,
    String allLabel,
    bool isArabic,
  ) {
    return Wrap(
      spacing: context.spaceS,
      runSpacing: context.spaceS,
      children: [
        AnimatedChip(
          text: allLabel,
          isSelected: selectedCategoryId == null,
          onTap: () => onCategorySelected(null),
        ),
        for (final category in categories)
          AnimatedChip(
            text: category.localizedName(isArabic: isArabic),
            isSelected: selectedCategoryId == category.id,
            onTap: () => onCategorySelected(category.id),
          ),
      ],
    );
  }
}
