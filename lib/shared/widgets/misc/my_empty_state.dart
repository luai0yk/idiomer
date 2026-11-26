import 'package:flutter/material.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/buttons/my_button.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';

enum MyEmptyStateSize { normal, small }

class MyEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final MyEmptyStateSize size;

  const MyEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onAction,
    this.size = MyEmptyStateSize.normal,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final primary = colorScheme.primary;
    final isSmall = size == MyEmptyStateSize.small;

    final badgeSize = context.setSize(isSmall ? 64 : 92);
    final iconSize = context.setSize(isSmall ? 30 : 44);
    final badgeRadius = isSmall ? context.brL : context.brXl;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.setSize(isSmall ? 16 : 24),
        vertical: context.setSize(isSmall ? 16 : 24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: badgeSize,
            height: badgeSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [
                  primary.withValues(alpha: 0.16),
                  colorScheme.tertiary.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: badgeRadius,
            ),
            child: Center(
              child: MyIcon(icon: icon, size: iconSize, color: primary),
            ),
          ),
          context.verticalSpace(isSmall ? 12 : 18),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: (isSmall ? textTheme.titleSmall : textTheme.titleLarge)
                ?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  color: colorScheme.onSurface,
                ),
          ),
          context.verticalSpace(isSmall ? 4 : 6),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.screenWidth * 0.65),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: (isSmall ? textTheme.bodySmall : textTheme.bodyMedium)
                  ?.copyWith(height: 1.45, color: colorScheme.onSurfaceVariant),
            ),
          ),
          if (actionText != null && onAction != null) ...[
            context.verticalSpace(isSmall ? 12 : 20),
            MyButton.primary(
              text: actionText!,
              width: 0,
              height: context.setSize(isSmall ? 36 : 42),
              fontSize: context.setSize(isSmall ? 12 : 13),
              padding: EdgeInsets.symmetric(horizontal: context.spaceL),
              borderRadius: context.brL,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}
