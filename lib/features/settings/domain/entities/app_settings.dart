import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:idiomer/app/l10n/app_locales.dart';

enum IdiomTapAction { details, share }

enum DefaultAppTab { home, explore, flashcards }

class AppSettings extends Equatable {
  final ThemeMode themeMode;
  final LangCode langCode;
  final bool showTranslation;
  final IdiomTapAction idiomTapAction;
  final DefaultAppTab defaultTab;

  const AppSettings({
    required this.themeMode,
    required this.langCode,
    this.showTranslation = true,
    this.idiomTapAction = IdiomTapAction.details,
    this.defaultTab = DefaultAppTab.home,
  });

  @override
  List<Object?> get props => [
    themeMode,
    langCode,
    showTranslation,
    idiomTapAction,
    defaultTab,
  ];
}
