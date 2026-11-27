import 'package:flutter/material.dart';
import 'package:idiomer/shared/widgets/appbars/my_gradient_header.dart';

class FlashcardsHeader extends StatelessWidget {
  final String title;
  final bool withLeading;
  final Widget? trailing;
  final bool showBottomBorder;

  const FlashcardsHeader({
    super.key,
    required this.title,
    this.withLeading = false,
    this.trailing,
    this.showBottomBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return MyGradientHeader(
      title: title,
      withLeading: withLeading,
      showBottomBorder: showBottomBorder,
      actions: trailing != null ? [trailing!] : const [],
    );
  }
}
