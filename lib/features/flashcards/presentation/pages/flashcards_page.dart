import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/core/constants/app_constants.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/ui/dialog_helper.dart';
import 'package:idiomer/core/utils/helpers/ui/toast_helper.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/flashcards/presentation/cubit/flashcards_cubit.dart';
import 'package:idiomer/features/flashcards/presentation/cubit/flashcards_state.dart';
import 'package:idiomer/features/flashcards/presentation/widgets/flashcard_group_card.dart';
import 'package:idiomer/features/flashcards/presentation/widgets/flashcard_group_dialog.dart';
import 'package:idiomer/features/flashcards/presentation/widgets/flashcards_header.dart';
import 'package:idiomer/shared/widgets/appbars/my_gradient_header.dart';
import 'package:idiomer/shared/widgets/buttons/my_floating_button.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';
import 'package:idiomer/shared/widgets/dialogs/my_dialog.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';
import 'package:idiomer/shared/widgets/misc/my_loading_state.dart';
import 'package:idiomer/shared/widgets/misc/my_toast.dart';

class FlashcardsPage extends StatelessWidget {
  const FlashcardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      floatingActionButton:
          BlocSelector<FlashcardsCubit, FlashcardsState, bool>(
            selector: (state) =>
                state.status == FlashcardsStatus.loaded &&
                state.groups.isNotEmpty,
            builder: (context, hasGroups) {
              if (!hasGroups) return const SizedBox.shrink();
              return MyFloatingButton(
                icon: AppIcons.add,
                tooltip: l10n.newGroup,
                onPressed: () => _showCreateDialog(context, l10n),
              );
            },
          ),
      body: ScrollUnderHeaderColumn(
        headerBuilder: (context, showBottomBorder) =>
            BlocSelector<FlashcardsCubit, FlashcardsState, bool>(
              selector: (state) => state.groups.isNotEmpty,
              builder: (context, hasGroups) {
                return FlashcardsHeader(
                  title: l10n.flashcards,
                  showBottomBorder: showBottomBorder,
                  trailing: hasGroups
                      ? MyIconButton.ghost(
                          icon: AppIcons.clear,
                          iconColor: colorScheme.primary,
                          tooltip: l10n.clearAll,
                          onPressed: () => _confirmClearAll(context, l10n),
                        )
                      : null,
                );
              },
            ),
        body: BlocBuilder<FlashcardsCubit, FlashcardsState>(
          builder: (context, state) {
            if (state.status == FlashcardsStatus.initial ||
                state.status == FlashcardsStatus.loading) {
              return Center(
                child: MyLoadingState(label: l10n.loadingFlashcards),
              );
            }

            if (state.status == FlashcardsStatus.error) {
              return Center(
                child: MyEmptyState(
                  icon: AppIcons.error,
                  title: l10n.loadErrorTitle,
                  subtitle: l10n.loadErrorSubtitle,
                  actionText: l10n.retry,
                  onAction: () => context.read<FlashcardsCubit>().watchAll(),
                ),
              );
            }

            if (state.groups.isEmpty) {
              return Center(
                child: Padding(
                  padding: context.insetsAllM,
                  child: MyEmptyState(
                    icon: AppIcons.flashcards,
                    title: l10n.noFlashcardsTitle,
                    subtitle: l10n.noFlashcardsSubtitle,
                    actionText: l10n.createGroup,
                    onAction: () => _showCreateDialog(context, l10n),
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.fromLTRB(
                context.spaceM,
                context.spaceS,
                context.spaceM,
                context.spaceXxxl + context.spaceXl,
              ),
              itemCount: state.groups.length,
              separatorBuilder: (_, _) => context.verticalSpace(10),
              itemBuilder: (context, index) {
                final group = state.groups[index];
                return FlashcardGroupCard(
                  group: group,
                  onTap: () {
                    if (group.idiomCount == 0) {
                      ToastHelper.show(
                        msg:
                            '${l10n.noGroupIdiomsTitle}: ${l10n.noGroupIdiomsSubtitle}',
                        longSec: 3,
                        status: ToastStatus.info,
                        preventDuplication: true,
                      );
                      return;
                    }
                    context.push(AppRoutes.flashcardStudyPath(group.id));
                  },
                  onTakeQuiz: group.idiomCount >= AppConstants.quizQuestionCount
                      ? () => context.push(
                          AppRoutes.groupQuizSessionPath(
                            group.id,
                            groupName: group.name,
                          ),
                        )
                      : null,
                  onRename: () => _showRenameDialog(context, group, l10n),
                  onDelete: () => _confirmDeleteGroup(context, group, l10n),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showCreateDialog(BuildContext context, AppLocalizations l10n) {
    final cubit = context.read<FlashcardsCubit>();
    FlashcardGroupDialog.showCreate(
      context: context,
      onCreate: (name) async {
        await cubit.createGroup(name);
        ToastHelper.show(msg: l10n.groupCreated, status: ToastStatus.success);
      },
    );
  }

  void _showRenameDialog(
    BuildContext context,
    FlashcardGroupEntity group,
    AppLocalizations l10n,
  ) {
    final cubit = context.read<FlashcardsCubit>();
    FlashcardGroupDialog.showRename(
      context: context,
      currentName: group.name,
      onRename: (newName) async {
        await cubit.renameGroup(group.id, newName);
        ToastHelper.show(msg: l10n.groupRenamed, status: ToastStatus.success);
      },
    );
  }

  void _confirmDeleteGroup(
    BuildContext context,
    FlashcardGroupEntity group,
    AppLocalizations l10n,
  ) {
    final cubit = context.read<FlashcardsCubit>();
    DialogHelper.show(
      child: MyDialog(
        status: DialogStatus.danger,
        statusIcon: AppIcons.delete,
        title: l10n.deleteGroupTitle,
        content: l10n.deleteGroupMessage(group.name),
        primaryButton: DialogButton(
          text: l10n.delete,
          onPressed: () async {
            await cubit.deleteGroup(group.id);
            ToastHelper.show(msg: l10n.groupDeleted, status: ToastStatus.info);
          },
        ),
        secondaryButton: DialogButton(text: l10n.cancel),
      ),
    );
  }

  void _confirmClearAll(BuildContext context, AppLocalizations l10n) {
    final cubit = context.read<FlashcardsCubit>();
    DialogHelper.show(
      child: MyDialog(
        status: DialogStatus.danger,
        statusIcon: AppIcons.clear,
        title: l10n.clearFlashcardsTitle,
        content: l10n.clearFlashcardsMessage,
        primaryButton: DialogButton(
          text: l10n.clearAll,
          timerSeconds: 10,
          onPressed: () async {
            await cubit.clearAllGroups();
            ToastHelper.show(
              msg: l10n.flashcardsCleared,
              status: ToastStatus.info,
            );
          },
        ),
        secondaryButton: DialogButton(text: l10n.cancel),
      ),
    );
  }
}
