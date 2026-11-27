import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/app/l10n/app_locales.dart';
import 'package:idiomer/core/services/tts/tts_service.dart';
import 'package:idiomer/features/settings/domain/entities/app_settings.dart';
import 'package:idiomer/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:idiomer/features/settings/domain/usecases/update_default_tab_usecase.dart';
import 'package:idiomer/features/settings/domain/usecases/update_idiom_tap_action_usecase.dart';
import 'package:idiomer/features/settings/domain/usecases/update_language_usecase.dart';
import 'package:idiomer/features/settings/domain/usecases/update_show_translation_usecase.dart';
import 'package:idiomer/features/settings/domain/usecases/update_theme_mode_usecase.dart';
import 'package:idiomer/features/settings/domain/usecases/update_tts_accent_usecase.dart';
import 'package:idiomer/features/settings/domain/usecases/update_tts_speech_rate_usecase.dart';
import 'package:idiomer/features/settings/domain/usecases/update_tts_voice_usecase.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUseCase _getSettings;
  final UpdateThemeModeUseCase _updateThemeMode;
  final UpdateLanguageUseCase _updateLanguage;
  final UpdateShowTranslationUseCase _updateShowTranslation;
  final UpdateIdiomTapActionUseCase _updateIdiomTapAction;
  final UpdateDefaultTabUseCase _updateDefaultTab;
  final UpdateTtsAccentUseCase _updateTtsAccent;
  final UpdateTtsVoiceUseCase _updateTtsVoice;
  final UpdateTtsSpeechRateUseCase _updateTtsSpeechRate;

  SettingsCubit({
    required GetSettingsUseCase getSettings,
    required UpdateThemeModeUseCase updateThemeMode,
    required UpdateLanguageUseCase updateLanguage,
    required UpdateShowTranslationUseCase updateShowTranslation,
    required UpdateIdiomTapActionUseCase updateIdiomTapAction,
    required UpdateDefaultTabUseCase updateDefaultTab,
    required UpdateTtsAccentUseCase updateTtsAccent,
    required UpdateTtsVoiceUseCase updateTtsVoice,
    required UpdateTtsSpeechRateUseCase updateTtsSpeechRate,
  }) : _getSettings = getSettings,
       _updateThemeMode = updateThemeMode,
       _updateLanguage = updateLanguage,
       _updateShowTranslation = updateShowTranslation,
       _updateIdiomTapAction = updateIdiomTapAction,
       _updateDefaultTab = updateDefaultTab,
       _updateTtsAccent = updateTtsAccent,
       _updateTtsVoice = updateTtsVoice,
       _updateTtsSpeechRate = updateTtsSpeechRate,
       super(const SettingsState()) {
    loadSettings();
  }

  void loadSettings() {
    final settings = _getSettings();
    emit(
      state.copyWith(
        themeMode: settings.themeMode,
        langCode: settings.langCode,
        showTranslation: settings.showTranslation,
        idiomTapAction: settings.idiomTapAction,
        defaultTab: settings.defaultTab,
        ttsAccent: settings.ttsAccent,
        ttsVoiceName: settings.ttsVoiceName,
        ttsVoiceLocale: settings.ttsVoiceLocale,
        ttsSpeechRate: settings.ttsSpeechRate,
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

  Future<void> changeShowTranslation(bool showTranslation) async {
    if (showTranslation == state.showTranslation) return;
    await _updateShowTranslation(showTranslation);
    if (isClosed) return;
    emit(state.copyWith(showTranslation: showTranslation));
  }

  Future<void> changeIdiomTapAction(IdiomTapAction action) async {
    if (action == state.idiomTapAction) return;
    await _updateIdiomTapAction(action);
    if (isClosed) return;
    emit(state.copyWith(idiomTapAction: action));
  }

  Future<void> changeDefaultTab(DefaultAppTab tab) async {
    if (tab == state.defaultTab) return;
    await _updateDefaultTab(tab);
    if (isClosed) return;
    emit(state.copyWith(defaultTab: tab));
  }

  Future<void> changeTtsAccent(TtsAccent accent) async {
    if (accent == state.ttsAccent) return;
    await _updateTtsAccent(accent);
    // Clear selected voice when switching accents so the new accent applies.
    await _updateTtsVoice(null);
    if (isClosed) return;
    emit(
      state.copyWith(
        ttsAccent: accent,
        ttsVoiceName: null,
        ttsVoiceLocale: null,
      ),
    );
  }

  Future<void> changeTtsVoice(TtsVoiceOption? voice) async {
    if (voice?.name == state.ttsVoiceName &&
        voice?.locale == state.ttsVoiceLocale) {
      return;
    }
    await _updateTtsVoice(voice);
    if (isClosed) return;
    emit(
      state.copyWith(ttsVoiceName: voice?.name, ttsVoiceLocale: voice?.locale),
    );
  }

  Future<void> changeTtsSpeechRate(double speechRate) async {
    final clamped = speechRate.clamp(0.25, 1.0);
    if ((clamped - state.ttsSpeechRate).abs() < 0.001) return;
    await _updateTtsSpeechRate(clamped);
    if (isClosed) return;
    emit(state.copyWith(ttsSpeechRate: clamped));
  }
}
