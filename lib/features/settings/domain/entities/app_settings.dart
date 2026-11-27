import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:idiomer/app/l10n/app_locales.dart';
import 'package:idiomer/core/services/tts/tts_service.dart';

enum IdiomTapAction { details, share }

enum DefaultAppTab { home, explore, flashcards }

class AppSettings extends Equatable {
  final ThemeMode themeMode;
  final LangCode langCode;
  final bool showTranslation;
  final IdiomTapAction idiomTapAction;
  final DefaultAppTab defaultTab;
  final TtsAccent ttsAccent;
  final String? ttsVoiceName;
  final String? ttsVoiceLocale;
  final double ttsSpeechRate;

  const AppSettings({
    required this.themeMode,
    required this.langCode,
    this.showTranslation = true,
    this.idiomTapAction = IdiomTapAction.details,
    this.defaultTab = DefaultAppTab.home,
    this.ttsAccent = TtsAccent.us,
    this.ttsVoiceName,
    this.ttsVoiceLocale,
    this.ttsSpeechRate = 0.5,
  });

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
