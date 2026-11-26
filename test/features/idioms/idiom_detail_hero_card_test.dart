import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/theme/material_theme.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/presentation/widgets/idiom_detail_hero_card.dart';

void main() {
  testWidgets(
    'IdiomDetailHeroCard renders idiom, translation, categories without divider, and copy button',
    (tester) async {
      var copied = false;

      const idiom = IdiomDetailEntity(
        id: 1,
        englishText: 'Spill the beans',
        arabicText: 'يفشي السر',
        categories: [
          CategoryEntity(
            id: 'secrets',
            displayOrder: 1,
            englishName: 'Secrets',
            arabicName: 'الأسرار',
          ),
        ],
        definitions: [],
        examples: [],
        isFavorite: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: const MaterialTheme().light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: IdiomDetailHeroCard(
                idiom: idiom,
                onCopy: () => copied = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Spill the beans'), findsOneWidget);
      expect(find.text('يفشي السر'), findsOneWidget);
      expect(find.text('Secrets'), findsOneWidget);
      expect(find.byType(Divider), findsNothing);
      expect(find.byIcon(AppIcons.quoteUp), findsOneWidget);
      expect(find.byIcon(AppIcons.quoteDown), findsOneWidget);

      await tester.tap(find.byIcon(AppIcons.copy));
      await tester.pump();
      expect(copied, isTrue);
    },
  );
}
