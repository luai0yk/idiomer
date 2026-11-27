import 'package:flutter/material.dart';
import 'package:idiomer/app/l10n/app_locales.dart';
import 'package:idiomer/core/services/cash/cash_keys.dart';
import 'package:idiomer/core/services/cash/cash_service.dart';
import 'package:idiomer/core/services/tts/tts_service.dart';
import 'package:idiomer/features/settings/domain/entities/app_settings.dart';

abstract interface class SettingsLocalDataSource {
  ThemeMode getThemeMode();
  Future<void> saveThemeMode(ThemeMode themeMode);
  LangCode getLanguage();
  Future<void> saveLanguage(LangCode langCode);
  bool getShowTranslation();
  Future<void> saveShowTranslation(bool showTranslation);
  IdiomTapAction getIdiomTapAction();
  Future<void> saveIdiomTapAction(IdiomTapAction action);
  DefaultAppTab getDefaultTab();
  Future<void> saveDefaultTab(DefaultAppTab tab);
  TtsAccent getTtsAccent();
  Future<void> saveTtsAccent(TtsAccent accent);
  String? getTtsVoiceName();
  String? getTtsVoiceLocale();
  Future<void> saveTtsVoice(TtsVoiceOption? voice);
  double getTtsSpeechRate();
  Future<void> saveTtsSpeechRate(double speechRate);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final CashService _cashService;

  const SettingsLocalDataSourceImpl({required CashService cashService})
    : _cashService = cashService;

  @override
  ThemeMode getThemeMode() {
    final storedTheme = _cashService.getString(CashKeys.themeMode);
    if (storedTheme == null) return ThemeMode.system;
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == storedTheme,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    await _cashService.setString(CashKeys.themeMode, themeMode.name);
  }

  @override
  LangCode getLanguage() {
    final storedLang = _cashService.getString(CashKeys.languageCode);
    if (storedLang == null) return LangCode.system;
    return LangCode.values.firstWhere(
      (code) => code.name == storedLang,
      orElse: () => LangCode.system,
    );
  }

  @override
  Future<void> saveLanguage(LangCode langCode) async {
    if (langCode == LangCode.system) {
      await _cashService.remove(CashKeys.languageCode);
      return;
    }
    await _cashService.setString(CashKeys.languageCode, langCode.name);
  }

  @override
  bool getShowTranslation() {
    return _cashService.getBool(CashKeys.showTranslation, defaultValue: true);
  }

  @override
  Future<void> saveShowTranslation(bool showTranslation) async {
    await _cashService.setBool(CashKeys.showTranslation, showTranslation);
  }

  @override
  IdiomTapAction getIdiomTapAction() {
    final stored = _cashService.getString(CashKeys.idiomTapAction);
    if (stored == null) return IdiomTapAction.details;
    return IdiomTapAction.values.firstWhere(
      (action) => action.name == stored,
      orElse: () => IdiomTapAction.details,
    );
  }

  @override
  Future<void> saveIdiomTapAction(IdiomTapAction action) async {
    await _cashService.setString(CashKeys.idiomTapAction, action.name);
  }

  @override
  DefaultAppTab getDefaultTab() {
    final stored = _cashService.getString(CashKeys.defaultTab);
    if (stored == null) return DefaultAppTab.home;
    return DefaultAppTab.values.firstWhere(
      (tab) => tab.name == stored,
      orElse: () => DefaultAppTab.home,
    );
  }

  @override
  Future<void> saveDefaultTab(DefaultAppTab tab) async {
    await _cashService.setString(CashKeys.defaultTab, tab.name);
  }

  @override
  TtsAccent getTtsAccent() {
    final stored = _cashService.getString(CashKeys.ttsAccent);
    if (stored == null) return TtsAccent.us;
    return TtsAccent.values.firstWhere(
      (accent) => accent.name == stored,
      orElse: () => TtsAccent.us,
    );
  }

  @override
  Future<void> saveTtsAccent(TtsAccent accent) async {
    await _cashService.setString(CashKeys.ttsAccent, accent.name);
  }

  @override
  String? getTtsVoiceName() => _cashService.getString(CashKeys.ttsVoiceName);

  @override
  String? getTtsVoiceLocale() =>
      _cashService.getString(CashKeys.ttsVoiceLocale);

  @override
  Future<void> saveTtsVoice(TtsVoiceOption? voice) async {
    if (voice == null) {
      await _cashService.remove(CashKeys.ttsVoiceName);
      await _cashService.remove(CashKeys.ttsVoiceLocale);
      return;
    }
    await _cashService.setString(CashKeys.ttsVoiceName, voice.name);
    await _cashService.setString(CashKeys.ttsVoiceLocale, voice.locale);
  }

  @override
  double getTtsSpeechRate() {
    final stored = _cashService.getDouble(CashKeys.ttsSpeechRate);
    if (stored == null) return 0.5;
    return stored.clamp(0.25, 1.0);
  }

  @override
  Future<void> saveTtsSpeechRate(double speechRate) async {
    await _cashService.setDouble(
      CashKeys.ttsSpeechRate,
      speechRate.clamp(0.25, 1.0),
    );
  }
}
