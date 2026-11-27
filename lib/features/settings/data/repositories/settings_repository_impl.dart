import 'package:flutter/material.dart';
import 'package:idiomer/app/l10n/app_locales.dart';
import 'package:idiomer/core/services/tts/tts_service.dart';
import 'package:idiomer/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:idiomer/features/settings/domain/entities/app_settings.dart';
import 'package:idiomer/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _localDataSource;

  const SettingsRepositoryImpl({
    required SettingsLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  @override
  AppSettings getSettings() {
    return AppSettings(
      themeMode: _localDataSource.getThemeMode(),
      langCode: _localDataSource.getLanguage(),
      showTranslation: _localDataSource.getShowTranslation(),
      idiomTapAction: _localDataSource.getIdiomTapAction(),
      defaultTab: _localDataSource.getDefaultTab(),
      ttsAccent: _localDataSource.getTtsAccent(),
      ttsVoiceName: _localDataSource.getTtsVoiceName(),
      ttsVoiceLocale: _localDataSource.getTtsVoiceLocale(),
      ttsSpeechRate: _localDataSource.getTtsSpeechRate(),
    );
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) {
    return _localDataSource.saveThemeMode(themeMode);
  }

  @override
  Future<void> saveLanguage(LangCode langCode) {
    return _localDataSource.saveLanguage(langCode);
  }

  @override
  Future<void> saveShowTranslation(bool showTranslation) {
    return _localDataSource.saveShowTranslation(showTranslation);
  }

  @override
  Future<void> saveIdiomTapAction(IdiomTapAction action) {
    return _localDataSource.saveIdiomTapAction(action);
  }

  @override
  Future<void> saveDefaultTab(DefaultAppTab tab) {
    return _localDataSource.saveDefaultTab(tab);
  }

  @override
  Future<void> saveTtsAccent(TtsAccent accent) {
    return _localDataSource.saveTtsAccent(accent);
  }

  @override
  Future<void> saveTtsVoice(TtsVoiceOption? voice) {
    return _localDataSource.saveTtsVoice(voice);
  }

  @override
  Future<void> saveTtsSpeechRate(double speechRate) {
    return _localDataSource.saveTtsSpeechRate(speechRate);
  }
}
