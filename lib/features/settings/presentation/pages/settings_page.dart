import 'package:flutter/material.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/settings/presentation/widgets/settings_behavior_section.dart';
import 'package:idiomer/features/settings/presentation/widgets/settings_preferences_section.dart';
import 'package:idiomer/features/settings/presentation/widgets/settings_tts_section.dart';
import 'package:idiomer/shared/widgets/appbars/my_gradient_header.dart';

class SettingsPage extends StatelessWidget {
  final bool withLeading;

  const SettingsPage({super.key, this.withLeading = false});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: ScrollUnderHeaderColumn(
        headerBuilder: (context, showBottomBorder) => MyGradientHeader(
          title: l10n.settings,
          withLeading: withLeading,
          showBottomBorder: showBottomBorder,
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            context.spaceM,
            context.spaceS,
            context.spaceM,
            context.spaceXl,
          ),
          children: [
            const SettingsPreferencesSection(),
            context.verticalSpace(20),
            const SettingsBehaviorSection(),
            context.verticalSpace(20),
            const SettingsTtsSection(),
          ],
        ),
      ),
    );
  }
}
