import 'package:flutter/material.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/ui/bottom_sheet_helper.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/lists/selectable_list.dart';
import 'package:idiomer/shared/widgets/sheets/my_bottom_sheet.dart';

/// Bottom sheet displaying all idioms inside a flashcard group, allowing the
/// user to inspect the deck and jump directly to any card.
class FlashcardGroupIdiomsSheet extends StatelessWidget {
  final String title;
  final List<IdiomDetailEntity> cards;
  final int currentIndex;
  final ValueChanged<int> onSelectCard;

  const FlashcardGroupIdiomsSheet({
    super.key,
    required this.title,
    required this.cards,
    required this.currentIndex,
    required this.onSelectCard,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<IdiomDetailEntity> cards,
    required int currentIndex,
    required ValueChanged<int> onSelectCard,
  }) {
    return BottomSheetHelper.show<void>(
      child: FlashcardGroupIdiomsSheet(
        title: title,
        cards: cards,
        currentIndex: currentIndex,
        onSelectCard: onSelectCard,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final enableSearch = cards.length > 6;
    final initialSelected =
        (currentIndex >= 0 && currentIndex < cards.length)
        ? cards[currentIndex]
        : null;
    final cardIndexById = {
      for (var i = 0; i < cards.length; i++) cards[i].id: i,
    };

    return MyBottomSheet(
      title: title,
      padding: EdgeInsets.zero,
      child: SelectableList<IdiomDetailEntity>.single(
        items: cards,
        initialSelected: initialSelected,
        enableSearch: enableSearch,
        searchFilter: (card, query) =>
            card.englishText.toLowerCase().contains(query) ||
            card.arabicText.toLowerCase().contains(query),
        separatorHeight: context.spaceS,
        padding: enableSearch
            ? null
            : EdgeInsets.fromLTRB(
                context.spaceM,
                context.spaceXs,
                context.spaceM,
                context.spaceM,
              ),
        itemLabel: (card) => card.englishText,
        itemBuilder: (context, card, isSelected, onTap) {
          final index = cardIndexById[card.id] ?? 0;
          return _IdiomSheetCard(
            index: index,
            card: card,
            isSelected: isSelected,
            textTheme: textTheme,
            colorScheme: colorScheme,
            onTap: onTap,
          );
        },
        onChanged: (card) {
          final index = cardIndexById[card.id] ?? cards.indexOf(card);
          BottomSheetHelper.dismiss();
          if (index >= 0) {
            onSelectCard(index);
          }
        },
      ),
    );
  }
}

class _IdiomSheetCard extends StatelessWidget {
  final int index;
  final IdiomDetailEntity card;
  final bool isSelected;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _IdiomSheetCard({
    required this.index,
    required this.card,
    required this.isSelected,
    required this.textTheme,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = colorScheme.primary;
    final surface = colorScheme.surfaceContainerLow;

    return MyCard.bordered(
      color: isSelected
          ? Color.alphaBlend(primary.withValues(alpha: 0.08), surface)
          : surface,
      borderColor: isSelected
          ? primary.withValues(alpha: 0.4)
          : Colors.transparent,
      borderRadius: context.brXl,
      padding: context.insetsAllL,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: context.setSize(38),
            height: context.setSize(38),
            decoration: BoxDecoration(
              color: isSelected ? primary : primary.withValues(alpha: 0.12),
              borderRadius: context.brL,
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected ? colorScheme.onPrimary : primary,
              ),
            ),
          ),
          context.horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  card.englishText,
                  textDirection: TextDirection.ltr,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isSelected ? primary : colorScheme.onSurface,
                  ),
                ),
                if (card.arabicText.trim().isNotEmpty) ...[
                  context.verticalSpace(2),
                  Text(
                    card.arabicText,
                    textDirection: TextDirection.rtl,
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: primary.withValues(
                        alpha: isSelected ? 0.95 : 0.85,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
