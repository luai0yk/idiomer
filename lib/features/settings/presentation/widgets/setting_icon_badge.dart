import 'package:flutter/material.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';

class SettingIconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;

  const SettingIconBadge({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return MyCard.filled(
      width: context.setSize(44),
      height: context.setSize(44),
      borderRadius: context.brL,
      color: color.withValues(alpha: 0.15),
      child: MyIcon(icon: icon, color: color),
    );
  }
}
