import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/app/l10n/app_locales.dart';
import 'package:idiomer/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:idiomer/features/settings/domain/usecases/update_language_usecase.dart';
import 'package:idiomer/features/settings/domain/usecases/update_theme_mode_usecase.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUseCase _getSettings;
  final UpdateThemeModeUseCase _updateThemeMode;
  final UpdateLanguageUseCase _updateLanguage;

  SettingsCubit({
    required GetSettingsUseCase getSettings,
    required UpdateThemeModeUseCase updateThemeMode,
    required UpdateLanguageUseCase updateLanguage,
  }) : _getSettings = getSettings,
       _updateThemeMode = updateThemeMode,
       _updateLanguage = updateLanguage,
       super(const SettingsState()) {
    loadSettings();
  }

  void loadSettings() {
    final settings = _getSettings();
    emit(
      state.copyWith(
        themeMode: settings.themeMode,
        langCode: settings.langCode,
      ),
    );
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    if (themeMode == state.themeMode) return;
    await _updateThemeMode(themeMode);
    if (isClosed) return;
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> changeLocale(LangCode langCode) async {
    if (langCode == state.langCode) return;
    await _updateLanguage(langCode);
    if (isClosed) return;
    emit(state.copyWith(langCode: langCode));
  }
}
