import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/di/injection.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/reminders/domain/entities/idiom_reminder_settings.dart';
import 'package:idiomer/features/reminders/domain/usecases/get_reminder_settings_usecase.dart';
import 'package:idiomer/features/reminders/presentation/utils/reminder_summary_formatter.dart';
import 'package:idiomer/features/settings/presentation/widgets/setting_icon_badge.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/cards/my_section_card.dart';
import 'package:idiomer/shared/widgets/tiles/my_list_tile.dart';

class SettingsReminderSection extends StatefulWidget {
  const SettingsReminderSection({super.key});

  @override
  State<SettingsReminderSection> createState() =>
      _SettingsReminderSectionState();
}

class _SettingsReminderSectionState extends State<SettingsReminderSection> {
  IdiomReminderSettings _settings = const IdiomReminderSettings();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    if (!sl.isRegistered<GetReminderSettingsUseCase>()) return;
    _settings = sl<GetReminderSettingsUseCase>()();
  }

  Future<void> _openReminderPage() async {
    await context.push(AppRoutes.reminder);
    if (!mounted) return;
    setState(_loadSettings);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final extendedColors = context.extendedColors;

    final isActive = _settings.isEnabled && _settings.hasCategory;

    final subtitle = isActive
        ? ReminderSummaryFormatter.formatScheduleSummary(
            context,
            settings: _settings,
            category: null,
          )
        : l10n.reminderOff;

    return MySectionCard(
      title: l10n.remindersSectionTitle,
      color: Colors.transparent,
      children: [
        MyCard.filled(
          borderRadius: context.brXl,
          padding: EdgeInsets.zero,
          child: MyListTile(
            leading: SettingIconBadge(
              icon: AppIcons.notifications,
              color: isActive
                  ? extendedColors.success.color
                  : colorScheme.primary,
            ),
            borderRadius: context.brXl,
            title: l10n.idiomReminder,
            subtitle: subtitle,
            subtitleColor: isActive
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            trailingIcon: AppIcons.arrowForward(context),
            onTap: _openReminderPage,
          ),
        ),
      ],
    );
  }
}
