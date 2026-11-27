import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/theme/material_theme.dart';
import 'package:idiomer/features/flashcards/presentation/widgets/flashcard_back_card.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';

Widget _buildTestHarness(Widget child) {
  return MaterialApp(
    theme: const MaterialTheme().light(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: SizedBox(
        width: 360,
        height: 480,
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'FlashcardBackCard renders category pill, idiom, translation, meaning, and example panels',
    (tester) async {
      const card = IdiomDetailEntity(
        id: 1,
        englishText: 'Bite the bullet',
        arabicText: 'تقبّل الأمر الصعب',
        isFavorite: false,
        categories: [
          CategoryEntity(
            id: 'courage',
            displayOrder: 1,
            englishName: 'Courage',
            arabicName: 'الشجاعة',
          ),
        ],
        definitions: [
          IdiomDefinitionEntity(
            id: 1,
            displayOrder: 1,
            englishMeaning: 'To face a **difficult** situation bravely.',
            arabicMeaning: 'مواجهة موقف صعب **بشجاعة**.',
          ),
        ],
        examples: [
          IdiomExampleEntity(
            id: 1,
            displayOrder: 1,
            englishSentence:
                'We had to **bite the bullet** and cut our marketing budget.',
            arabicSentence: 'كان علينا أن **نتحمّل المشقة** ونخفض الميزانية.',
          ),
        ],
      );

      await tester.pumpWidget(_buildTestHarness(const FlashcardBackCard(card: card)));

      expect(find.text('Courage'), findsOneWidget);
      expect(find.text('Bite the bullet'), findsOneWidget);
      expect(find.text('تقبّل الأمر الصعب'), findsOneWidget);
      expect(find.text('Meaning'), findsOneWidget);
      expect(find.text('Example'), findsOneWidget);
      expect(
        find.text('To face a difficult situation bravely.', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.text('مواجهة موقف صعب بشجاعة.', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.text(
          '"We had to bite the bullet and cut our marketing budget."',
          findRichText: true,
        ),
        findsOneWidget,
      );
      expect(
        find.text('كان علينا أن نتحمّل المشقة ونخفض الميزانية.', findRichText: true),
        findsOneWidget,
      );
      expect(find.textContaining('**', findRichText: true), findsNothing);

      final englishWidget = tester.widget<Text>(find.text('Bite the bullet'));
      final arabicWidget = tester.widget<Text>(find.text('تقبّل الأمر الصعب'));
      expect(
        englishWidget.style!.fontSize!,
        greaterThan(arabicWidget.style!.fontSize!),
      );

      final badgeCard = tester.widget<MyCard>(
        find
            .ancestor(of: find.text('Courage'), matching: find.byType(MyCard))
            .first,
      );
      expect(badgeCard.borderColor, isNull);

      final cardRect = tester.getRect(find.byType(FlashcardBackCard));
      final badgeRect = tester.getRect(find.text('Courage'));
      final exampleRect = tester.getRect(find.text('Example'));
      expect(badgeRect.top, greaterThan(exampleRect.bottom));
      expect(badgeRect.left - cardRect.left, lessThan(cardRect.right - badgeRect.right));
    },
  );

  testWidgets(
    'FlashcardBackCard omits optional sections cleanly when empty',
    (tester) async {
      const card = IdiomDetailEntity(
        id: 2,
        englishText: 'Break the ice',
        arabicText: '',
        isFavorite: false,
        categories: [],
        definitions: [],
        examples: [],
      );

      await tester.pumpWidget(_buildTestHarness(const FlashcardBackCard(card: card)));

      expect(find.text('Break the ice'), findsOneWidget);
      expect(find.text('Meaning'), findsNothing);
      expect(find.text('Example'), findsNothing);
    },
  );
}
