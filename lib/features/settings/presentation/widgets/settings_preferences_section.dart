import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/app/l10n/app_locales.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/settings_helper.dart';
import 'package:idiomer/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:idiomer/features/settings/presentation/cubit/settings_state.dart';
import 'package:idiomer/features/settings/presentation/widgets/expandable_setting_card.dart';
import 'package:idiomer/shared/widgets/cards/my_section_card.dart';

class SettingsPreferencesSection extends StatelessWidget {
  const SettingsPreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final extendedColors = context.extendedColors;

    return MySectionCard(
      title: l10n.generalSettings,
      color: Colors.transparent,
      children: [
        BlocSelector<SettingsCubit, SettingsState, ThemeMode>(
          selector: (state) => state.themeMode,
          builder: (context, themeMode) {
            return ExpandableSettingCard<ThemeMode>(
              icon: AppIcons.brightness,
              iconColor: extendedColors.warning.color,
              title: l10n.theme,
              selectedLabel: SettingsHelper.getThemeName(context, themeMode),
              selectedValue: themeMode,
              options: [
                SettingOptionItem(
                  value: ThemeMode.system,
                  label: l10n.system,
                  icon: AppIcons.auto,
                ),
                SettingOptionItem(
                  value: ThemeMode.light,
                  label: l10n.light,
                  icon: AppIcons.sun,
                ),
                SettingOptionItem(
                  value: ThemeMode.dark,
                  label: l10n.dark,
                  icon: AppIcons.moon,
                ),
              ],
              onSelect: (value) =>
                  context.read<SettingsCubit>().changeTheme(value),
            );
          },
        ),
        context.verticalSpace(10),
        BlocSelector<SettingsCubit, SettingsState, LangCode>(
          selector: (state) => state.langCode,
          builder: (context, langCode) {
            return ExpandableSettingCard<LangCode>(
              icon: AppIcons.translate,
              iconColor: extendedColors.info.color,
              title: l10n.language,
              selectedLabel: langCode.localizedName(context),
              selectedValue: langCode,
              options: [
                SettingOptionItem(
                  value: LangCode.system,
                  label: l10n.system,
                  icon: AppIcons.globe,
                ),
                SettingOptionItem(
                  value: LangCode.en,
                  label: l10n.english,
                  icon: AppIcons.translate,
                ),
                SettingOptionItem(
                  value: LangCode.ar,
                  label: l10n.arabic,
                  icon: AppIcons.translate,
                ),
              ],
              onSelect: (value) =>
                  context.read<SettingsCubit>().changeLocale(value),
            );
          },
        ),
      ],
    );
  }
}
