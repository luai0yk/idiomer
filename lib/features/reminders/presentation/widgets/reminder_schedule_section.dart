import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_durations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/reminders/domain/entities/idiom_reminder_settings.dart';
import 'package:idiomer/features/reminders/presentation/utils/reminder_summary_formatter.dart';
import 'package:idiomer/features/settings/presentation/widgets/setting_icon_badge.dart';
import 'package:idiomer/shared/controller/segment_button_controller.dart';
import 'package:idiomer/shared/widgets/animations/my_animated_fade_switcher.dart';
import 'package:idiomer/shared/widgets/buttons/my_segment_button.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/cards/my_section_card.dart';
import 'package:idiomer/shared/widgets/chips/animated_chip.dart';
import 'package:idiomer/shared/widgets/pickers/my_date_time_picker.dart';
import 'package:idiomer/shared/widgets/tiles/my_list_tile.dart';

class ReminderScheduleSection extends StatefulWidget {
  final ReminderCadence cadence;
  final List<ReminderTime> times;
  final List<int> weekdays;
  final ValueChanged<ReminderFrequency> onFrequencyChanged;
  final ValueChanged<int> onTimesPerPeriodChanged;
  final ValueChanged<int> onWeekdayToggled;
  final void Function(int index, ReminderTime time) onTimeChanged;

  const ReminderScheduleSection({
    super.key,
    required this.cadence,
    required this.times,
    required this.weekdays,
    required this.onFrequencyChanged,
    required this.onTimesPerPeriodChanged,
    required this.onWeekdayToggled,
    required this.onTimeChanged,
  });

  @override
  State<ReminderScheduleSection> createState() =>
      _ReminderScheduleSectionState();
}

class _ReminderScheduleSectionState extends State<ReminderScheduleSection> {
  late final SegmentButtonController<ReminderFrequency> _frequencyController;
  late final SegmentButtonController<int> _countController;

  @override
  void initState() {
    super.initState();
    _frequencyController = SegmentButtonController<ReminderFrequency>(
      initial: widget.cadence.frequency,
    );
    _countController = SegmentButtonController<int>(
      initial: widget.cadence.timesPerPeriod,
    );
  }

