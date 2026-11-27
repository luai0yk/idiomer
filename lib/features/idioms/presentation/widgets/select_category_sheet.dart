import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/ui/bottom_sheet_helper.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/input/my_text_field.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';
import 'package:idiomer/shared/widgets/sheets/my_bottom_sheet.dart';

class SelectCategorySheet extends StatefulWidget {
  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;
  final bool includeAllOption;

  const SelectCategorySheet({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.includeAllOption = true,
  });

  static Future<void> show(
    BuildContext context, {
    required List<CategoryEntity> categories,
    required String? selectedCategoryId,
    required ValueChanged<String?> onCategorySelected,
    bool includeAllOption = true,
  }) {
    final l10n = context.l10n;
    return BottomSheetHelper.show<void>(
      child: MyBottomSheet(
        title: l10n.selectCategory,
        padding: EdgeInsets.zero,
        child: SelectCategorySheet(
          categories: categories,
          selectedCategoryId: selectedCategoryId,
          onCategorySelected: onCategorySelected,
          includeAllOption: includeAllOption,
        ),
      ),
    );
  }

  @override
  State<SelectCategorySheet> createState() => _SelectCategorySheetState();
}

class _SelectCategorySheetState extends State<SelectCategorySheet> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    final items = <CategoryEntity?>[
      if (widget.includeAllOption) null,
      ...widget.categories,
    ];
    final normalizedQuery = _query.trim().toLowerCase();
    final filteredItems = normalizedQuery.isEmpty
        ? items
        : items.where((category) {
            if (category == null) {
              return l10n.allCategories.toLowerCase().contains(normalizedQuery);
            }
            return category.englishName.toLowerCase().contains(
                  normalizedQuery,
                ) ||
                category.arabicName.toLowerCase().contains(normalizedQuery);
          }).toList();

    final showSearch = widget.categories.length > 6;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showSearch) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.spaceM,
              context.spaceS,
              context.spaceM,
              context.spaceS,
            ),
            child: MyTextField(
              controller: _searchController,
              isSearch: true,
              hintText: l10n.search,
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
        ],
        Flexible(
          child: filteredItems.isEmpty
              ? Padding(
                  padding: context.insetsAllL,
                  child: MyEmptyState(
                    icon: AppIcons.searchOff,
                    title: l10n.noResultsFound,
                    subtitle: l10n.tryAdjustingSearch,
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(
                    context.spaceM,
                    context.spaceS,
                    context.spaceM,
                    context.spaceL,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: context.spaceS,
                    crossAxisSpacing: context.spaceS,
                    mainAxisExtent: context.setSize(90),
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final category = filteredItems[index];
                    final isSelected =
                        widget.selectedCategoryId == category?.id;
                    final title = category == null
                        ? l10n.allCategories
                        : category.localizedName(isArabic: isArabic);
                    final rawDescription = category == null
                        ? null
                        : (isArabic
                              ? category.arabicDescription
                              : category.englishDescription);
                    final subtitle =
                        (rawDescription != null &&
                            rawDescription.trim().isNotEmpty)
                        ? rawDescription.trim()
                        : null;

                    return _CategoryGridCard(
                      title: title,
                      subtitle: subtitle,
                      isSelected: isSelected,
                      textTheme: textTheme,
                      colorScheme: colorScheme,
                      onTap: () {
                        widget.onCategorySelected(category?.id);
                        BottomSheetHelper.dismiss();
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _CategoryGridCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isSelected;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _CategoryGridCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.textTheme,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MyCard.bordered(
      color: isSelected
          ? colorScheme.primary.withValues(alpha: 0.1)
          : colorScheme.surfaceContainerLow,
      borderColor: isSelected
          ? colorScheme.primary.withValues(alpha: 0.4)
          : Colors.transparent,
      borderRadius: context.brXl,
      padding: context.insetsAllM,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: subtitle != null ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
          if (subtitle != null) ...[
            context.verticalSpace(4),
            Text(
              subtitle!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
