import 'package:flutter/material.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/formatters/date_time_formatter.dart';
import 'package:idiomer/core/utils/helpers/settings_helper.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/reminders/domain/entities/idiom_reminder_settings.dart';
import 'package:intl/intl.dart';

class ReminderSummaryFormatter {
  ReminderSummaryFormatter._();

  // 2024-01-01 was a Monday, so adding (weekday - 1) days yields exact weekday dates.
  static final DateTime _mondayAnchor = DateTime(2024, 1, 1);

  static String formatWeekdayShort(int weekday) {
    final date = _mondayAnchor.add(Duration(days: weekday - 1));
    return DateFormat.E(SettingsHelper.currentLangCode).format(date);
  }

  static String formatTime(ReminderTime time) {
    return DateTimeFormatter.formatTime(time.toTodayDateTime());
  }

  static String formatScheduleSummary(
    BuildContext context, {
    required IdiomReminderSettings settings,
    required CategoryEntity? category,
  }) {
    final l10n = context.l10n;
    final isArabic = SettingsHelper.isArabic;

    if (!settings.isEnabled || !settings.hasCategory) {
      return l10n.reminderDisabledSummary;
    }

    final categoryName =
        category?.localizedName(isArabic: isArabic) ??
        settings.localizedCategoryName(isArabic: isArabic);

    if (settings.cadence.isDaily) {
      final countLabel = settings.cadence == ReminderCadence.dailyTwice
          ? '${l10n.daily} (${l10n.twice})'
          : '${l10n.daily} (${l10n.once})';
      final timesText = settings.times.map(formatTime).join(' • ');
      return l10n.reminderDailySummary(countLabel, timesText, categoryName);
    }

    final sortedWeekdays = List<int>.from(settings.weekdays)..sort();
    final daysText = sortedWeekdays.map(formatWeekdayShort).join(', ');
    final timeText = settings.times.isNotEmpty
        ? formatTime(settings.times.first)
        : '';

    return l10n.reminderWeeklySummary(daysText, timeText, categoryName);
  }
}
