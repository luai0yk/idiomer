import 'package:flutter/material.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/misc/my_progress_indicator.dart';

/// Flat, cardless loading indicator with an optional short label underneath.
class MyLoadingState extends StatelessWidget {
  final String? label;
  final double? size;
  final double? strokeWidth;
  final Color? color;

  const MyLoadingState({
    super.key,
    this.label,
    this.size,
    this.strokeWidth,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final hasLabel = label != null && label!.trim().isNotEmpty;

    return Padding(
      padding: context.insetsAllL,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyProgressIndicator(
            size: size,
            strokeWidth: strokeWidth,
            color: color,
          ),
          if (hasLabel) ...[
            context.verticalSpace(14),
            Text(
              label!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
