import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/misc/my_bottom_navigation_bar.dart';

class AppShellPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShellPage({
    super.key,
    required this.navigationShell,
  });

  void _onItemSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: MyBottomNavigationBar(
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.radiusL),
        ),
        expandItems: true,
        selectedForegroundColor: colorScheme.primary,
        items: [
          MyBottomNavigationBarItem(
            title: l10n.idioms,
            icon: const Icon(AppIcons.idioms),
            selectedIcon: const Icon(AppIcons.idiomsFilled),
          ),
          MyBottomNavigationBarItem(
            title: l10n.favorites,
            icon: const Icon(AppIcons.favorite),
            selectedIcon: const Icon(AppIcons.favoriteFilled),
          ),
          MyBottomNavigationBarItem(
            title: l10n.flashcards,
            icon: const Icon(AppIcons.flashcards),
            selectedIcon: const Icon(AppIcons.flashcardsFilled),
          ),
          MyBottomNavigationBarItem(
            title: l10n.settings,
            icon: const Icon(AppIcons.settings),
            selectedIcon: const Icon(AppIcons.settingsFilled),
          ),
        ],
        currentIndex: navigationShell.currentIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
