import 'package:flutter/material.dart';
import 'package:idiomer/shared/widgets/appbars/my_gradient_header.dart';

class QuizHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final bool showBottomBorder;

  const QuizHeader({
    super.key,
    required this.title,
    this.trailing,
    this.showBottomBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return MyGradientHeader(
      title: title,
      withLeading: true,
      showBottomBorder: showBottomBorder,
      actions: trailing != null ? [trailing!] : const [],
    );
  }
}
