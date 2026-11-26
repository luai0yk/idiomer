import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_durations.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';

class MyProgressBar extends StatelessWidget {
  final double? value;
  final String? label;
  final bool showPercentage;
  final double? height;
  final Color? color;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const MyProgressBar({
    super.key,
    this.value,
    this.label,
    this.showPercentage = false,
    this.height,
    this.color,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final resolvedColor = color ?? colorScheme.primary;
    final resolvedBgColor =
        backgroundColor ?? colorScheme.surfaceContainerHighest;
    final resolvedRadius = borderRadius ?? context.brCircular;
    final resolvedHeight = height ?? context.setSize(20);
    final clampedValue = value?.clamp(0.0, 1.0);
    final hasHeader = label != null || (showPercentage && clampedValue != null);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasHeader) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                const SizedBox.shrink(),
              if (showPercentage && clampedValue != null)
                Text(
                  '${(clampedValue * 100).round()}%',
                  style: textTheme.titleSmall?.copyWith(
                    color: resolvedColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
            ],
          ),
          context.verticalSpace(8),
        ],
        if (clampedValue == null)
          ClipRRect(
            borderRadius: resolvedRadius,
            child: LinearProgressIndicator(
              minHeight: resolvedHeight,
              borderRadius: resolvedRadius,
              backgroundColor: resolvedBgColor,
              valueColor: AlwaysStoppedAnimation<Color>(resolvedColor),
            ),
          )
        else
          TweenAnimationBuilder<double>(
            tween: Tween<double>(end: clampedValue),
            duration: AppDurations.fast,
            curve: Curves.easeOutCubic,
            builder: (context, animatedValue, _) {
              return ClipRRect(
                borderRadius: resolvedRadius,
                child: LinearProgressIndicator(
                  value: animatedValue,
                  minHeight: resolvedHeight,
                  borderRadius: resolvedRadius,
                  backgroundColor: resolvedBgColor,
                  valueColor: AlwaysStoppedAnimation<Color>(resolvedColor),
                ),
              );
            },
          ),
      ],
    );
  }
}
