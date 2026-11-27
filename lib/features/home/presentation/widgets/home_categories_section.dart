import 'package:flutter/material.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/home/presentation/widgets/home_section_header.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/shared/widgets/chips/animated_chip.dart';

class HomeCategoriesSection extends StatelessWidget {
  final List<CategoryEntity> categories;
  final ValueChanged<CategoryEntity> onTapCategory;
  final VoidCallback onViewAll;

  const HomeCategoriesSection({
    super.key,
    required this.categories,
    required this.onTapCategory,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    final l10n = context.l10n;
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeSectionHeader(
          title: l10n.browseCategories,
          actionText: l10n.viewAll,
          onAction: onViewAll,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: context.insetsHorizontalM,
          child: Row(
            children: [
              for (int i = 0; i < categories.length; i++) ...[
                if (i > 0) context.horizontalSpace(8),
                AnimatedChip(
                  text: categories[i].localizedName(isArabic: isArabic),
                  isSelected: false,
                  onTap: () => onTapCategory(categories[i]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
