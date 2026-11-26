import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';

class MyFavoriteButton extends StatefulWidget {
  final bool initialIsFavorite;
  final ValueChanged<bool>? onChanged;
  final Color? iconColor;

  const MyFavoriteButton({
    super.key,
    this.initialIsFavorite = false,
    this.onChanged,
    this.iconColor,
  });

  @override
  State<MyFavoriteButton> createState() => _MyFavoriteButtonState();
}

class _MyFavoriteButtonState extends State<MyFavoriteButton> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialIsFavorite;
  }

  @override
  void didUpdateWidget(MyFavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIsFavorite != oldWidget.initialIsFavorite) {
      _isFavorite = widget.initialIsFavorite;
    }
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.onChanged?.call(_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return MyIconButton.ghost(
      icon: _isFavorite ? AppIcons.favoriteFilled : AppIcons.favorite,
      iconColor: widget.iconColor ?? context.extendedColors.danger.color,
      tooltip: _isFavorite
          ? context.l10n.removeFavorite
          : context.l10n.setAsFavorite,
      onPressed: _toggleFavorite,
    );
  }
}
