import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_categories_usecase.dart';
import 'package:idiomer/features/reminders/domain/entities/idiom_reminder_settings.dart';
import 'package:idiomer/features/reminders/domain/repositories/reminders_repository.dart';
import 'package:idiomer/features/reminders/domain/usecases/get_reminder_settings_usecase.dart';
import 'package:idiomer/features/reminders/domain/usecases/save_and_schedule_reminder_usecase.dart';

import 'idiom_reminder_state.dart';

class IdiomReminderCubit extends Cubit<IdiomReminderState> {
  final GetReminderSettingsUseCase _getSettings;
  final SaveAndScheduleReminderUseCase _saveAndSchedule;
  final WatchCategoriesUseCase _watchCategories;

  StreamSubscription<List<CategoryEntity>>? _categoriesSub;

  IdiomReminderCubit({
    required GetReminderSettingsUseCase getSettings,
    required SaveAndScheduleReminderUseCase saveAndSchedule,
    required WatchCategoriesUseCase watchCategories,
  }) : _getSettings = getSettings,
       _saveAndSchedule = saveAndSchedule,
       _watchCategories = watchCategories,
       super(const IdiomReminderState());

  void load() {
    final settings = _getSettings();
    emit(
      state.copyWith(
        status: IdiomReminderStatus.ready,
        isEnabled: settings.isEnabled,
        categoryId: settings.categoryId,
        cadence: settings.cadence,
        times: settings.times,
        weekdays: settings.weekdays,
        categoryError: false,
      ),
    );

    _categoriesSub?.cancel();
    _categoriesSub = _watchCategories().listen(
      (categories) {
        if (isClosed) return;
        emit(state.copyWith(categories: categories));
      },
      onError: (_, _) {
        if (isClosed) return;
        emit(state.copyWith(status: IdiomReminderStatus.ready));
      },
    );
  }

  void setEnabled(bool enabled) {
    emit(
      state.copyWith(
        isEnabled: enabled,
        categoryError: enabled ? state.categoryError : false,
      ),
    );
  }

  void selectCategory(String categoryId) {
    emit(state.copyWith(categoryId: categoryId, categoryError: false));
  }

  void changeFrequency(ReminderFrequency frequency) {
    if (frequency == state.cadence.frequency) return;

    final nextCadence = frequency == ReminderFrequency.daily
        ? ReminderCadence.dailyOnce
        : ReminderCadence.weeklyOnce;
    final baseTime = state.times.isNotEmpty
        ? state.times.first
        : const ReminderTime(hour: 9, minute: 0);

    emit(
      state.copyWith(
        cadence: nextCadence,
        times: [baseTime],
        weekdays: nextCadence.defaultWeekdays,
      ),
    );
  }

  void changeTimesPerPeriod(int count) {
    final nextCadence = ReminderCadence.fromFrequencyAndCount(
      state.cadence.frequency,
      count,
    );
    if (nextCadence == state.cadence) return;

    final firstTime = state.times.isNotEmpty
        ? state.times.first
        : const ReminderTime(hour: 9, minute: 0);

    final List<ReminderTime> nextTimes;
    if (nextCadence == ReminderCadence.dailyTwice) {
      if (state.times.length >= 2) {
        nextTimes = state.times.take(2).toList();
      } else {
        final secondDefault = firstTime.hour < 18
            ? const ReminderTime(hour: 20, minute: 0)
            : const ReminderTime(hour: 9, minute: 0);
        nextTimes = [firstTime, secondDefault];
      }
    } else {
      nextTimes = [firstTime];
    }

    final List<int> nextWeekdays;
    if (nextCadence.isWeekly) {
      final requiredCount = nextCadence.timesPerPeriod;
      final merged = <int>[...state.weekdays];
      for (final fallback in nextCadence.defaultWeekdays) {
        if (merged.length >= requiredCount) break;
        if (!merged.contains(fallback)) {
          merged.add(fallback);
        }
      }
      nextWeekdays = (merged.take(requiredCount).toList()..sort());
    } else {
      nextWeekdays = const [];
    }

    emit(
      state.copyWith(
        cadence: nextCadence,
        times: nextTimes,
        weekdays: nextWeekdays,
      ),
    );
  }

  void toggleWeekday(int weekday) {
    if (!state.cadence.isWeekly || weekday < 1 || weekday > 7) return;

    if (state.cadence == ReminderCadence.weeklyOnce) {
      emit(state.copyWith(weekdays: [weekday]));
      return;
    }

    final requiredCount = state.cadence.timesPerPeriod;
    final next = List<int>.from(state.weekdays);
    if (next.contains(weekday)) {
      next.remove(weekday);
    } else {
      if (next.length >= requiredCount) {
        // Replace the earliest-ordered selection so users can switch days in one tap.
        next.removeAt(0);
      }
      next.add(weekday);
      next.sort();
    }

    emit(state.copyWith(weekdays: next));
  }

  void updateTimeAt(int index, ReminderTime time) {
    if (index < 0 || index >= state.times.length) return;
    final next = List<ReminderTime>.from(state.times);
    next[index] = time;
    emit(state.copyWith(times: next));
  }

  Future<void> save({
    required bool showTranslation,
    required String channelName,
    required String channelDescription,
  }) async {
    final settings = state.toSettings();

    if (settings.isEnabled) {
      if (!settings.hasCategory) {
        emit(
          state.copyWith(
            categoryError: true,
            feedback: IdiomReminderFeedback.categoryRequired,
            feedbackId: state.feedbackId + 1,
          ),
        );
        return;
      }

      if (!settings.hasValidWeekdays) {
        emit(
          state.copyWith(
            feedback: IdiomReminderFeedback.weekdaysRequired,
            feedbackId: state.feedbackId + 1,
          ),
        );
        return;
      }

      if (!settings.hasValidTimes) {
        emit(
          state.copyWith(
            feedback: IdiomReminderFeedback.duplicateTimes,
            feedbackId: state.feedbackId + 1,
          ),
        );
        return;
      }
    }

    emit(state.copyWith(status: IdiomReminderStatus.saving));

    try {
      final outcome = await _saveAndSchedule(
        settings,
        showTranslation: showTranslation,
        channelName: channelName,
        channelDescription: channelDescription,
      );
      if (isClosed) return;

      final feedback = switch (outcome) {
        ReminderScheduleOutcome.scheduled => IdiomReminderFeedback.saved,
        ReminderScheduleOutcome.disabled => IdiomReminderFeedback.disabled,
        ReminderScheduleOutcome.permissionDenied =>
          IdiomReminderFeedback.permissionDenied,
        ReminderScheduleOutcome.noIdiomsInCategory =>
          IdiomReminderFeedback.noIdiomsInCategory,
      };

      emit(
        state.copyWith(
          status: IdiomReminderStatus.ready,
          categoryError: false,
          feedback: feedback,
          feedbackId: state.feedbackId + 1,
        ),
      );
    } catch (_) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: IdiomReminderStatus.ready,
          feedback: IdiomReminderFeedback.saveError,
          feedbackId: state.feedbackId + 1,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _categoriesSub?.cancel();
    return super.close();
  }
}
