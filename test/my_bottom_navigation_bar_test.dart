import 'package:flutter/material.dart';
import 'package:idiomer/shared/widgets/misc/my_bottom_navigation_bar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildNavBar({
    int currentIndex = 0,
    ValueChanged<int>? onItemSelected,
    MyBottomNavigationBarItemOrientation orientation =
        MyBottomNavigationBarItemOrientation.horizontal,
    MyBottomNavigationBarDisplayMode displayMode =
        MyBottomNavigationBarDisplayMode.showSelectedTitle,
  }) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: MyBottomNavigationBar(
          currentIndex: currentIndex,
          itemOrientation: orientation,
          displayMode: displayMode,
          onItemSelected: onItemSelected ?? (_) {},
          items: const [
            MyBottomNavigationBarItem(
              title: 'Home',
              icon: Icon(Icons.home, key: ValueKey('icon_home')),
            ),
            MyBottomNavigationBarItem(
              title: 'Search',
              icon: Icon(Icons.search, key: ValueKey('icon_search')),
            ),
            MyBottomNavigationBarItem(
              title: 'Profile',
              icon: Icon(Icons.person, key: ValueKey('icon_profile')),
            ),
          ],
        ),
      ),
    );
  }

  testWidgets(
    'showSelectedTitle shows title on selected and hides on unselected',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildNavBar(
          currentIndex: 0,
          displayMode: MyBottomNavigationBarDisplayMode.showSelectedTitle,
        ),
      );
      await tester.pumpAndSettle();

      // Home is selected (index 0): both text and icon are shown
      expect(find.text('Home'), findsOneWidget);
      expect(find.byKey(const ValueKey('icon_home')), findsOneWidget);

      // Search and Profile are unselected: only icon is shown, text is hidden
      expect(find.text('Search'), findsNothing);
      expect(find.byKey(const ValueKey('icon_search')), findsOneWidget);
      expect(find.text('Profile'), findsNothing);
      expect(find.byKey(const ValueKey('icon_profile')), findsOneWidget);
    },
  );

  testWidgets(
    'hideSelectedTitle hides text of selected item and keeps both for unselected',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildNavBar(
          currentIndex: 0,
          displayMode: MyBottomNavigationBarDisplayMode.hideSelectedTitle,
        ),
      );
      await tester.pumpAndSettle();

      // Home is selected (index 0): Home text is hidden, Home icon is shown
      expect(find.text('Home'), findsNothing);
      expect(find.byKey(const ValueKey('icon_home')), findsOneWidget);

      // Search and Profile are unselected: both text and icon are shown
      expect(find.text('Search'), findsOneWidget);
      expect(find.byKey(const ValueKey('icon_search')), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byKey(const ValueKey('icon_profile')), findsOneWidget);
    },
  );

  testWidgets(
    'hideSelectedIcon hides icon of selected item and keeps both for unselected',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildNavBar(
          currentIndex: 0,
          displayMode: MyBottomNavigationBarDisplayMode.hideSelectedIcon,
        ),
      );
      await tester.pumpAndSettle();

      // Home is selected (index 0): Home text is shown, Home icon is hidden
      expect(find.text('Home'), findsOneWidget);
      expect(find.byKey(const ValueKey('icon_home')), findsNothing);

      // Search and Profile are unselected: both text and icon are shown
      expect(find.text('Search'), findsOneWidget);
      expect(find.byKey(const ValueKey('icon_search')), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byKey(const ValueKey('icon_profile')), findsOneWidget);
    },
  );

  testWidgets(
    'iconToTitle shows icon for unselected and switches to title for selected',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildNavBar(
          currentIndex: 0,
          displayMode: MyBottomNavigationBarDisplayMode.iconToTitle,
        ),
      );
      await tester.pumpAndSettle();

      // Home is selected (index 0): title only
      expect(find.text('Home'), findsOneWidget);
      expect(find.byKey(const ValueKey('icon_home')), findsNothing);

      // Search and Profile are unselected: icon only
      expect(find.text('Search'), findsNothing);
      expect(find.byKey(const ValueKey('icon_search')), findsOneWidget);
      expect(find.text('Profile'), findsNothing);
      expect(find.byKey(const ValueKey('icon_profile')), findsOneWidget);
    },
  );

  testWidgets(
    'horizontal orientation items have a higher default height (>= 64.0)',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildNavBar(
          currentIndex: 0,
          orientation: MyBottomNavigationBarItemOrientation.horizontal,
        ),
      );
      await tester.pumpAndSettle();

      final itemFinder = find.byKey(const ValueKey('icon_home'));
      expect(itemFinder, findsOneWidget);

      final navBarRenderBox = tester.renderObject<RenderBox>(
        find.byType(MyBottomNavigationBar),
      );
      expect(navBarRenderBox.size.height, greaterThanOrEqualTo(64.0));
    },
  );
}
