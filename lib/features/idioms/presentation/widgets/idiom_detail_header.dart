import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';

/// Gradient top header for [IdiomDetailPage], matching other feature headers.
class IdiomDetailHeader extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const IdiomDetailHeader({
    super.key,
    required this.title,
    this.actions = const [],
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
          context.spaceS,
        ),
        child: Row(
          children: [
            MyIconButton.ghost(
              icon: AppIcons.arrowBack(context),
              tooltip: l10n.back,
              iconColor: primary,
              onPressed: () => Navigator.maybePop(context),
            ),
            context.horizontalSpace(12),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            if (actions.isNotEmpty) ...[
              context.horizontalSpace(8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < actions.length; i++) ...[
                    if (i > 0) context.horizontalSpace(4),
                    actions[i],
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
