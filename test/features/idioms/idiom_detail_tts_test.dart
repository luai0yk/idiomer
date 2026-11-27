import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:idiomer/app/di/injection.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/theme/material_theme.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/services/tts/tts_service.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/presentation/cubit/idiom_detail_cubit.dart';
import 'package:idiomer/features/idioms/presentation/cubit/idiom_detail_state.dart';
import 'package:idiomer/features/idioms/presentation/pages/idiom_detail_page.dart';
import 'package:idiomer/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockFlutterTts extends Mock implements FlutterTts {}

class _FakeIdiomDetailCubit extends Cubit<IdiomDetailState>
    implements IdiomDetailCubit {
  _FakeIdiomDetailCubit(super.initialState);

  @override
  Future<void> watchIdiom(int idiomId) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _MockFlutterTts mockFlutterTts;
  late TtsService ttsService;

  setUp(() async {
    await sl.reset();
    SharedPreferences.setMockInitialValues({});
    mockFlutterTts = _MockFlutterTts();
    when(() => mockFlutterTts.stop()).thenAnswer((_) async => 1);
    when(() => mockFlutterTts.setLanguage(any())).thenAnswer((_) async => 1);
    when(() => mockFlutterTts.setVoice(any())).thenAnswer((_) async => 1);
    when(() => mockFlutterTts.clearVoice()).thenAnswer((_) async => 1);
    when(() => mockFlutterTts.setSpeechRate(any())).thenAnswer((_) async => 1);
    when(() => mockFlutterTts.speak(any())).thenAnswer((_) async => 1);

    ttsService = TtsService(flutterTts: mockFlutterTts);
    sl.registerSingleton<TtsService>(ttsService, dispose: (t) => t.dispose());
    await initDependencies();
  });

  testWidgets(
    'IdiomDetailPage plays TTS for idiom, definition, and example with stripped markers',
    (tester) async {
      final settingsCubit = sl<SettingsCubit>();
      addTearDown(settingsCubit.close);
      await settingsCubit.changeTtsAccent(TtsAccent.uk);
      await settingsCubit.changeTtsSpeechRate(0.6);

      const detail = IdiomDetailEntity(
        id: 7,
        englishText: 'Break the ice',
        arabicText: 'يكسر الجمود',
        definitions: [
          IdiomDefinitionEntity(
            id: 11,
            displayOrder: 1,
            englishMeaning: 'To **make people feel** relaxed.',
            arabicMeaning: 'جعل الناس يشعرون بالراحة.',
          ),
        ],
        examples: [
          IdiomExampleEntity(
            id: 21,
            displayOrder: 1,
            englishSentence: 'He told a joke to **break the ice**.',
            arabicSentence: 'روى نكتة لكسر الجمود.',
          ),
        ],
        categories: [],
        isFavorite: false,
      );

      final detailCubit = _FakeIdiomDetailCubit(
        const IdiomDetailState(
          status: IdiomDetailStatus.loaded,
          idiom: detail,
        ),
      );
      addTearDown(detailCubit.close);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<SettingsCubit>.value(value: settingsCubit),
            BlocProvider<IdiomDetailCubit>.value(value: detailCubit),
          ],
          child: MaterialApp(
            theme: const MaterialTheme().light(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const IdiomDetailPage(idiomId: 7),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final listenButtons = find.byIcon(AppIcons.volume);
      expect(listenButtons, findsNWidgets(3));

      await tester.tap(listenButtons.at(0));
      await tester.pumpAndSettle();
      verify(() => mockFlutterTts.setLanguage('en-GB')).called(1);
      verify(() => mockFlutterTts.setSpeechRate(0.6)).called(1);
      verify(() => mockFlutterTts.speak('Break the ice')).called(1);

      await tester.tap(find.byIcon(AppIcons.volume).first);
      await tester.pumpAndSettle();
      verify(
        () => mockFlutterTts.speak('To make people feel relaxed.'),
      ).called(1);

      await tester.tap(find.byIcon(AppIcons.volume).last);
      await tester.pumpAndSettle();
      verify(
        () => mockFlutterTts.speak('He told a joke to break the ice.'),
      ).called(1);
    },
  );
}
