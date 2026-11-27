import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:idiomer/app/di/injection.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/app/theme/material_theme.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/services/tts/tts_service.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
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
import 'package:idiomer/features/settings/presentation/widgets/tts_speaker_picker_sheet.dart';
import 'package:idiomer/shared/widgets/appbars/my_gradient_header.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/sheets/my_bottom_sheet.dart';
import 'package:idiomer/shared/widgets/tiles/my_expansion_tile.dart';
import 'package:idiomer/shared/widgets/tiles/my_switch_tile.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockFlutterTts extends Mock implements FlutterTts {}

void main() {
  late _MockFlutterTts mockFlutterTts;
  late TtsService ttsService;
  late int deviceSettingsOpenCount;

  setUp(() async {
    await sl.reset();
    SharedPreferences.setMockInitialValues({});
    deviceSettingsOpenCount = 0;
    mockFlutterTts = _MockFlutterTts();
    when(() => mockFlutterTts.getVoices).thenAnswer(
      (_) async => [
        {'name': 'en-us-x-sfg-local', 'locale': 'en-US'},
        {'name': 'en-gb-x-rjs-local', 'locale': 'en-GB'},
        {'name': 'en-au-x-aub-local', 'locale': 'en-AU'},
        {'name': 'ar-sa-x-ara-local', 'locale': 'ar-SA'},
      ],
    );
    when(() => mockFlutterTts.stop()).thenAnswer((_) async => 1);
    when(() => mockFlutterTts.setLanguage(any())).thenAnswer((_) async => 1);
    when(() => mockFlutterTts.setVoice(any())).thenAnswer((_) async => 1);
    when(() => mockFlutterTts.clearVoice()).thenAnswer((_) async => 1);
    when(() => mockFlutterTts.setSpeechRate(any())).thenAnswer((_) async => 1);
    when(() => mockFlutterTts.speak(any())).thenAnswer((_) async => 1);

    ttsService = TtsService(
      flutterTts: mockFlutterTts,
      openDeviceTtsSettingsHandler: () async {
        deviceSettingsOpenCount++;
        return true;
      },
    );
    sl.registerSingleton<TtsService>(ttsService, dispose: (t) => t.dispose());
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
    'SettingsPage uses MyExpansionTile with square option cards and TTS controls',
    (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final cubit = sl<SettingsCubit>();
      addTearDown(cubit.close);

      await tester.pumpWidget(
        wrapWithApp(cubit: cubit, child: const SettingsPage()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MyGradientHeader), findsOneWidget);
      expect(find.byType(ScrollUnderHeaderColumn), findsOneWidget);
      expect(find.byType(MyExpansionTile), findsWidgets);
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
      await tester.ensureVisible(find.text('Share Sheet'));
      await tester.tap(find.text('Share Sheet'));
      await tester.pumpAndSettle();
      expect(cubit.state.idiomTapAction, IdiomTapAction.share);

      // Toggle Show Translation switch.
      await tester.ensureVisible(find.text('Show Translation'));
      await tester.tap(find.text('Show Translation'));
      await tester.pumpAndSettle();
      expect(cubit.state.showTranslation, isFalse);

      // Scroll to TTS section and test Accent, Voice dropdown, Speed slider, and Sample.
      await tester.scrollUntilVisible(
        find.text('TEXT-TO-SPEECH'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Accent'));
      expect(
        find.ancestor(
          of: find.text('Accent'),
          matching: find.byType(MyExpansionTile),
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Accent'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('UK'));
      await tester.tap(find.text('UK'));
      await tester.pumpAndSettle();
      expect(cubit.state.ttsAccent, TtsAccent.uk);

      // Open Speaker bottom sheet, preview a voice sample, and select it.
      await tester.scrollUntilVisible(
        find.text('Speaker'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Speaker'));
      await tester.pumpAndSettle();

      expect(find.byType(TtsSpeakerPickerSheet), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(TtsSpeakerPickerSheet),
          matching: find.text('Default'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(TtsSpeakerPickerSheet),
          matching: find.byIcon(AppIcons.auto),
        ),
        findsNothing,
      );
      expect(find.text('Voice RJS'), findsOneWidget);
      expect(find.text('en-GB • Offline'), findsOneWidget);
      expect(find.textContaining('ar-SA'), findsNothing);

      // Play sample directly for Voice RJS inside the sheet without closing it.
      await tester.tap(find.byTooltip('Voice Sample').last);
      await tester.pumpAndSettle();
      verify(() => mockFlutterTts.setLanguage('en-GB')).called(1);
      verify(
        () => mockFlutterTts.setVoice({
          'name': 'en-gb-x-rjs-local',
          'locale': 'en-GB',
        }),
      ).called(1);
      verify(
        () => mockFlutterTts.speak(
          'Break the ice and speak English with confidence.',
        ),
      ).called(1);

      await tester.tap(find.text('Voice RJS'));
      await tester.pumpAndSettle();
      expect(cubit.state.ttsVoiceName, 'en-gb-x-rjs-local');
      expect(cubit.state.ttsVoiceLocale, 'en-GB');

      // Verify speed slider supports up to 2.0x (1.0 internal rate).
      await tester.scrollUntilVisible(
        find.text('2.0x'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.min, 0.25);
      expect(slider.max, 1.0);
      final sliderContext = tester.element(find.byType(Slider));
      expect(
        SliderTheme.of(sliderContext).trackHeight,
        sliderContext.setSize(10),
      );

      // Scroll to Voice Sample and tap it.
      await tester.scrollUntilVisible(
        find.text('Voice Sample'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Voice Sample'));
      await tester.pumpAndSettle();

      verify(() => mockFlutterTts.setLanguage('en-GB')).called(1);
      verify(
        () => mockFlutterTts.setVoice({
          'name': 'en-gb-x-rjs-local',
          'locale': 'en-GB',
        }),
      ).called(1);
      verify(
        () => mockFlutterTts.speak(
          'Break the ice and speak English with confidence.',
        ),
      ).called(1);

      // Scroll to Device TTS Settings and tap it.
      await tester.scrollUntilVisible(
        find.text('Device TTS Settings'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Device TTS Settings'));
      await tester.pumpAndSettle();
      expect(deviceSettingsOpenCount, 1);
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
