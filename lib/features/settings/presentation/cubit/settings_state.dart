import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:idiomer/app/l10n/app_locales.dart';
import 'package:idiomer/core/services/tts/tts_service.dart';
import 'package:idiomer/features/settings/domain/entities/app_settings.dart';

const Object _sentinel = Object();

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final LangCode langCode;
  final bool showTranslation;
  final IdiomTapAction idiomTapAction;
  final DefaultAppTab defaultTab;
  final TtsAccent ttsAccent;
  final String? ttsVoiceName;
  final String? ttsVoiceLocale;
  final double ttsSpeechRate;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.langCode = LangCode.system,
    this.showTranslation = true,
    this.idiomTapAction = IdiomTapAction.details,
    this.defaultTab = DefaultAppTab.home,
    this.ttsAccent = TtsAccent.us,
    this.ttsVoiceName,
    this.ttsVoiceLocale,
    this.ttsSpeechRate = 0.5,
  });

  Locale? get locale =>
      langCode == LangCode.system ? null : Locale(langCode.name);

  SettingsState copyWith({
    ThemeMode? themeMode,
    LangCode? langCode,
    bool? showTranslation,
    IdiomTapAction? idiomTapAction,
    DefaultAppTab? defaultTab,
    TtsAccent? ttsAccent,
    Object? ttsVoiceName = _sentinel,
    Object? ttsVoiceLocale = _sentinel,
    double? ttsSpeechRate,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      langCode: langCode ?? this.langCode,
      showTranslation: showTranslation ?? this.showTranslation,
      idiomTapAction: idiomTapAction ?? this.idiomTapAction,
      defaultTab: defaultTab ?? this.defaultTab,
      ttsAccent: ttsAccent ?? this.ttsAccent,
      ttsVoiceName: identical(ttsVoiceName, _sentinel)
          ? this.ttsVoiceName
          : ttsVoiceName as String?,
      ttsVoiceLocale: identical(ttsVoiceLocale, _sentinel)
          ? this.ttsVoiceLocale
          : ttsVoiceLocale as String?,
      ttsSpeechRate: ttsSpeechRate ?? this.ttsSpeechRate,
    );
  }

  @override
  List<Object?> get props => [
    themeMode,
    langCode,
    showTranslation,
    idiomTapAction,
    defaultTab,
    ttsAccent,
    ttsVoiceName,
    ttsVoiceLocale,
    ttsSpeechRate,
  ];
}
