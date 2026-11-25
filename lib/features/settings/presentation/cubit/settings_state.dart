import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:idiomer/app/l10n/app_locales.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final LangCode langCode;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.langCode = LangCode.system,
  });

  Locale? get locale =>
      langCode == LangCode.system ? null : Locale(langCode.name);

  SettingsState copyWith({
    ThemeMode? themeMode,
    LangCode? langCode,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      langCode: langCode ?? this.langCode,
    );
  }

  @override
  List<Object?> get props => [themeMode, langCode];
}
