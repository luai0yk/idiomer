import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:idiomer/core/constants/app_durations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';

/// Shared gradient top header used across feature screens, optionally showing a
/// subtle bottom border matching [SliverHeaderDelegate] when content scrolls under.
class MyGradientHeader extends StatelessWidget {
  final String title;
  final bool withLeading;
  final List<Widget> actions;
  final bool showBottomBorder;

  const MyGradientHeader({
    super.key,
    required this.title,
    this.withLeading = false,
    this.actions = const [],
    this.showBottomBorder = false,
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

    return AnimatedContainer(
      duration: AppDurations.veryFast,
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
        border: showBottomBorder
            ? Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                  width: context.setSize(0.5),
                ),
              )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.spaceM,
          statusBarHeight + context.spaceM,
          context.spaceM,
          context.spaceS,
        ),
        child: SizedBox(
          height: context.setSize(40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (withLeading) ...[
                MyIconButton.ghost(
                  icon: AppIcons.arrowBack(context),
                  tooltip: l10n.back,
                  iconColor: primary,
                  onPressed: () => Navigator.maybePop(context),
                ),
                context.horizontalSpace(12),
              ],
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
      ),
    );
  }
}

/// Coordinates a fixed header above a vertically scrollable [body], notifying
/// [headerBuilder] when vertical content scrolls underneath.
class ScrollUnderHeaderColumn extends StatefulWidget {
  final Widget Function(BuildContext context, bool showBottomBorder)
  headerBuilder;
  final Widget body;

  /// When set (e.g. for pages with a floating search sliver below the fixed
  /// header), the fixed header border stays hidden while at the top or while
  /// reverse-scrolling reveals the floating bar, and appears once scrolled past
  /// [floatingBarHeight].
  final double? floatingBarHeight;

  const ScrollUnderHeaderColumn({
    super.key,
    required this.headerBuilder,
    required this.body,
    this.floatingBarHeight,
  });

  @override
  State<ScrollUnderHeaderColumn> createState() =>
      _ScrollUnderHeaderColumnState();
}

class _ScrollUnderHeaderColumnState extends State<ScrollUnderHeaderColumn> {
  final ValueNotifier<bool> _showBorder = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _showBorder.dispose();
    super.dispose();
  }

  bool _handleScroll(ScrollNotification notification) {
    if (notification.depth != 0 || notification.metrics.axis != Axis.vertical) {
      return false;
    }

    final pixels = notification.metrics.pixels;
    final floatingHeight = widget.floatingBarHeight;

    bool next = _showBorder.value;
    if (floatingHeight == null) {
      next = pixels > 0.5;
    } else if (pixels <= floatingHeight) {
      next = false;
    } else if ((notification is ScrollUpdateNotification &&
            (notification.scrollDelta ?? 0) < 0) ||
        (notification is UserScrollNotification &&
            notification.direction == ScrollDirection.forward)) {
      next = false;
    } else if ((notification is ScrollUpdateNotification &&
            (notification.scrollDelta ?? 0) > 0) ||
        (notification is UserScrollNotification &&
            notification.direction == ScrollDirection.reverse)) {
      next = true;
    }

    if (_showBorder.value != next) {
      _showBorder.value = next;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: _showBorder,
          builder: (context, showBottomBorder, _) =>
              widget.headerBuilder(context, showBottomBorder),
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: _handleScroll,
            child: widget.body,
          ),
        ),
      ],
    );
  }
}
