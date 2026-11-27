import 'package:equatable/equatable.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/reminders/domain/entities/idiom_reminder_settings.dart';

enum IdiomReminderStatus { loading, ready, saving }

enum IdiomReminderFeedback {
  saved,
  disabled,
  categoryRequired,
  weekdaysRequired,
  duplicateTimes,
  permissionDenied,
  noIdiomsInCategory,
  saveError,
}

const Object _sentinel = Object();

class IdiomReminderState extends Equatable {
  final IdiomReminderStatus status;
  final List<CategoryEntity> categories;
  final bool isEnabled;
  final String? categoryId;
  final ReminderCadence cadence;
  final List<ReminderTime> times;
  final List<int> weekdays;
  final bool categoryError;
  final IdiomReminderFeedback? feedback;
  final int feedbackId;

  const IdiomReminderState({
    this.status = IdiomReminderStatus.loading,
    this.categories = const [],
    this.isEnabled = false,
    this.categoryId,
    this.cadence = ReminderCadence.dailyOnce,
    this.times = const [ReminderTime(hour: 9, minute: 0)],
    this.weekdays = const [],
    this.categoryError = false,
    this.feedback,
    this.feedbackId = 0,
  });

  IdiomReminderSettings toSettings() {
    final category = selectedCategory;
    return IdiomReminderSettings(
      isEnabled: isEnabled,
      categoryId: categoryId,
      categoryEnglishName: category?.englishName,
      categoryArabicName: category?.arabicName,
      cadence: cadence,
      times: times,
      weekdays: weekdays,
    );
  }

  CategoryEntity? get selectedCategory {
    final targetId = categoryId;
    if (targetId == null) return null;
    for (final category in categories) {
      if (category.id == targetId) return category;
    }
    return null;
  }

  IdiomReminderState copyWith({
    IdiomReminderStatus? status,
    List<CategoryEntity>? categories,
    bool? isEnabled,
    Object? categoryId = _sentinel,
    ReminderCadence? cadence,
    List<ReminderTime>? times,
    List<int>? weekdays,
    bool? categoryError,
    Object? feedback = _sentinel,
    int? feedbackId,
  }) {
    return IdiomReminderState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      isEnabled: isEnabled ?? this.isEnabled,
      categoryId: identical(categoryId, _sentinel)
          ? this.categoryId
          : categoryId as String?,
      cadence: cadence ?? this.cadence,
      times: times ?? this.times,
      weekdays: weekdays ?? this.weekdays,
      categoryError: categoryError ?? this.categoryError,
      feedback: identical(feedback, _sentinel)
          ? this.feedback
          : feedback as IdiomReminderFeedback?,
      feedbackId: feedbackId ?? this.feedbackId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    categories,
    isEnabled,
    categoryId,
    cadence,
    times,
    weekdays,
    categoryError,
    feedback,
    feedbackId,
  ];
}
