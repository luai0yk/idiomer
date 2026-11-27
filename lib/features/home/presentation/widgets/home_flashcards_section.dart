import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/home/presentation/widgets/home_section_header.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';

class HomeFlashcardsSection extends StatelessWidget {
  final List<FlashcardGroupEntity> groups;
  final ValueChanged<FlashcardGroupEntity> onTapGroup;
  final VoidCallback onViewAll;

  const HomeFlashcardsSection({
    super.key,
    required this.groups,
    required this.onTapGroup,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) return const SizedBox.shrink();

    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeSectionHeader(
          title: l10n.continueStudying,
          actionText: l10n.viewAll,
          onAction: onViewAll,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: context.insetsHorizontalM,
          child: Row(
            children: [
              for (int i = 0; i < groups.length; i++) ...[
                if (i > 0) context.horizontalSpace(10),
                SizedBox(
                  width: context.setSize(184),
                  child: _HomeFlashcardDeckCard(
                    group: groups[i],
                    onTap: () => onTapGroup(groups[i]),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeFlashcardDeckCard extends StatelessWidget {
  final FlashcardGroupEntity group;
  final VoidCallback onTap;

  const _HomeFlashcardDeckCard({required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final primary = colorScheme.primary;

    return MyCard.filled(
      borderRadius: context.brXl,
      padding: context.insetsAllM,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: context.setSize(34),
                height: context.setSize(34),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.14),
                  borderRadius: context.brL * 0.85,
                ),
                child: Center(
                  child: MyIcon(
                    icon: AppIcons.flashcardsFilled,
                    color: primary,
                    size: context.iconS,
                  ),
                ),
              ),
              const Spacer(),
              MyIcon(
                icon: AppIcons.arrowForward(context),
                color: colorScheme.onSurfaceVariant,
                size: context.iconS,
              ),
            ],
          ),
          context.verticalSpace(12),
          Text(
            group.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          context.verticalSpace(2),
          Text(
            l10n.idiomsCount(group.idiomCount),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
