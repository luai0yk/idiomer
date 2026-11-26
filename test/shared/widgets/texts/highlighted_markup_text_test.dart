import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/presentation/utils/idiom_share_formatter.dart';
import 'package:idiomer/shared/widgets/texts/highlighted_markup_text.dart';

void main() {
  group('HighlightedMarkupText.stripMarkers', () {
    test('removes single and multiple **...** markers', () {
      expect(
        HighlightedMarkupText.stripMarkers(
          'We had to **bite the bullet** and cut our marketing budget this quarter.',
        ),
        'We had to bite the bullet and cut our marketing budget this quarter.',
      );
      expect(
        HighlightedMarkupText.stripMarkers('**First** and **second** idioms.'),
        'First and second idioms.',
      );
    });

    test('preserves unmatched asterisks and plain text', () {
      expect(
        HighlightedMarkupText.stripMarkers('Plain *single* or **unclosed'),
        'Plain *single* or **unclosed',
      );
    });
  });

  group('HighlightedMarkupText widget', () {
    testWidgets('renders highlighted spans without ** markers', (
      tester,
    ) async {
      const highlightColor = Colors.deepOrange;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HighlightedMarkupText(
              'We had to **bite the bullet** and cut our budget.',
              highlightColor: highlightColor,
            ),
          ),
        ),
      );

      expect(
        find.text(
          'We had to bite the bullet and cut our budget.',
          findRichText: true,
        ),
        findsOneWidget,
      );
      expect(find.textContaining('**', findRichText: true), findsNothing);

      final richText = tester.widget<Text>(find.byType(Text));
      final rootSpan = richText.textSpan! as TextSpan;
      final children = rootSpan.children!.cast<TextSpan>();

      expect(children.map((span) => span.text), [
        'We had to ',
        'bite the bullet',
        ' and cut our budget.',
      ]);
      expect(children[1].style?.color, highlightColor);
      expect(children[1].style?.fontWeight, FontWeight.w800);
    });

    testWidgets('renders plain Text when no markup is present', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: HighlightedMarkupText('No markup here.')),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.data, 'No markup here.');
    });
  });

  group('IdiomShareFormatter', () {
    test('strips **...** markers from definitions and examples', () {
      const idiom = IdiomDetailEntity(
        id: 1,
        englishText: 'bite the bullet',
        arabicText: 'يتحمل المشقة',
        categories: [],
        isFavorite: false,
        definitions: [
          IdiomDefinitionEntity(
            id: 1,
            displayOrder: 1,
            englishMeaning:
                'To **bite the bullet** means to face difficulty bravely.',
            arabicMeaning: 'أن **تتحمل الصعاب** بشجاعة.',
          ),
        ],
        examples: [
          IdiomExampleEntity(
            id: 1,
            displayOrder: 1,
            englishSentence: 'We had to **bite the bullet** and cut costs.',
            arabicSentence: 'كان علينا أن **نتحمل المشقة** ونخفض التكاليف.',
          ),
        ],
      );

      final formatted = IdiomShareFormatter.format(idiom);

      expect(formatted.contains('**'), isFalse);
      expect(
        formatted,
        contains('- To bite the bullet means to face difficulty bravely.'),
      );
      expect(formatted, contains('• We had to bite the bullet and cut costs.'));
    });
  });
}
