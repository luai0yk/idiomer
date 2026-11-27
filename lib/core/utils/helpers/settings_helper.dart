import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/core/services/cash/cash_keys.dart';
import 'package:idiomer/core/services/cash/cash_service.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/features/settings/domain/entities/app_settings.dart';
import 'package:idiomer/features/settings/presentation/cubit/settings_cubit.dart';

class SettingsHelper {
  SettingsHelper._();

  static final CashService _cash = CashService.instance;

  static ThemeMode get currentTheme {
    final String? storedTheme = _cash.getString(CashKeys.themeMode);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == storedTheme,
      orElse: () => ThemeMode.system,
    );
  }

  static String getThemeName(BuildContext context, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return context.l10n.system;
      case ThemeMode.light:
        return context.l10n.light;
      case ThemeMode.dark:
        return context.l10n.dark;
    }
  }

  static Locale get currentLocale {
    final String? storedLang = _cash.getString(CashKeys.languageCode);

    return Locale(
      storedLang ?? PlatformDispatcher.instance.locale.languageCode,
    );
  }

  static String get currentLangCode => currentLocale.languageCode;

  static bool get isArabic => currentLangCode == 'ar';

  static bool get showTranslation =>
      _cash.getBool(CashKeys.showTranslation, defaultValue: true);

  static IdiomTapAction get idiomTapAction {
    final stored = _cash.getString(CashKeys.idiomTapAction);
    return IdiomTapAction.values.firstWhere(
      (action) => action.name == stored,
      orElse: () => IdiomTapAction.details,
    );
  }

  static DefaultAppTab get defaultTab {
    final stored = _cash.getString(CashKeys.defaultTab);
    return DefaultAppTab.values.firstWhere(
      (tab) => tab.name == stored,
      orElse: () => DefaultAppTab.home,
    );
  }

  static String getDefaultTabName(BuildContext context, DefaultAppTab tab) {
    final l10n = context.l10n;
    switch (tab) {
      case DefaultAppTab.home:
        return l10n.home;
      case DefaultAppTab.explore:
        return l10n.explore;
      case DefaultAppTab.flashcards:
        return l10n.flashcards;
    }
  }

  static String getIdiomTapActionName(
    BuildContext context,
    IdiomTapAction action,
  ) {
    final l10n = context.l10n;
    switch (action) {
      case IdiomTapAction.details:
        return l10n.idiomDetails;
      case IdiomTapAction.share:
        return l10n.shareSheetOption;
    }
  }

  static String routeForDefaultTab(DefaultAppTab tab) {
    switch (tab) {
      case DefaultAppTab.home:
        return AppRoutes.home;
      case DefaultAppTab.explore:
        return AppRoutes.idioms;
      case DefaultAppTab.flashcards:
        return AppRoutes.flashcards;
    }
  }

  /// Subscribes to [SettingsCubit] when present, falling back to cached prefs
  /// for isolated widget tests that omit the root cubit.
  static bool watchShowTranslation(BuildContext context) {
    if (context.findAncestorWidgetOfExactType<BlocProvider<SettingsCubit>>() ==
        null) {
      return showTranslation;
    }
    return context.select((SettingsCubit cubit) => cubit.state.showTranslation);
  }

  static IdiomTapAction watchIdiomTapAction(BuildContext context) {
    if (context.findAncestorWidgetOfExactType<BlocProvider<SettingsCubit>>() ==
        null) {
      return idiomTapAction;
    }
    return context.select((SettingsCubit cubit) => cubit.state.idiomTapAction);
  }

  static IdiomTapAction readIdiomTapAction(BuildContext context) {
    if (context.findAncestorWidgetOfExactType<BlocProvider<SettingsCubit>>() ==
        null) {
      return idiomTapAction;
    }
    return context.read<SettingsCubit>().state.idiomTapAction;
  }

  static DefaultAppTab readDefaultTab(BuildContext context) {
    if (context.findAncestorWidgetOfExactType<BlocProvider<SettingsCubit>>() ==
        null) {
      return defaultTab;
    }
    return context.read<SettingsCubit>().state.defaultTab;
  }
}
