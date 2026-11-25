import 'package:flutter/material.dart';
import 'package:idiomer/app/l10n/app_locales.dart';
import 'package:idiomer/features/settings/domain/entities/app_settings.dart';

abstract interface class SettingsRepository {
  AppSettings getSettings();
  Future<void> saveThemeMode(ThemeMode themeMode);
  Future<void> saveLanguage(LangCode langCode);
}
