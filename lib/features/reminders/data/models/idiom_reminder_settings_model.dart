import 'package:idiomer/features/reminders/domain/entities/idiom_reminder_settings.dart';

class IdiomReminderSettingsModel {
  final bool isEnabled;
  final String? categoryId;
  final String? categoryEnglishName;
  final String? categoryArabicName;
  final ReminderCadence cadence;
  final List<ReminderTime> times;
  final List<int> weekdays;

  const IdiomReminderSettingsModel({
    required this.isEnabled,
    required this.categoryId,
    this.categoryEnglishName,
    this.categoryArabicName,
    required this.cadence,
    required this.times,
    required this.weekdays,
  });

  factory IdiomReminderSettingsModel.fromEntity(IdiomReminderSettings entity) {
    return IdiomReminderSettingsModel(
      isEnabled: entity.isEnabled,
      categoryId: entity.categoryId,
      categoryEnglishName: entity.categoryEnglishName,
      categoryArabicName: entity.categoryArabicName,
      cadence: entity.cadence,
      times: entity.times,
      weekdays: entity.weekdays,
    );
  }

  factory IdiomReminderSettingsModel.fromJson(Map<String, dynamic> json) {
    final cadenceName = json['cadence'] as String?;
    final cadence = ReminderCadence.values.firstWhere(
      (c) => c.name == cadenceName,
      orElse: () => ReminderCadence.dailyOnce,
    );

    final rawTimes = json['times'];
    final parsedTimes = <ReminderTime>[];
    if (rawTimes is List) {
      for (final item in rawTimes) {
        if (item is Map<String, dynamic>) {
          final hour = (item['hour'] as num?)?.toInt();
          final minute = (item['minute'] as num?)?.toInt();
          if (hour != null &&
              minute != null &&
              hour >= 0 &&
              hour <= 23 &&
              minute >= 0 &&
              minute <= 59) {
            parsedTimes.add(ReminderTime(hour: hour, minute: minute));
          }
        } else if (item is Map) {
          final hour = (item['hour'] as num?)?.toInt();
          final minute = (item['minute'] as num?)?.toInt();
          if (hour != null &&
              minute != null &&
              hour >= 0 &&
              hour <= 23 &&
              minute >= 0 &&
              minute <= 59) {
            parsedTimes.add(ReminderTime(hour: hour, minute: minute));
          }
        }
      }
    }

    final resolvedTimes = parsedTimes.length == cadence.requiredTimeSlots
        ? parsedTimes
        : cadence.defaultTimes;

    final rawWeekdays = json['weekdays'];
    final parsedWeekdays = <int>[];
    if (rawWeekdays is List) {
      for (final day in rawWeekdays) {
        final d = (day as num?)?.toInt();
        if (d != null && d >= 1 && d <= 7 && !parsedWeekdays.contains(d)) {
          parsedWeekdays.add(d);
        }
      }
    }
    parsedWeekdays.sort();

    final resolvedWeekdays = cadence.isWeekly
        ? (parsedWeekdays.length == cadence.timesPerPeriod
              ? parsedWeekdays
              : cadence.defaultWeekdays)
        : const <int>[];

    final rawCategoryId = json['categoryId'] as String?;
    final categoryId =
        (rawCategoryId != null && rawCategoryId.trim().isNotEmpty)
        ? rawCategoryId
        : null;

    return IdiomReminderSettingsModel(
      isEnabled: (json['isEnabled'] as bool?) ?? false,
      categoryId: categoryId,
      categoryEnglishName: json['categoryEnglishName'] as String?,
      categoryArabicName: json['categoryArabicName'] as String?,
      cadence: cadence,
      times: resolvedTimes,
      weekdays: resolvedWeekdays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isEnabled': isEnabled,
      'categoryId': categoryId,
      'categoryEnglishName': categoryEnglishName,
      'categoryArabicName': categoryArabicName,
      'cadence': cadence.name,
      'times': times
          .map((t) => {'hour': t.hour, 'minute': t.minute})
          .toList(growable: false),
      'weekdays': weekdays,
    };
  }

  IdiomReminderSettings toEntity() {
    return IdiomReminderSettings(
      isEnabled: isEnabled,
      categoryId: categoryId,
      categoryEnglishName: categoryEnglishName,
      categoryArabicName: categoryArabicName,
      cadence: cadence,
      times: times,
      weekdays: weekdays,
    );
  }
}