  @override
  void didUpdateWidget(covariant ReminderScheduleSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cadence.frequency != _frequencyController.selected) {
      _frequencyController.updateSelection({widget.cadence.frequency});
    }
    if (widget.cadence.timesPerPeriod != _countController.selected) {
      _countController.updateSelection({widget.cadence.timesPerPeriod});
    }
  }

  @override
  void dispose() {
    _frequencyController.dispose();
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final extendedColors = context.extendedColors;

    final isWeekly = widget.cadence.isWeekly;

    return MySectionCard(
      title: l10n.reminderFrequencyTitle,
      color: Colors.transparent,
      children: [
        MyCard.filled(
          color: colorScheme.surfaceContainer,
          borderRadius: context.brXl,
          padding: context.insetsAllM,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MySegmentButton<ReminderFrequency>(
                controller: _frequencyController,
                backgroundColor: colorScheme.surfaceContainerHighest,
                borderRadius: context.brL,
                segments: [
                  MyButtonSegment<ReminderFrequency>(
                    value: ReminderFrequency.daily,
                    label: l10n.daily,
                    icon: AppIcons.sun,
                  ),
                  MyButtonSegment<ReminderFrequency>(
                    value: ReminderFrequency.weekly,
                    label: l10n.weekly,
                    icon: AppIcons.calendar,
                  ),
                ],
                onSelectionChanged: widget.onFrequencyChanged,
              ),
              context.verticalSpace(14),
              Text(
                isWeekly ? l10n.timesPerWeek : l10n.timesPerDay,
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              context.verticalSpace(8),
              MySegmentButton<int>(
                key: ValueKey<ReminderFrequency>(widget.cadence.frequency),
                controller: _countController,
                backgroundColor: colorScheme.surfaceContainerHighest,
                borderRadius: context.brL,
                segments: [
                  MyButtonSegment<int>(value: 1, label: l10n.once),
                  MyButtonSegment<int>(value: 2, label: l10n.twice),
                  if (isWeekly)
                    MyButtonSegment<int>(value: 3, label: l10n.threeTimes),
                ],
                onSelectionChanged: widget.onTimesPerPeriodChanged,
              ),
              AnimatedSize(
                duration: AppDurations.fast,
                curve: Curves.easeInOutCubic,
                child: MyAnimatedFadeSwitcher(
                  child: isWeekly
                      ? _WeekdaySelector(
                          key: const ValueKey('weekday_selector'),
                          requiredCount: widget.cadence.timesPerPeriod,
                          selectedWeekdays: widget.weekdays,
                          onToggleWeekday: widget.onWeekdayToggled,
                        )
                      : const SizedBox.shrink(key: ValueKey('no_weekdays')),
                ),
              ),
            ],
          ),
        ),
        context.verticalSpace(12),
        for (int i = 0; i < widget.times.length; i++) ...[
          if (i > 0) context.verticalSpace(10),
          _ReminderTimeTile(
            title: widget.cadence == ReminderCadence.dailyTwice
                ? (i == 0 ? l10n.firstReminderTime : l10n.secondReminderTime)
                : l10n.reminderTime,
            time: widget.times[i],
            badgeColor: i == 0
                ? extendedColors.info.color
                : extendedColors.warning.color,
            onTap: () {
              MyDateTimePicker.show(
                context: context,
                mode: MyDateBottomPickerMode.time,
                title: widget.cadence == ReminderCadence.dailyTwice
                    ? (i == 0
                          ? l10n.firstReminderTime
                          : l10n.secondReminderTime)
                    : l10n.reminderTime,
                initialDate: widget.times[i].toTodayDateTime(),
                onDateChanged: (picked) {
                  widget.onTimeChanged(
                    i,
                    ReminderTime(hour: picked.hour, minute: picked.minute),
                  );
                },
              );
            },
          ),
        ],
      ],
    );
  }
}

class _WeekdaySelector extends StatelessWidget {
  final int requiredCount;
  final List<int> selectedWeekdays;
  final ValueChanged<int> onToggleWeekday;

  const _WeekdaySelector({
    super.key,
    required this.requiredCount,
    required this.selectedWeekdays,
    required this.onToggleWeekday,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final extendedColors = context.extendedColors;

    final isSatisfied = selectedWeekdays.length == requiredCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        context.verticalSpace(14),
        Text(
          l10n.selectWeekdaysCount(requiredCount, selectedWeekdays.length),
          style: textTheme.labelLarge?.copyWith(
            color: isSatisfied
                ? colorScheme.onSurfaceVariant
                : extendedColors.warning.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        context.verticalSpace(8),
        Wrap(
          spacing: context.spaceS,
          runSpacing: context.spaceS,
          children: [
            for (int day = DateTime.monday; day <= DateTime.sunday; day++)
              AnimatedChip(
                text: ReminderSummaryFormatter.formatWeekdayShort(day),
                isSelected: selectedWeekdays.contains(day),
                onTap: () => onToggleWeekday(day),
              ),
          ],
        ),
      ],
    );
  }
}

class _ReminderTimeTile extends StatelessWidget {
  final String title;
  final ReminderTime time;
  final Color badgeColor;
  final VoidCallback onTap;

  const _ReminderTimeTile({
    required this.title,
    required this.time,
    required this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return MyCard.filled(
      color: colorScheme.surfaceContainer,
      borderRadius: context.brXl,
      padding: EdgeInsets.zero,
      child: MyListTile(
        leading: SettingIconBadge(icon: AppIcons.time, color: badgeColor),
        borderRadius: context.brXl,
        title: title,
        trailing: MyCard.filled(
          color: colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: context.brCircular,
          padding: EdgeInsets.symmetric(
            horizontal: context.spaceM,
            vertical: context.spaceXs,
          ),
          child: Text(
            ReminderSummaryFormatter.formatTime(time),
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
