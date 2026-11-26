import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_constants.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/ui/dialog_helper.dart';
import 'package:idiomer/core/utils/helpers/ui/toast_helper.dart';
import 'package:idiomer/features/flashcards/data/datasources/flashcards_local_datasource.dart';
import 'package:idiomer/shared/widgets/dialogs/my_dialog.dart';
import 'package:idiomer/shared/widgets/input/my_text_field.dart';
import 'package:idiomer/shared/widgets/misc/my_toast.dart';

/// Reusable dialog for creating or renaming a flashcard group.
class FlashcardGroupDialog extends StatefulWidget {
  final String title;
  final String submitLabel;
  final String? initialName;
  final Future<void> Function(String name) onSubmit;

  const FlashcardGroupDialog({
    super.key,
    required this.title,
    required this.submitLabel,
    required this.onSubmit,
    this.initialName,
  });

  static Future<void> showCreate({
    required BuildContext context,
    required Future<void> Function(String name) onCreate,
  }) {
    final l10n = context.l10n;
    return DialogHelper.show(
      child: FlashcardGroupDialog(
        title: l10n.createGroup,
        submitLabel: l10n.create,
        onSubmit: onCreate,
      ),
    );
  }

  static Future<void> showRename({
    required BuildContext context,
    required String currentName,
    required Future<void> Function(String name) onRename,
  }) {
    final l10n = context.l10n;
    return DialogHelper.show(
      child: FlashcardGroupDialog(
        title: l10n.renameGroup,
        submitLabel: l10n.save,
        initialName: currentName,
        onSubmit: onRename,
      ),
    );
  }

  @override
  State<FlashcardGroupDialog> createState() => _FlashcardGroupDialogState();
}

class _FlashcardGroupDialogState extends State<FlashcardGroupDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final l10n = context.l10n;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      await widget.onSubmit(_controller.text.trim());
      if (mounted) {
        DialogHelper.dismiss();
      }
    } on DuplicateFlashcardGroupException {
      ToastHelper.show(
        msg: l10n.groupAlreadyExists,
        status: ToastStatus.warning,
      );
    } catch (_) {
      ToastHelper.show(msg: l10n.loadErrorTitle, status: ToastStatus.danger);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MyDialog(
      title: widget.title,
      statusIcon: AppIcons.flashcards,
      buttonsCanPopAutomatically: false,
      customContent: Form(
        key: _formKey,
        child: Padding(
          padding: context.insetsAllXl,
          child: MyTextField(
            controller: _controller,
            autofocus: true,
            isRequired: true,
            maxLength: AppConstants.maxNameLength,
            labelText: l10n.groupName,
            hintText: l10n.groupNameHint,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleSubmit(),
          ),
        ),
      ),
      primaryButton: DialogButton(
        text: widget.submitLabel,
        onPressed: _handleSubmit,
      ),
      secondaryButton: DialogButton(
        text: l10n.cancel,
        onPressed: DialogHelper.dismiss,
      ),
    );
  }
}
