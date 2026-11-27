import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_durations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';

class MyExpansionTile extends StatefulWidget {
  /// The title of the expansion tile.
  final String title;

  /// The subtitle of the expansion tile.
  final String? subtitle;

  /// Optional leading widget displayed before [title].
  final Widget? leading;

  /// The children displayed when expanded.
  final List<Widget> children;

  /// Initial expansion state.
  final bool initiallyExpanded;

  /// Background color when expanded. Defaults to [ColorScheme.surface].
  final Color? backgroundColor;

  /// Background color when collapsed. Defaults to [ColorScheme.surfaceContainer].
  final Color? collapsedBackgroundColor;

  /// Corner radius for both collapsed and expanded shapes. Defaults to [context.brM].
  final BorderRadius? borderRadius;

  /// Padding around the header tile.
  final EdgeInsetsGeometry? tilePadding;

  /// Padding around [children].
  final EdgeInsetsGeometry? childrenPadding;

  /// Optional override style for [subtitle].
  final TextStyle? subtitleStyle;

  const MyExpansionTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.children,
    this.initiallyExpanded = false,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.borderRadius,
    this.tilePadding,
    this.childrenPadding,
    this.subtitleStyle,
  });

  @override
  State<MyExpansionTile> createState() => _MyExpansionTileState();
}

class _MyExpansionTileState extends State<MyExpansionTile> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final textTheme = context.textTheme;
    final radius = widget.borderRadius ?? context.brM;
    final tileShape = RoundedRectangleBorder(
      borderRadius: radius,
      side: BorderSide.none,
    );

    return ExpansionTile(
      initiallyExpanded: widget.initiallyExpanded,
      onExpansionChanged: (value) {
        setState(() => _isExpanded = value);
      },
      clipBehavior: Clip.antiAlias,
      backgroundColor: widget.backgroundColor ?? colors.surface,
      collapsedBackgroundColor:
          widget.collapsedBackgroundColor ?? colors.surfaceContainer,
      shape: tileShape,
      collapsedShape: tileShape,
      tilePadding: widget.tilePadding ?? context.insetsHorizontalM,
      childrenPadding: widget.childrenPadding ?? EdgeInsets.zero,
      leading: widget.leading,
      trailing: AnimatedRotation(
        turns: _isExpanded ? 0.5 : 0,
        duration: AppDurations.fast,
        curve: Curves.easeInOut,
        child: MyIcon(
          icon: AppIcons.arrowDown,
          color: colors.onSurfaceVariant,
          size: context.iconL,
        ),
      ),
      title: Text(
        widget.title,
        style: textTheme.titleMedium?.copyWith(color: colors.onSurface),
      ),
      subtitle: widget.subtitle != null
          ? Text(
              widget.subtitle!,
              style:
                  widget.subtitleStyle ??
                  textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            )
          : null,
      children: widget.children,
    );
  }
}
