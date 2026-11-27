import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/app/theme/material_theme.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/shared/widgets/buttons/my_popup_menu.dart';

void main() {
  testWidgets(
    'MyPopupMenu clips popup menu Material to its rounded shape so item splashes do not overflow',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: const MaterialTheme().light(),
          home: Scaffold(
            body: Center(
              child: MyPopupMenu<String>(
                items: const [
                  MyPopupMenuItem(value: 'first', label: 'First'),
                  MyPopupMenuItem(value: 'second', label: 'Second'),
                ],
              ),
            ),
          ),
        ),
      );

      final button = tester.widget<PopupMenuButton<String>>(
        find.byType(PopupMenuButton<String>),
      );
      expect(button.clipBehavior, Clip.antiAlias);
      expect(button.menuPadding, EdgeInsets.zero);

      await tester.tap(find.byIcon(AppIcons.more));
      await tester.pumpAndSettle();

      final menuScrollView = tester.widget<SingleChildScrollView>(
        find.ancestor(
          of: find.text('First'),
          matching: find.byType(SingleChildScrollView),
        ),
      );
      expect(menuScrollView.padding, EdgeInsets.zero);

      final menuMaterial = tester.widget<Material>(
        find
            .ancestor(
              of: find.text('First'),
              matching: find.byWidgetPredicate(
                (w) => w is Material && w.type == MaterialType.card,
              ),
            )
            .first,
      );
      expect(menuMaterial.clipBehavior, Clip.antiAlias);
    },
  );
}
