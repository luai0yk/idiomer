import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/app/di/injection.dart';
import 'package:idiomer/features/favorites/presentation/pages/favorites_page.dart';
import 'package:idiomer/features/flashcards/presentation/pages/flashcards_page.dart';
import 'package:idiomer/features/idioms/presentation/pages/idioms_page.dart';
import 'package:idiomer/features/settings/presentation/pages/settings_page.dart';
import 'package:idiomer/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    await sl.reset();
    SharedPreferences.setMockInitialValues({});
    await initDependencies();
  });

  testWidgets('App mounts with four main tabs and switches between them', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(IdiomsPage), findsOneWidget);
    expect(find.text('No Idioms Yet'), findsOneWidget);

    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.byType(FavoritesPage), findsOneWidget);
    expect(find.text('No Favorites Yet'), findsOneWidget);

    await tester.tap(find.text('Flashcards'));
    await tester.pumpAndSettle();
    expect(find.byType(FlashcardsPage), findsOneWidget);
    expect(find.text('No Flashcards Yet'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);

    // Changing theme keeps user on Settings tab and updates the displayed mode.
    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsPage), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
  });
}
