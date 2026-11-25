import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/appbars/my_app_bar.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';

class FlashcardsPage extends StatelessWidget {
  const FlashcardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: MyAppBar(title: l10n.flashcards, withLeading: false),
      body: Center(
        child: Padding(
          padding: context.insetsAllM,
          child: MyEmptyState(
            icon: AppIcons.flashcards,
            title: l10n.noFlashcardsTitle,
            subtitle: l10n.noFlashcardsSubtitle,
          ),
        ),
      ),
    );
  }
}
