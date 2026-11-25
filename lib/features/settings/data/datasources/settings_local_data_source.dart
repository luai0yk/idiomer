import 'package:flutter/material.dart';
import 'package:idiomer/app/l10n/app_locales.dart';
import 'package:idiomer/core/services/cash/cash_keys.dart';
import 'package:idiomer/core/services/cash/cash_service.dart';

abstract interface class SettingsLocalDataSource {
  ThemeMode getThemeMode();
  Future<void> saveThemeMode(ThemeMode themeMode);
  LangCode getLanguage();
  Future<void> saveLanguage(LangCode langCode);
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
}
