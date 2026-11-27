import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';

class HomeWelcomeHeader extends StatelessWidget {
  final String greeting;
  final String subtitle;
  final VoidCallback onOpenSettings;
  final VoidCallback? onOpenReminder;

  const HomeWelcomeHeader({
    super.key,
    required this.greeting,
    required this.subtitle,
    required this.onOpenSettings,
    this.onOpenReminder,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    final primary = colorScheme.primary;
    final tertiary = colorScheme.tertiary;
    final surface = colorScheme.surface;
    final statusBarHeight = MediaQuery.paddingOf(context).top;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.55, 1.0],
          colors: [
            Color.alphaBlend(primary.withValues(alpha: 0.16), surface),
            Color.alphaBlend(tertiary.withValues(alpha: 0.06), surface),
            surface,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.spaceM,
          statusBarHeight + context.spaceM,
          context.spaceM,
          context.spaceM,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  context.verticalSpace(3),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            context.horizontalSpace(10),
            if (onOpenReminder != null) ...[
              MyIconButton.ghost(
                icon: AppIcons.notifications,
                tooltip: l10n.idiomReminder,
                iconColor: primary,
                onPressed: onOpenReminder!,
              ),
              context.horizontalSpace(4),
            ],
            MyIconButton.ghost(
              icon: AppIcons.settings,
              tooltip: l10n.settings,
              // backgroundColor: surface.withValues(alpha: 0.85),
              // borderColor: primary.withValues(alpha: 0.18),
              iconColor: primary,
              onPressed: onOpenSettings,
            ),
          ],
        ),
      ),
    );
  }
}
