import 'package:flutter/material.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_entity.dart';
import 'package:idiomer/shared/widgets/buttons/my_favorite_button.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';

class IdiomCard extends StatelessWidget {
  final IdiomEntity idiom;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const IdiomCard({
    super.key,
    required this.idiom,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return MyCard.filled(
      color: colorScheme.surfaceContainerLow,
      borderRadius: context.brL,
      padding: context.insetsAllL,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      idiom.englishText,
                      textDirection: TextDirection.ltr,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    context.verticalSpace(6),
                    Text(
                      idiom.arabicText,
                      textDirection: TextDirection.rtl,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              context.horizontalSpace(8),
              MyFavoriteButton(
                initialIsFavorite: idiom.isFavorite,
                onChanged: (_) => onToggleFavorite(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
