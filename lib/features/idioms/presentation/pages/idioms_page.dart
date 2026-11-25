import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/appbars/my_app_bar.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';

class IdiomsPage extends StatelessWidget {
  const IdiomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: MyAppBar(title: l10n.idioms, withLeading: false),
      body: Center(
        child: Padding(
          padding: context.insetsAllM,
          child: MyEmptyState(
            icon: AppIcons.idioms,
            title: l10n.noIdiomsTitle,
            subtitle: l10n.noIdiomsSubtitle,
          ),
        ),
      ),
    );
  }
}
