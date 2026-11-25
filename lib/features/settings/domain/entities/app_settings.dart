import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:idiomer/app/l10n/app_locales.dart';

class AppSettings extends Equatable {
  final ThemeMode themeMode;
  final LangCode langCode;

  const AppSettings({required this.themeMode, required this.langCode});

  @override
  List<Object?> get props => [themeMode, langCode];
}
