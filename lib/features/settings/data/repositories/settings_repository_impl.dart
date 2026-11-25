import 'package:flutter/material.dart';
import 'package:idiomer/app/l10n/app_locales.dart';
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
}
