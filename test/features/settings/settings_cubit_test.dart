import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/app/di/injection.dart';
import 'package:idiomer/app/l10n/app_locales.dart';
import 'package:idiomer/core/services/cash/cash_keys.dart';
import 'package:idiomer/core/services/cash/cash_service.dart';
import 'package:idiomer/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:idiomer/features/settings/presentation/cubit/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsCubit', () {
    setUp(() async {
      await sl.reset();
    });

    test('loads defaults when storage is empty', () async {
      SharedPreferences.setMockInitialValues({});
      await initDependencies();

      final cubit = sl<SettingsCubit>();
      expect(
        cubit.state,
        const SettingsState(
          themeMode: ThemeMode.system,
          langCode: LangCode.system,
        ),
      );
      expect(cubit.state.locale, isNull);
      await cubit.close();
    });

    test('loads persisted theme and language values', () async {
      SharedPreferences.setMockInitialValues({
        CashKeys.themeMode: ThemeMode.dark.name,
        CashKeys.languageCode: LangCode.ar.name,
      });
      await initDependencies();

      final cubit = sl<SettingsCubit>();
      expect(cubit.state.themeMode, ThemeMode.dark);
      expect(cubit.state.langCode, LangCode.ar);
      expect(cubit.state.locale, const Locale('ar'));
      await cubit.close();
    });

    test('persists theme and locale updates and clears system locale', () async {
      SharedPreferences.setMockInitialValues({});
      await initDependencies();

      final cubit = sl<SettingsCubit>();
      final cash = sl<CashService>();

      await cubit.changeTheme(ThemeMode.light);
      expect(cubit.state.themeMode, ThemeMode.light);
      expect(cash.getString(CashKeys.themeMode), ThemeMode.light.name);

      await cubit.changeLocale(LangCode.en);
      expect(cubit.state.langCode, LangCode.en);
      expect(cubit.state.locale, const Locale('en'));
      expect(cash.getString(CashKeys.languageCode), LangCode.en.name);

      await cubit.changeLocale(LangCode.system);
      expect(cubit.state.langCode, LangCode.system);
      expect(cubit.state.locale, isNull);
      expect(cash.contains(CashKeys.languageCode), isFalse);

      await cubit.close();
    });
  });
}
