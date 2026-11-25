import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/app/l10n/app_locales.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/settings_helper.dart';
import 'package:idiomer/core/utils/helpers/ui/bottom_sheet_helper.dart';
import 'package:idiomer/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:idiomer/features/settings/presentation/cubit/settings_state.dart';
import 'package:idiomer/shared/widgets/appbars/my_app_bar.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/cards/my_section_card.dart';
import 'package:idiomer/shared/widgets/lists/selectable_list.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';
import 'package:idiomer/shared/widgets/sheets/my_bottom_sheet.dart';
import 'package:idiomer/shared/widgets/tiles/my_list_tile.dart';

class SettingsPage extends StatelessWidget {
  final bool withLeading;

  const SettingsPage({super.key, this.withLeading = false});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final extendedColors = context.extendedColors;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: MyAppBar(title: l10n.settings, withLeading: withLeading),
      body: ListView(
        padding: context.insetsAllM,
        children: [
          MySectionCard(
            title: l10n.generalSettings,
            children: [
              BlocSelector<SettingsCubit, SettingsState, ThemeMode>(
                selector: (state) => state.themeMode,
                builder: (context, themeMode) {
                  return MyListTile(
                    leading: _buildIconContainer(
                      context,
                      AppIcons.brightness,
                      extendedColors.warning.color,
                    ),
                    borderRadius: BorderRadius.zero,
                    title: l10n.theme,
                    subtitle: SettingsHelper.getThemeName(context, themeMode),
                    trailingIcon: AppIcons.arrowForward(context),
                    onTap: () => _showThemeBottomSheet(context, themeMode),
                  );
                },
              ),
              BlocSelector<SettingsCubit, SettingsState, LangCode>(
                selector: (state) => state.langCode,
                builder: (context, langCode) {
                  return MyListTile(
                    leading: _buildIconContainer(
                      context,
                      AppIcons.translate,
                      extendedColors.info.color,
                    ),
                    borderRadius: BorderRadius.zero,
                    title: l10n.language,
                    subtitle: langCode.localizedName(context),
                    trailingIcon: AppIcons.arrowForward(context),
                    onTap: () => _showLanguageBottomSheet(context, langCode),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconContainer(BuildContext context, IconData icon, Color color) {
    return MyCard.filled(
      padding: EdgeInsets.all(context.spaceS),
      color: color.withValues(alpha: 0.15),
      child: MyIcon(icon: icon, color: color),
    );
  }

  void _showThemeBottomSheet(BuildContext context, ThemeMode currentTheme) {
    final l10n = context.l10n;
    final cubit = context.read<SettingsCubit>();

    BottomSheetHelper.show<void>(
      child: MyBottomSheet(
        padding: EdgeInsets.zero,
        title: l10n.selectTheme,
        child: SelectableList<ThemeMode>.single(
          items: const [ThemeMode.system, ThemeMode.light, ThemeMode.dark],
          initialSelected: currentTheme,
          itemLabel: (mode) => SettingsHelper.getThemeName(context, mode),
          onChanged: (value) {
            cubit.changeTheme(value);
            BottomSheetHelper.dismiss();
          },
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context, LangCode currentLang) {
    final l10n = context.l10n;
    final cubit = context.read<SettingsCubit>();

    BottomSheetHelper.show<void>(
      child: MyBottomSheet(
        title: l10n.selectLanguage,
        padding: EdgeInsets.zero,
        child: SelectableList<LangCode>.single(
          items: const [LangCode.system, LangCode.en, LangCode.ar],
          initialSelected: currentLang,
          itemLabel: (code) => code.localizedName(context),
          onChanged: (value) {
            cubit.changeLocale(value);
            BottomSheetHelper.dismiss();
          },
        ),
      ),
    );
  }
}
