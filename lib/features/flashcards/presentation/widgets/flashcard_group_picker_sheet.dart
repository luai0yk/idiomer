import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/ui/bottom_sheet_helper.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/flashcards/presentation/widgets/flashcard_group_card.dart';
import 'package:idiomer/features/flashcards/presentation/widgets/flashcard_group_dialog.dart';
import 'package:idiomer/shared/widgets/buttons/my_button.dart';
import 'package:idiomer/shared/widgets/lists/selectable_list.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';
import 'package:idiomer/shared/widgets/sheets/my_bottom_sheet.dart';

/// Bottom sheet allowing the user to pick an existing flashcard group
/// or create a new group directly.
class FlashcardGroupPickerSheet extends StatelessWidget {
  final String title;
  final List<FlashcardGroupEntity> groups;
  final FlashcardGroupEntity? selectedGroup;
  final Future<void> Function(FlashcardGroupEntity group) onGroupSelected;
  final Future<void> Function(String groupName)? onCreateGroupAndSelect;
  final Future<void> Function()? onRemoveFromGroup;

  const FlashcardGroupPickerSheet({
    super.key,
    required this.title,
    required this.groups,
    this.selectedGroup,
    required this.onGroupSelected,
    this.onCreateGroupAndSelect,
    this.onRemoveFromGroup,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<FlashcardGroupEntity> groups,
    FlashcardGroupEntity? selectedGroup,
    required Future<void> Function(FlashcardGroupEntity group) onGroupSelected,
    Future<void> Function(String groupName)? onCreateGroupAndSelect,
    Future<void> Function()? onRemoveFromGroup,
  }) {
    return BottomSheetHelper.show<void>(
      child: FlashcardGroupPickerSheet(
        title: title,
        groups: groups,
        selectedGroup: selectedGroup,
        onGroupSelected: onGroupSelected,
        onCreateGroupAndSelect: onCreateGroupAndSelect,
        onRemoveFromGroup: onRemoveFromGroup,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final extendedColors = context.extendedColors;
    final effectiveSelectedGroup = selectedGroup == null
        ? null
        : groups.where((g) => g.id == selectedGroup!.id).firstOrNull ??
              selectedGroup;

    return MyBottomSheet(
      title: title,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (groups.isEmpty)
            Padding(
              padding: context.insetsAllM,
              child: MyEmptyState(
                icon: AppIcons.flashcards,
                title: l10n.noOtherGroups,
                subtitle: l10n.noFlashcardsSubtitle,
                size: MyEmptyStateSize.small,
              ),
            )
          else
            Flexible(
              child: SelectableList<FlashcardGroupEntity>.single(
                items: groups,
                initialSelected: effectiveSelectedGroup,
                enableSearch: groups.length > 6,
                separatorHeight: context.spaceS,
                itemLabel: (group) => group.name,
                itemBuilder: (context, group, isSelected, onTap) {
                  return FlashcardGroupCard.picker(
                    group: group,
                    isSelected: isSelected,
                    onTap: onTap,
                  );
                },
                onChanged: (group) async {
                  BottomSheetHelper.dismiss();
                  await onGroupSelected(group);
                },
              ),
            ),
          if (onCreateGroupAndSelect != null || onRemoveFromGroup != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.spaceM,
                context.spaceS,
                context.spaceM,
                context.spaceM,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (onCreateGroupAndSelect != null)
                    MyButton.outlined(
                      text: l10n.createGroup,
                      prefixIcon: AppIcons.add,
                      onPressed: () {
                        BottomSheetHelper.dismiss();
                        FlashcardGroupDialog.showCreate(
                          context: context,
                          onCreate: onCreateGroupAndSelect!,
                        );
                      },
                    ),
                  if (onCreateGroupAndSelect != null &&
                      onRemoveFromGroup != null)
                    context.verticalSpace(8),
                  if (onRemoveFromGroup != null)
                    MyButton.primary(
                      text: l10n.removeFromGroup,
                      prefixIcon: AppIcons.delete,
                      color: extendedColors.danger.color,
                      onPressed: () async {
                        BottomSheetHelper.dismiss();
                        await onRemoveFromGroup!();
                      },
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
