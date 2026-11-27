import 'package:equatable/equatable.dart';

enum ReminderFrequency { daily, weekly }

enum ReminderCadence {
  dailyOnce(frequency: ReminderFrequency.daily, timesPerPeriod: 1),
  dailyTwice(frequency: ReminderFrequency.daily, timesPerPeriod: 2),
  weeklyOnce(frequency: ReminderFrequency.weekly, timesPerPeriod: 1),
  weeklyTwice(frequency: ReminderFrequency.weekly, timesPerPeriod: 2),
  weeklyThreeTimes(frequency: ReminderFrequency.weekly, timesPerPeriod: 3);

  final ReminderFrequency frequency;
  final int timesPerPeriod;

  const ReminderCadence({
    required this.frequency,
    required this.timesPerPeriod,
  });

  bool get isDaily => frequency == ReminderFrequency.daily;
  bool get isWeekly => frequency == ReminderFrequency.weekly;

  int get requiredTimeSlots => this == dailyTwice ? 2 : 1;

  List<ReminderTime> get defaultTimes => this == dailyTwice
      ? const [ReminderTime(hour: 9, minute: 0), ReminderTime(hour: 20, minute: 0)]
      : const [ReminderTime(hour: 9, minute: 0)];

  List<int> get defaultWeekdays => switch (this) {
    ReminderCadence.weeklyOnce => const [DateTime.monday],
    ReminderCadence.weeklyTwice => const [DateTime.monday, DateTime.thursday],
    ReminderCadence.weeklyThreeTimes => const [
      DateTime.monday,
      DateTime.wednesday,
      DateTime.friday,
    ],
    _ => const [],
  };

  static ReminderCadence fromFrequencyAndCount(
    ReminderFrequency frequency,
    int count,
  ) {
    switch (frequency) {
      case ReminderFrequency.daily:
        return count >= 2
            ? ReminderCadence.dailyTwice
            : ReminderCadence.dailyOnce;
      case ReminderFrequency.weekly:
        if (count >= 3) return ReminderCadence.weeklyThreeTimes;
        if (count == 2) return ReminderCadence.weeklyTwice;
        return ReminderCadence.weeklyOnce;
    }
  }
}

class ReminderTime extends Equatable implements Comparable<ReminderTime> {
  final int hour;
  final int minute;

  const ReminderTime({required this.hour, required this.minute})
    : assert(hour >= 0 && hour <= 23),
      assert(minute >= 0 && minute <= 59);

  int get totalMinutes => hour * 60 + minute;

  DateTime toTodayDateTime([DateTime? reference]) {
    final now = reference ?? DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  @override
  int compareTo(ReminderTime other) => totalMinutes.compareTo(other.totalMinutes);

  @override
  List<Object?> get props => [hour, minute];
}

class IdiomReminderSettings extends Equatable {
  final bool isEnabled;
  final String? categoryId;
  final String? categoryEnglishName;
  final String? categoryArabicName;
  final ReminderCadence cadence;
  final List<ReminderTime> times;
  final List<int> weekdays;

  const IdiomReminderSettings({
    this.isEnabled = false,
    this.categoryId,
    this.categoryEnglishName,
    this.categoryArabicName,
    this.cadence = ReminderCadence.dailyOnce,
    this.times = const [ReminderTime(hour: 9, minute: 0)],
    this.weekdays = const [],
  });

  bool get hasCategory => categoryId != null && categoryId!.trim().isNotEmpty;

  String localizedCategoryName({required bool isArabic}) {
    if (isArabic) {
      return categoryArabicName ?? categoryEnglishName ?? categoryId ?? '';
    }
    return categoryEnglishName ?? categoryArabicName ?? categoryId ?? '';
  }

  bool get hasValidTimes {
    if (times.length != cadence.requiredTimeSlots) return false;
    if (cadence == ReminderCadence.dailyTwice && times[0] == times[1]) {
      return false;
    }
    return true;
  }

  bool get hasValidWeekdays {
    if (!cadence.isWeekly) return true;
    final unique = weekdays.where((d) => d >= 1 && d <= 7).toSet();
    return unique.length == cadence.timesPerPeriod;
  }

  IdiomReminderSettings copyWith({
    bool? isEnabled,
    Object? categoryId = _sentinel,
    Object? categoryEnglishName = _sentinel,
    Object? categoryArabicName = _sentinel,
    ReminderCadence? cadence,
    List<ReminderTime>? times,
    List<int>? weekdays,
  }) {
    return IdiomReminderSettings(
      isEnabled: isEnabled ?? this.isEnabled,
      categoryId: identical(categoryId, _sentinel)
          ? this.categoryId
          : categoryId as String?,
      categoryEnglishName: identical(categoryEnglishName, _sentinel)
          ? this.categoryEnglishName
          : categoryEnglishName as String?,
      categoryArabicName: identical(categoryArabicName, _sentinel)
          ? this.categoryArabicName
          : categoryArabicName as String?,
      cadence: cadence ?? this.cadence,
      times: times ?? this.times,
      weekdays: weekdays ?? this.weekdays,
    );
  }

  @override
  List<Object?> get props => [
    isEnabled,
    categoryId,
    categoryEnglishName,
    categoryArabicName,
    cadence,
    times,
    weekdays,
  ];
}

const Object _sentinel = Object();
