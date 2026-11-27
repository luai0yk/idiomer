import 'package:flutter/material.dart';
import 'package:idiomer/app/l10n/app_locales.dart';
import 'package:idiomer/core/services/tts/tts_service.dart';
import 'package:idiomer/features/settings/domain/entities/app_settings.dart';

abstract interface class SettingsRepository {
  AppSettings getSettings();
  Future<void> saveThemeMode(ThemeMode themeMode);
  Future<void> saveLanguage(LangCode langCode);
  Future<void> saveShowTranslation(bool showTranslation);
  Future<void> saveIdiomTapAction(IdiomTapAction action);
  Future<void> saveDefaultTab(DefaultAppTab tab);
  Future<void> saveTtsAccent(TtsAccent accent);
  Future<void> saveTtsVoice(TtsVoiceOption? voice);
  Future<void> saveTtsSpeechRate(double speechRate);
}
