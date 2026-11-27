import 'package:flutter/material.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/shared/widgets/buttons/my_button.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const HomeSectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return Padding(
      padding: context.insetsHorizontalM,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          if (actionText != null && onAction != null)
            MyButton.text(
              text: actionText!,
              height: context.setSize(34),
              fontSize: context.setSize(13),
              textStyleType: AppButtonTextStyle.medium,
              padding: context.insetsHorizontalS,
              borderRadius: context.brL,
              onPressed: onAction,
            ),
        ],
      ),
    );
  }
}
