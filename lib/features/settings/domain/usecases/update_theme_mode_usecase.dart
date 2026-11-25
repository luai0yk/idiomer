import 'package:flutter/material.dart';
import 'package:idiomer/features/settings/domain/repositories/settings_repository.dart';

class UpdateThemeModeUseCase {
  final SettingsRepository _repository;

  const UpdateThemeModeUseCase(this._repository);

  Future<void> call(ThemeMode themeMode) =>
      _repository.saveThemeMode(themeMode);
}
