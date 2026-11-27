import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/settings_helper.dart';
import 'package:idiomer/core/utils/helpers/ui/toast_helper.dart';
import 'package:idiomer/features/idioms/presentation/widgets/select_category_sheet.dart';
import 'package:idiomer/features/reminders/presentation/cubit/idiom_reminder_cubit.dart';
import 'package:idiomer/features/reminders/presentation/cubit/idiom_reminder_state.dart';
import 'package:idiomer/features/reminders/presentation/widgets/reminder_category_card.dart';
import 'package:idiomer/features/reminders/presentation/widgets/reminder_schedule_section.dart';
import 'package:idiomer/features/reminders/presentation/widgets/reminder_summary_card.dart';
import 'package:idiomer/features/settings/presentation/widgets/setting_icon_badge.dart';
import 'package:idiomer/shared/widgets/appbars/my_gradient_header.dart';
import 'package:idiomer/shared/widgets/buttons/my_button.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_loading_state.dart';
import 'package:idiomer/shared/widgets/misc/my_toast.dart';
import 'package:idiomer/shared/widgets/tiles/my_switch_tile.dart';

class IdiomReminderPage extends StatelessWidget {
  const IdiomReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final extendedColors = context.extendedColors;

    return BlocConsumer<IdiomReminderCubit, IdiomReminderState>(
      listenWhen: (prev, curr) => prev.feedbackId != curr.feedbackId,
      listener: _handleFeedback,
      builder: (context, state) {
        final cubit = context.read<IdiomReminderCubit>();

        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: ScrollUnderHeaderColumn(
            headerBuilder: (context, showBottomBorder) => MyGradientHeader(
              title: l10n.idiomReminder,
              withLeading: true,
              showBottomBorder: showBottomBorder,
            ),
            body: state.status == IdiomReminderStatus.loading
                ? Center(child: MyLoadingState(label: l10n.loading))
                : ListView(
                    padding: EdgeInsets.fromLTRB(
                      context.spaceM,
                      context.spaceS,
                      context.spaceM,
                      context.spaceXl,
                    ),
                    children: [
                      MyCard.filled(
                        color: colorScheme.surfaceContainer,
                        borderRadius: context.brXl,
                        padding: EdgeInsets.zero,
                        child: MySwitchTile(
                          title: l10n.enableReminder,
                          subtitle: l10n.enableReminderSubtitle,
                          value: state.isEnabled,
                          secondary: SettingIconBadge(
                            icon: AppIcons.notifications,
                            color: state.isEnabled
                                ? extendedColors.success.color
                                : colorScheme.onSurfaceVariant,
                          ),
                          onChanged: (value) {
                            cubit.setEnabled(value);
                            if (value &&
                                state.categoryId == null &&
                                state.categories.isNotEmpty) {
                              _openCategoryPicker(context, state);
                            }
                          },
                        ),
                      ),
                      context.verticalSpace(12),
                      ReminderCategoryCard(
                        selectedCategory: state.selectedCategory,
                        hasError: state.categoryError,
                        onTap: () => _openCategoryPicker(context, state),
                      ),
                      context.verticalSpace(20),
                      ReminderScheduleSection(
                        cadence: state.cadence,
                        times: state.times,
                        weekdays: state.weekdays,
                        onFrequencyChanged: cubit.changeFrequency,
                        onTimesPerPeriodChanged: cubit.changeTimesPerPeriod,
                        onWeekdayToggled: cubit.toggleWeekday,
                        onTimeChanged: cubit.updateTimeAt,
                      ),
                      context.verticalSpace(20),
                      ReminderSummaryCard(
                        settings: state.toSettings(),
                        category: state.selectedCategory,
                      ),
                    ],
                  ),
          ),
          bottomNavigationBar: state.status == IdiomReminderStatus.loading
              ? null
              : SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.spaceM,
                      context.spaceS,
                      context.spaceM,
                      context.spaceM,
                    ),
                    child: MyButton.primary(
                      text: l10n.saveReminder,
                      prefixIcon: AppIcons.check,
                      isDisabled: state.status == IdiomReminderStatus.saving,
                      autoLoading: false,
                      onPressed: () => cubit.save(
                        showTranslation: SettingsHelper.readShowTranslation(
                          context,
                        ),
                        channelName: l10n.reminderChannelName,
                        channelDescription: l10n.reminderChannelDescription,
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  void _openCategoryPicker(BuildContext context, IdiomReminderState state) {
    if (state.categories.isEmpty) return;
    SelectCategorySheet.show(
      context,
      categories: state.categories,
      selectedCategoryId: state.categoryId,
      includeAllOption: false,
      onCategorySelected: (categoryId) {
        if (categoryId != null) {
          context.read<IdiomReminderCubit>().selectCategory(categoryId);
        }
      },
    );
  }

  void _handleFeedback(BuildContext context, IdiomReminderState state) {
    final feedback = state.feedback;
    if (feedback == null) return;

    final l10n = context.l10n;
    final (String msg, ToastStatus status) = _resolveFeedbackToast(
      l10n,
      feedback,
      state.cadence.timesPerPeriod,
    );
    ToastHelper.show(msg: msg, status: status);
  }

  (String, ToastStatus) _resolveFeedbackToast(
    AppLocalizations l10n,
    IdiomReminderFeedback feedback,
    int requiredWeekdays,
  ) {
    return switch (feedback) {
      IdiomReminderFeedback.saved => (l10n.reminderSaved, ToastStatus.success),
      IdiomReminderFeedback.disabled => (
        l10n.reminderDisabledMessage,
        ToastStatus.info,
      ),
      IdiomReminderFeedback.categoryRequired => (
        l10n.reminderCategoryRequiredError,
        ToastStatus.warning,
      ),
      IdiomReminderFeedback.weekdaysRequired => (
        l10n.reminderWeekdaysRequiredError(requiredWeekdays),
        ToastStatus.warning,
      ),
      IdiomReminderFeedback.duplicateTimes => (
        l10n.reminderDuplicateTimesError,
        ToastStatus.warning,
      ),
      IdiomReminderFeedback.permissionDenied => (
        l10n.reminderPermissionDenied,
        ToastStatus.danger,
      ),
      IdiomReminderFeedback.noIdiomsInCategory => (
        l10n.reminderNoIdiomsInCategory,
        ToastStatus.warning,
      ),
      IdiomReminderFeedback.saveError => (
        l10n.loadErrorTitle,
        ToastStatus.danger,
      ),
    };
  }
}
