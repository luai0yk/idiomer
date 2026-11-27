import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/reminders/domain/entities/idiom_reminder_settings.dart';
import 'package:idiomer/features/reminders/presentation/utils/reminder_summary_formatter.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';

class ReminderSummaryCard extends StatelessWidget {
  final IdiomReminderSettings settings;
  final CategoryEntity? category;

  const ReminderSummaryCard({
    super.key,
    required this.settings,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final isReady = settings.isEnabled && settings.hasCategory;
    final summary = ReminderSummaryFormatter.formatScheduleSummary(
      context,
      settings: settings,
      category: category,
    );

    return MyCard.bordered(
      color: isReady
          ? colorScheme.primary.withValues(alpha: 0.08)
          : colorScheme.surfaceContainerLow,
      borderColor: isReady
          ? colorScheme.primary.withValues(alpha: 0.28)
          : colorScheme.outlineVariant.withValues(alpha: 0.4),
      borderRadius: context.brXl,
      padding: context.insetsAllM,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyIcon(
            icon: AppIcons.notifications,
            color: isReady ? colorScheme.primary : colorScheme.onSurfaceVariant,
            size: context.iconM,
          ),
          context.horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.reminderScheduleSummaryTitle,
                  style: textTheme.labelLarge?.copyWith(
                    color: isReady
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                context.verticalSpace(4),
                Text(
                  summary,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
