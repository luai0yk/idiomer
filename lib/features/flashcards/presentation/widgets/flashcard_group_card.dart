import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/shared/widgets/buttons/my_popup_menu.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';

enum _GroupMenuAction { takeQuiz, rename, delete }

class FlashcardGroupCard extends StatelessWidget {
  final FlashcardGroupEntity group;
  final VoidCallback onTap;
  final VoidCallback? onTakeQuiz;
  final VoidCallback? onRename;
  final VoidCallback? onDelete;
  final bool isSelected;
  final bool _showMenu;
  final Widget? trailing;

  const FlashcardGroupCard({
    super.key,
    required this.group,
    required this.onTap,
    this.onTakeQuiz,
    required VoidCallback this.onRename,
    required VoidCallback this.onDelete,
    this.isSelected = false,
    this.trailing,
  }) : _showMenu = true;

  /// Creates a selectable card variant for group pickers without the action menu.
  const FlashcardGroupCard.picker({
    super.key,
    required this.group,
    required this.onTap,
    this.isSelected = false,
    this.trailing,
  }) : onTakeQuiz = null,
       onRename = null,
       onDelete = null,
       _showMenu = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final extendedColors = context.extendedColors;
    final primary = colorScheme.primary;

    return MyCard.filled(
      borderRadius: context.brXl,
      padding: context.insetsAllM,
      color: isSelected
          ? Color.alphaBlend(
              primary.withValues(alpha: 0.08),
              colorScheme.surfaceContainer,
            )
          : null,
      borderColor: isSelected ? primary.withValues(alpha: 0.4) : null,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: context.setSize(44),
            height: context.setSize(44),
            decoration: BoxDecoration(
              color: isSelected ? primary : primary.withValues(alpha: 0.12),
              borderRadius: context.brL,
            ),
            child: Center(
              child: MyIcon(
                icon: AppIcons.flashcardsFilled,
                color: isSelected ? colorScheme.onPrimary : primary,
                size: context.iconM,
              ),
            ),
          ),
          context.horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isSelected ? primary : colorScheme.onSurface,
                  ),
                ),
                context.verticalSpace(4),
                Text(
                  l10n.idiomsCount(group.idiomCount),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else if (_showMenu)
            MyPopupMenu<_GroupMenuAction>(
              items: [
                MyPopupMenuItem(
                  value: _GroupMenuAction.takeQuiz,
                  label: l10n.takeQuiz,
                  icon: AppIcons.help,
                  enabled: onTakeQuiz != null,
                ),
                MyPopupMenuItem(
                  value: _GroupMenuAction.rename,
                  label: l10n.rename,
                  icon: AppIcons.edit,
                ),
                MyPopupMenuItem(
                  value: _GroupMenuAction.delete,
                  label: l10n.delete,
                  icon: AppIcons.delete,
                  color: extendedColors.danger.color,
                ),
              ],
              onSelected: (action) {
                switch (action) {
                  case _GroupMenuAction.takeQuiz:
                    onTakeQuiz?.call();
                  case _GroupMenuAction.rename:
                    onRename?.call();
                  case _GroupMenuAction.delete:
                    onDelete?.call();
                }
              },
            )
          else if (isSelected) ...[
            context.horizontalSpace(8),
            MyIcon(
              icon: AppIcons.checkCircle,
              color: primary,
              size: context.iconM,
            ),
          ],
        ],
      ),
    );
  }
}
