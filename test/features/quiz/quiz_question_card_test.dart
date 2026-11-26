import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/app/theme/material_theme.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/features/quiz/presentation/widgets/quiz_option_card.dart';
import 'package:idiomer/features/quiz/presentation/widgets/quiz_question_card.dart';

void main() {
  testWidgets(
    'QuizQuestionCard renders prompt, highlighted meaning, and help watermark icons',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: const MaterialTheme().light(),
          home: const Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16),
              child: QuizQuestionCard(
                prompt: 'Which idiom matches this definition?',
                englishMeaning: 'To **bite the bullet** with courage.',
                questionCounterLabel: '1 / 8',
              ),
            ),
          ),
        ),
      );

      expect(
        find.text('Which idiom matches this definition?'),
        findsOneWidget,
      );
      expect(find.text('1 / 8'), findsOneWidget);
      expect(
        find.text('To bite the bullet with courage.', findRichText: true),
        findsOneWidget,
      );
      expect(find.textContaining('**', findRichText: true), findsNothing);
      expect(find.byIcon(AppIcons.help), findsNWidgets(2));
    },
  );

  testWidgets(
    'QuizOptionCard places check icon before text when selected and animates transition',
    (tester) async {
      var selected = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: const MaterialTheme().light(),
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: QuizOptionCard(
                    text: 'Bite the bullet',
                    isSelected: selected,
                    textDirection: TextDirection.ltr,
                    onTap: () => setState(() => selected = !selected),
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.byIcon(AppIcons.checkCircle), findsNothing);

      await tester.tap(find.text('Bite the bullet'));
      await tester.pumpAndSettle();

      final iconFinder = find.byIcon(AppIcons.checkCircle);
      final textFinder = find.text('Bite the bullet');
      expect(iconFinder, findsOneWidget);
      expect(
        tester.getCenter(iconFinder).dx,
        lessThan(tester.getCenter(textFinder).dx),
      );
    },
  );
}
