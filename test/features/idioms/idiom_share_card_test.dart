import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/theme/material_theme.dart';
import 'package:idiomer/core/constants/app_assets.dart';
import 'package:idiomer/core/constants/app_constants.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/presentation/widgets/idiom_share_card.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/images/my_image.dart';

void main() {
  testWidgets(
    'IdiomShareCard keeps header category at top, matches editorial styling, and shows footer',
    (tester) async {
      const idiom = IdiomDetailEntity(
        id: 1,
        englishText: 'Break the ice',
        arabicText: 'يكسر الجمود',
        categories: [
          CategoryEntity(
            id: 'social',
            displayOrder: 1,
            englishName: 'Social',
            arabicName: 'اجتماعي',
          ),
        ],
        definitions: [
          IdiomDefinitionEntity(
            id: 1,
            displayOrder: 1,
            englishMeaning: 'To make people feel **more relaxed**.',
            arabicMeaning: 'جعل الناس يشعرون **بالراحة**.',
          ),
        ],
        examples: [
          IdiomExampleEntity(
            id: 1,
            displayOrder: 1,
            englishSentence: 'He told a joke to **break the ice**.',
            arabicSentence: 'روى نكتة **لكسر الجمود**.',
          ),
        ],
        isFavorite: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: const MaterialTheme().light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: Center(child: IdiomShareCard(idiom: idiom)),
          ),
        ),
      );

      expect(find.text('Idiomer'), findsNothing);
      final appLogo = tester.widget<MyImage>(find.byType(MyImage));
      expect(appLogo.assetImage, AppAssets.appIcon);
      expect(find.text('Social'), findsOneWidget);
      expect(find.text('Break the ice'), findsOneWidget);
      expect(find.text('يكسر الجمود'), findsOneWidget);
      expect(find.text('Shared via Idiomer app'), findsOneWidget);
      expect(find.text(AppConstants.appUrl), findsOneWidget);

      final englishWidget = tester.widget<Text>(find.text('Break the ice'));
      final arabicWidget = tester.widget<Text>(find.text('يكسر الجمود'));
      expect(englishWidget.textAlign, TextAlign.center);
      expect(arabicWidget.textAlign, TextAlign.center);
      expect(
        englishWidget.style!.fontSize!,
        greaterThan(arabicWidget.style!.fontSize!),
      );

      final categoryCard = tester.widget<MyCard>(
        find
            .ancestor(of: find.text('Social'), matching: find.byType(MyCard))
            .first,
      );
      expect(categoryCard.borderColor, isNull);

      final categoryRect = tester.getRect(find.text('Social'));
      final idiomRect = tester.getRect(find.text('Break the ice'));
      final footerRect = tester.getRect(find.text('Shared via Idiomer app'));
      expect(categoryRect.bottom, lessThan(idiomRect.top));
      expect(footerRect.top, greaterThan(idiomRect.bottom));
    },
  );
}
