import 'package:flutter/material.dart';
import 'package:idiomer/shared/widgets/appbars/my_gradient_header.dart';

/// Gradient top header for [IdiomDetailPage], matching other feature headers.
class IdiomDetailHeader extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final bool showBottomBorder;

  const IdiomDetailHeader({
    super.key,
    required this.title,
    this.actions = const [],
    this.showBottomBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return MyGradientHeader(
      title: title,
      withLeading: true,
      actions: actions,
      showBottomBorder: showBottomBorder,
    );
  }
}
