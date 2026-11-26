import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';

class MyPopupMenuItem<T> {
  final T? value;
  final String label;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;
  final bool enabled;

  const MyPopupMenuItem({
    this.value,
    required this.label,
    this.icon,
    this.color,
    this.onTap,
    this.enabled = true,
  });
}

class MyPopupMenu<T> extends StatelessWidget {
  final List<MyPopupMenuItem<T>> items;
  final void Function(T)? onSelected;
  final IconData? icon;
  final Color? iconColor;
  final String? tooltip;
  final Offset offset;
  final ShapeBorder? shape;
  final Color? color;
  final double? elevation;

  const MyPopupMenu({
    super.key,
    required this.items,
    this.onSelected,
    this.icon,
    this.iconColor,
    this.tooltip,
    this.offset = Offset.zero,
    this.shape,
    this.color,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      icon: MyIcon(icon: icon ?? AppIcons.more, color: iconColor),
      style: ButtonStyle(
        // backgroundColor: WidgetStatePropertyAll(
        //   context.colorScheme.surfaceContainer,
        // ),
        splashFactory: InkRipple.splashFactory,
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: context.brCircular),
        ),
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
      ),

      tooltip: tooltip,
      offset: offset,
      shape:
          shape ??
          RoundedRectangleBorder(
            borderRadius: context.brM,
            side: BorderSide(
              width: context.setSize(0.4),
              color: context.colorScheme.outlineVariant,
            ),
          ),
      color: color ?? context.colorScheme.surface,
      elevation: elevation ?? context.elevationS,
      onSelected: (value) {
        onSelected?.call(value);
      },
      itemBuilder: (BuildContext context) {
        return items.map((MyPopupMenuItem<T> item) {
          final itemColor = item.enabled
              ? (item.color ?? context.colorScheme.onSurface)
              : context.colorScheme.onSurface.withValues(alpha: 0.38);
          return PopupMenuItem<T>(
            value: item.value,
            enabled: item.enabled,
            onTap: item.enabled ? item.onTap : null,
            child: Row(
              children: [
                if (item.icon != null) ...[
                  MyIcon(
                    icon: item.icon!,
                    color: itemColor,
                    size: context.iconM,
                  ),
                  SizedBox(width: context.spaceS),
                ],
                Expanded(
                  child: Text(
                    item.label,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: itemColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
