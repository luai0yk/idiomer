import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/app/theme/material_theme.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_entity.dart';
import 'package:idiomer/features/idioms/presentation/widgets/idiom_card.dart';

void main() {
  testWidgets(
    'IdiomCard renders idiom, translation, highlighted example, and favorite indicator',
    (tester) async {
      var tapped = false;

      const idiom = IdiomEntity(
        id: 1,
        englishText: 'Break a leg',
        arabicText: 'بالتوفيق',
        englishExample: 'Go out there and **break a leg** tonight!',
        isFavorite: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: const MaterialTheme().light(),
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: IdiomCard(idiom: idiom, onTap: () => tapped = true),
            ),
          ),
        ),
      );

      expect(find.text('Break a leg'), findsOneWidget);
      expect(find.text('بالتوفيق'), findsOneWidget);
      expect(find.byIcon(AppIcons.favoriteFilled), findsOneWidget);
      expect(find.byIcon(AppIcons.quoteUp), findsOneWidget);
      expect(
        find.text(
          '"Go out there and break a leg tonight!"',
          findRichText: true,
        ),
        findsOneWidget,
      );
      expect(find.textContaining('**', findRichText: true), findsNothing);

      await tester.tap(find.text('Break a leg'));
      await tester.pump();
      expect(tapped, isTrue);
    },
  );

  testWidgets('IdiomCard omits example and favorite icon when absent', (
    tester,
  ) async {
    const idiom = IdiomEntity(
      id: 2,
      englishText: 'Hit the sack',
      arabicText: 'يذهب للنوم',
      isFavorite: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: const MaterialTheme().light(),
        home: Scaffold(
          body: IdiomCard(idiom: idiom, onTap: () {}),
        ),
      ),
    );

    expect(find.text('Hit the sack'), findsOneWidget);
    expect(find.byIcon(AppIcons.favoriteFilled), findsNothing);
    expect(find.byIcon(AppIcons.quoteUp), findsNothing);
  });
}
