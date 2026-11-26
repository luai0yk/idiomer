import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/features/home/presentation/widgets/idiom_of_the_day_card.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/shared/widgets/buttons/my_favorite_button.dart';

Widget _buildTestHarness(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );
}

void main() {
  testWidgets('IdiomOfTheDayCard renders idiom, highlighted example, category, and actions', (
    tester,
  ) async {
    var tapped = false;
    var favoriteToggled = false;

    const idiom = IdiomDetailEntity(
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
          englishMeaning: 'To face a difficult situation bravely.',
          arabicMeaning: 'مواجهة موقف صعب بشجاعة.',
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

    await tester.pumpWidget(
      _buildTestHarness(
        IdiomOfTheDayCard(
          idiom: idiom,
          onTap: () => tapped = true,
          onToggleFavorite: () => favoriteToggled = true,
        ),
      ),
    );

    expect(find.text('Idiom of the Day'), findsOneWidget);
    expect(find.text('Bite the bullet'), findsOneWidget);
    expect(find.text('تقبّل الأمر الصعب'), findsOneWidget);
    expect(find.text('Example'), findsOneWidget);
    expect(
      find.text(
        '"We had to bite the bullet and cut our marketing budget."',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect(
      find.textContaining('نتحمّل المشقة', findRichText: true),
      findsNothing,
    );
    expect(find.textContaining('**', findRichText: true), findsNothing);
    expect(find.text('Courage'), findsOneWidget);
    expect(find.text('View Details'), findsOneWidget);

    await tester.tap(find.byType(MyFavoriteButton));
    await tester.pump();
    expect(favoriteToggled, isTrue);

    await tester.tap(find.text('Bite the bullet'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('IdiomOfTheDayCard falls back to meaning when examples are empty', (
    tester,
  ) async {
    const idiom = IdiomDetailEntity(
      id: 2,
      englishText: 'Break the ice',
      arabicText: 'يكسر الجمود',
      isFavorite: true,
      categories: [],
      definitions: [
        IdiomDefinitionEntity(
          id: 1,
          displayOrder: 1,
          englishMeaning: 'To make people feel **more relaxed**.',
          arabicMeaning: '',
        ),
      ],
      examples: [],
    );

    await tester.pumpWidget(
      _buildTestHarness(
        IdiomOfTheDayCard(
          idiom: idiom,
          onTap: () {},
          onToggleFavorite: () {},
        ),
      ),
    );

    expect(find.text('Meaning'), findsOneWidget);
    expect(
      find.text('To make people feel more relaxed.', findRichText: true),
      findsOneWidget,
    );
    expect(find.textContaining('**', findRichText: true), findsNothing);
  });
}
