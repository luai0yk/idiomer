import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:idiomer/app/l10n/app_locales.dart';
import 'package:idiomer/features/settings/domain/entities/app_settings.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final LangCode langCode;
  final bool showTranslation;
  final IdiomTapAction idiomTapAction;
  final DefaultAppTab defaultTab;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.langCode = LangCode.system,
    this.showTranslation = true,
    this.idiomTapAction = IdiomTapAction.details,
    this.defaultTab = DefaultAppTab.home,
  });

  Locale? get locale =>
      langCode == LangCode.system ? null : Locale(langCode.name);

  SettingsState copyWith({
    ThemeMode? themeMode,
    LangCode? langCode,
    bool? showTranslation,
    IdiomTapAction? idiomTapAction,
    DefaultAppTab? defaultTab,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      langCode: langCode ?? this.langCode,
      showTranslation: showTranslation ?? this.showTranslation,
      idiomTapAction: idiomTapAction ?? this.idiomTapAction,
      defaultTab: defaultTab ?? this.defaultTab,
    );
  }

  @override
  List<Object?> get props => [
    themeMode,
    langCode,
    showTranslation,
    idiomTapAction,
    defaultTab,
  ];
}
