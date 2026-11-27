import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/app/di/injection.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/app/theme/material_theme.dart';
import 'package:idiomer/core/utils/helpers/settings_helper.dart';
import 'package:idiomer/core/utils/helpers/ui/app_navigator.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_entity.dart';
import 'package:idiomer/features/idioms/presentation/utils/idiom_tap_helper.dart';
import 'package:idiomer/features/idioms/presentation/widgets/idiom_card.dart';
import 'package:idiomer/features/idioms/presentation/widgets/idiom_share_sheet.dart';
import 'package:idiomer/features/settings/domain/entities/app_settings.dart';
import 'package:idiomer/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:idiomer/features/settings/presentation/pages/settings_page.dart';
import 'package:idiomer/shared/widgets/appbars/my_gradient_header.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/sheets/my_bottom_sheet.dart';
import 'package:idiomer/shared/widgets/tiles/my_expansion_tile.dart';
import 'package:idiomer/shared/widgets/tiles/my_switch_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    await sl.reset();
    SharedPreferences.setMockInitialValues({});
    await initDependencies();
  });

  Widget wrapWithApp({required SettingsCubit cubit, required Widget child}) {
    return BlocProvider<SettingsCubit>.value(
      value: cubit,
      child: MaterialApp(
        navigatorKey: AppNavigator.key,
        theme: const MaterialTheme().light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
  }

  testWidgets(
    'SettingsPage uses MyExpansionTile with square option cards instead of bottom sheets',
    (tester) async {
      final cubit = sl<SettingsCubit>();
      addTearDown(cubit.close);

      await tester.pumpWidget(
        wrapWithApp(cubit: cubit, child: const SettingsPage()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MyGradientHeader), findsOneWidget);
      expect(find.byType(ScrollUnderHeaderColumn), findsOneWidget);
      expect(find.byType(MyExpansionTile), findsNWidgets(4));
      expect(find.byType(MySwitchTile), findsOneWidget);
      expect(find.byType(MyBottomSheet), findsNothing);

      // Expand Theme tile and verify square option cards + MyCard.bordered for selected.
      await tester.tap(find.text('Theme'));
      await tester.pumpAndSettle();

      expect(find.byType(MyBottomSheet), findsNothing);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();
      expect(cubit.state.themeMode, ThemeMode.dark);

      final darkCardFinder = find.ancestor(
        of: find.text('Dark'),
        matching: find.byType(MyCard),
      );
      final darkCard = tester.widget<MyCard>(darkCardFinder.first);
      expect(darkCard.borderColor, isNotNull);

      // Expand Default Tab tile and select Flashcards.
      await tester.ensureVisible(find.text('Default Tab'));
      await tester.tap(find.text('Default Tab'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Flashcards'));
      await tester.tap(find.text('Flashcards'));
      await tester.pumpAndSettle();
      expect(cubit.state.defaultTab, DefaultAppTab.flashcards);
      expect(
        SettingsHelper.routeForDefaultTab(cubit.state.defaultTab),
        AppRoutes.flashcards,
      );

      // Expand Idiom Tap Action tile and select Share Sheet.
      await tester.ensureVisible(find.text('When Tapping an Idiom'));
      await tester.tap(find.text('When Tapping an Idiom'));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, -150));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Share Sheet'));
      await tester.pumpAndSettle();
      expect(cubit.state.idiomTapAction, IdiomTapAction.share);

      // Toggle Show Translation switch.
      await tester.drag(find.byType(ListView), const Offset(0, -150));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Show Translation'));
      await tester.pumpAndSettle();
      expect(cubit.state.showTranslation, isFalse);
    },
  );

  testWidgets('IdiomCard hides DB translation when showTranslation is false', (
    tester,
  ) async {
    final cubit = sl<SettingsCubit>();
    addTearDown(cubit.close);

    const idiom = IdiomEntity(
      id: 1,
      englishText: 'Break the ice',
      arabicText: 'يكسر الجليد',
    );

    await tester.pumpWidget(
      wrapWithApp(
        cubit: cubit,
        child: Scaffold(
          body: IdiomCard(idiom: idiom, onTap: () {}),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('يكسر الجليد'), findsOneWidget);

    await cubit.changeShowTranslation(false);
    await tester.pumpAndSettle();
    expect(find.text('يكسر الجليد'), findsNothing);
    expect(find.text('Break the ice'), findsOneWidget);
  });

  testWidgets(
    'IdiomTapHelper opens IdiomShareSheet when idiomTapAction is share',
    (tester) async {
      final cubit = sl<SettingsCubit>();
      addTearDown(cubit.close);
      await cubit.changeIdiomTapAction(IdiomTapAction.share);

      const detail = IdiomDetailEntity(
        id: 1,
        slug: 'break-the-ice',
        englishText: 'Break the ice',
        arabicText: 'يكسر الجليد',
        definitions: [
          IdiomDefinitionEntity(
            id: 1,
            displayOrder: 1,
            englishMeaning: 'To initiate conversation.',
            arabicMeaning: 'بدء المحادثة.',
          ),
        ],
        examples: [],
        categories: [],
        isFavorite: false,
      );

      await tester.pumpWidget(
        wrapWithApp(
          cubit: cubit,
          child: Builder(
            builder: (context) => Scaffold(
              body: GestureDetector(
                onTap: () => IdiomTapHelper.handleIdiomTap(
                  context,
                  idiomId: detail.id,
                  detail: detail,
                ),
                child: const Text('Open Idiom'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Idiom'));
      await tester.pumpAndSettle();

      expect(find.byType(IdiomShareSheet), findsOneWidget);
    },
  );
}
