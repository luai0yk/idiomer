import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/settings_helper.dart';
import 'package:idiomer/features/settings/domain/entities/app_settings.dart';
import 'package:idiomer/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:idiomer/features/settings/presentation/cubit/settings_state.dart';
import 'package:idiomer/features/settings/presentation/widgets/expandable_setting_card.dart';
import 'package:idiomer/features/settings/presentation/widgets/setting_icon_badge.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/cards/my_section_card.dart';
import 'package:idiomer/shared/widgets/tiles/my_switch_tile.dart';

class SettingsBehaviorSection extends StatelessWidget {
  const SettingsBehaviorSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final extendedColors = context.extendedColors;

    return MySectionCard(
      title: l10n.behaviorSettings,
      color: Colors.transparent,
      children: [
        BlocSelector<SettingsCubit, SettingsState, DefaultAppTab>(
          selector: (state) => state.defaultTab,
          builder: (context, defaultTab) {
            return ExpandableSettingCard<DefaultAppTab>(
              icon: AppIcons.home,
              iconColor: colorScheme.primary,
              title: l10n.defaultTab,
              selectedLabel: SettingsHelper.getDefaultTabName(
                context,
                defaultTab,
              ),
              selectedValue: defaultTab,
              options: [
                SettingOptionItem(
                  value: DefaultAppTab.home,
                  label: l10n.home,
                  icon: AppIcons.home,
                ),
                SettingOptionItem(
                  value: DefaultAppTab.explore,
                  label: l10n.explore,
                  icon: AppIcons.idioms,
                ),
                SettingOptionItem(
                  value: DefaultAppTab.flashcards,
                  label: l10n.flashcards,
                  icon: AppIcons.flashcards,
                ),
              ],
              onSelect: (value) =>
                  context.read<SettingsCubit>().changeDefaultTab(value),
            );
          },
        ),
        context.verticalSpace(10),
        BlocSelector<SettingsCubit, SettingsState, IdiomTapAction>(
          selector: (state) => state.idiomTapAction,
          builder: (context, action) {
            return ExpandableSettingCard<IdiomTapAction>(
              icon: AppIcons.idioms,
              iconColor: colorScheme.tertiary,
              title: l10n.idiomTapAction,
              selectedLabel: SettingsHelper.getIdiomTapActionName(
                context,
                action,
              ),
              selectedValue: action,
              options: [
                SettingOptionItem(
                  value: IdiomTapAction.details,
                  label: l10n.idiomDetails,
                  icon: AppIcons.idioms,
                ),
                SettingOptionItem(
                  value: IdiomTapAction.share,
                  label: l10n.shareSheetOption,
                  icon: AppIcons.share,
                ),
              ],
              onSelect: (value) =>
                  context.read<SettingsCubit>().changeIdiomTapAction(value),
            );
          },
        ),
        context.verticalSpace(10),
        BlocSelector<SettingsCubit, SettingsState, bool>(
          selector: (state) => state.showTranslation,
          builder: (context, showTranslation) {
            return MyCard.filled(
              borderRadius: context.brXl,
              padding: EdgeInsets.zero,
              child: MySwitchTile(
                title: l10n.showTranslation,
                subtitle: l10n.showTranslationSubtitle,
                value: showTranslation,
                secondary: SettingIconBadge(
                  icon: showTranslation ? AppIcons.eye : AppIcons.eyeSlash,
                  color: extendedColors.success.color,
                ),
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeShowTranslation(value),
              ),
            );
          },
        ),
      ],
    );
  }
}
