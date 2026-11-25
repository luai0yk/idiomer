import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';

/// A sliver that displays a customizable persistent or floating header.
///
/// Wraps [SliverPersistentHeader] with [SliverHeaderDelegate].
class MySliverHeader extends StatelessWidget {
  /// The fixed height of the header.
  final double height;

  /// The widget displayed inside the header.
  final Widget child;

  /// Background color of the header. Defaults to [ColorScheme.surface].
  final Color? backgroundColor;

  /// Optional background gradient for the header. Overrides [backgroundColor].
  final Gradient? gradient;

  /// Whether to apply a backdrop blur effect. Defaults to true.
  final bool withBlur;

  /// Optional border. If omitted, displays a subtle outline when content scrolls underneath.
  final BoxBorder? border;

  /// Optional border radius for rounded corners.
  final BorderRadiusGeometry? borderRadius;

  /// Whether to show elevation (shadow) or not. Matches [MyAppBar] and [MySliverAppBar].
  /// Defaults to true.
  final bool isElevated;

  /// Whether the header should remain pinned at the top of the scroll view.
  /// Defaults to false.
  final bool pinned;

  /// Whether the header should float into view as soon as the user scrolls in reverse.
  /// Defaults to false.
  final bool floating;

  const MySliverHeader({
    super.key,
    required this.height,
    required this.child,
    this.backgroundColor,
    this.gradient,
    this.withBlur = true,
    this.border,
    this.borderRadius,
    this.isElevated = true,
    this.pinned = false,
    this.floating = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: SliverHeaderDelegate(
        height: height,
        child: child,
        backgroundColor: backgroundColor,
        gradient: gradient,
        withBlur: withBlur,
        border: border,
        borderRadius: borderRadius,
        isElevated: isElevated,
      ),
    );
  }
}

typedef SliverHeader = MySliverHeader;

class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  /// The fixed height of the header.
  final double height;

  /// The widget displayed inside the header.
  final Widget child;

  /// Background color of the header. Defaults to [ColorScheme.surface].
  final Color? backgroundColor;

  /// Optional background gradient for the header. Overrides [backgroundColor].
  final Gradient? gradient;

  /// Whether to apply a backdrop blur effect. Defaults to true.
  final bool withBlur;

  /// Optional border. If omitted, displays a subtle outline when content scrolls underneath.
  final BoxBorder? border;

  /// Optional border radius for rounded corners.
  final BorderRadiusGeometry? borderRadius;

  /// Whether to show elevation (shadow) or not. Matches [MyAppBar] and [MySliverAppBar].
  /// Defaults to true.
  final bool isElevated;

  const SliverHeaderDelegate({
    required this.height,
    required this.child,
    this.backgroundColor,
    this.gradient,
    this.withBlur = true,
    this.border,
    this.borderRadius,
    this.isElevated = true,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final bgColor = (backgroundColor ?? context.colorScheme.surface).withValues(
      alpha: withBlur ? 0.8 : 1.0,
    );

    final effectiveBorder =
        border ??
        (overlapsContent
            ? (borderRadius != null
                  ? Border.all(
                      color: context.colorScheme.outlineVariant.withValues(
                        alpha: 0.35,
                      ),
                      width: context.setSize(0.5),
                    )
                  : Border(
                      bottom: BorderSide(
                        color: context.colorScheme.outlineVariant.withValues(
                          alpha: 0.35,
                        ),
                        width: context.setSize(0.5),
                      ),
                    ))
            : null);

    final effectiveShadow = isElevated
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
        : null;

    final content = SizedBox(height: height, child: child);

    if (withBlur) {
      final blurredContent = ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: gradient == null ? bgColor : null,
              gradient: gradient,
              borderRadius: borderRadius,
              border: effectiveBorder,
            ),
            child: content,
          ),
        ),
      );

      if (effectiveShadow != null && effectiveShadow.isNotEmpty) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: effectiveShadow,
          ),
          child: blurredContent,
        );
      }

      return blurredContent;
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: gradient == null ? bgColor : null,
        gradient: gradient,
        borderRadius: borderRadius,
        border: effectiveBorder,
        boxShadow: effectiveShadow,
      ),
      child: borderRadius != null
          ? ClipRRect(borderRadius: borderRadius!, child: content)
          : content,
    );
  }

  @override
  bool shouldRebuild(covariant SliverHeaderDelegate oldDelegate) {
    return oldDelegate.height != height ||
        oldDelegate.child != child ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.gradient != gradient ||
        oldDelegate.withBlur != withBlur ||
        oldDelegate.border != border ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.isElevated != isElevated;
  }
}
