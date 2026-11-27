import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/services/tts/tts_service.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/ui/bottom_sheet_helper.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/lists/selectable_list.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';
import 'package:idiomer/shared/widgets/sheets/my_bottom_sheet.dart';

class _SpeakerChoice extends Equatable {
  final TtsVoiceOption? voice;
  final String title;
  final String subtitle;

  const _SpeakerChoice({
    required this.voice,
    required this.title,
    required this.subtitle,
  });

  @override
  List<Object?> get props => [voice, title, subtitle];
}

/// Bottom sheet displaying installed English TTS speakers using cards styled
/// like [FlashcardGroupIdiomsSheet], with inline sample playback per speaker.
class TtsSpeakerPickerSheet extends StatelessWidget {
  static const String utterancePrefix = 'speaker_sheet_';

  final List<TtsVoiceOption> voices;
  final TtsAccent accent;
  final double speechRate;
  final TtsService ttsService;
  final String? selectedVoiceName;
  final String? selectedVoiceLocale;
  final ValueChanged<TtsVoiceOption?> onSelectVoice;

  const TtsSpeakerPickerSheet({
    super.key,
    required this.voices,
    required this.accent,
    required this.speechRate,
    required this.ttsService,
    required this.selectedVoiceName,
    required this.selectedVoiceLocale,
    required this.onSelectVoice,
  });

  static Future<void> show({
    required BuildContext context,
    required List<TtsVoiceOption> voices,
    required TtsAccent accent,
    required double speechRate,
    required TtsService ttsService,
    required String? selectedVoiceName,
    required String? selectedVoiceLocale,
    required ValueChanged<TtsVoiceOption?> onSelectVoice,
  }) {
    return BottomSheetHelper.show<void>(
      child: TtsSpeakerPickerSheet(
        voices: voices,
        accent: accent,
        speechRate: speechRate,
        ttsService: ttsService,
        selectedVoiceName: selectedVoiceName,
        selectedVoiceLocale: selectedVoiceLocale,
        onSelectVoice: onSelectVoice,
      ),
    );
  }

  String _utteranceIdFor(_SpeakerChoice choice) {
    final voice = choice.voice;
    if (voice == null) {
      return '${utterancePrefix}default_${accent.localeCode}';
    }
    return '$utterancePrefix${voice.name}_${voice.locale}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final extendedColors = context.extendedColors;

    final choices = <_SpeakerChoice>[
      _SpeakerChoice(
        voice: null,
        title: l10n.ttsDefaultVoice,
        subtitle: accent.localeCode,
      ),
      for (final voice in voices)
        _SpeakerChoice(
          voice: voice,
          title: voice.titleLabel,
          subtitle: voice.subtitleLabel,
        ),
    ];

    final initialSelected =
        choices
            .where(
              (c) =>
                  c.voice?.name == selectedVoiceName &&
                  c.voice?.locale == selectedVoiceLocale,
            )
            .firstOrNull ??
        choices.first;

    final enableSearch = voices.length > 6;

    return MyBottomSheet(
      title: l10n.ttsVoice,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (voices.isEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.spaceM,
                context.spaceXs,
                context.spaceM,
                context.spaceXs,
              ),
              child: Text(
                l10n.ttsNoVoicesAvailable,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          Flexible(
            child: ValueListenableBuilder<String?>(
              valueListenable: ttsService.activeUtteranceId,
              builder: (context, activeId, _) {
                return SelectableList<_SpeakerChoice>.single(
                  items: choices,
                  initialSelected: initialSelected,
                  enableSearch: enableSearch,
                  searchFilter: (item, query) =>
                      item.title.toLowerCase().contains(query) ||
                      item.subtitle.toLowerCase().contains(query),
                  separatorHeight: context.spaceS,
                  padding: enableSearch
                      ? null
                      : EdgeInsets.fromLTRB(
                          context.spaceM,
                          context.spaceXs,
                          context.spaceM,
                          context.spaceM,
                        ),
                  itemLabel: (item) => item.title,
                  itemBuilder: (context, item, isSelected, onTap) {
                    final utteranceId = _utteranceIdFor(item);
                    final isPlaying = activeId == utteranceId;
                    return _SpeakerSheetCard(
                      choice: item,
                      isSelected: isSelected,
                      isPlaying: isPlaying,
                      playTooltip: isPlaying
                          ? l10n.stopSpeaking
                          : l10n.ttsSample,
                      dangerColor: extendedColors.danger.color,
                      textTheme: textTheme,
                      colorScheme: colorScheme,
                      onTap: onTap,
                      onPlaySample: () => ttsService.speak(
                        l10n.ttsSampleSentence,
                        utteranceId: utteranceId,
                        accent: accent,
                        speechRate: speechRate,
                        voiceName: item.voice?.name,
                        voiceLocale: item.voice?.locale,
                      ),
                    );
                  },
                  onChanged: (choice) {
                    BottomSheetHelper.dismiss();
                    onSelectVoice(choice.voice);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeakerSheetCard extends StatelessWidget {
  final _SpeakerChoice choice;
  final bool isSelected;
  final bool isPlaying;
  final String playTooltip;
  final Color dangerColor;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final VoidCallback onTap;
  final VoidCallback onPlaySample;

  const _SpeakerSheetCard({
    required this.choice,
    required this.isSelected,
    required this.isPlaying,
    required this.playTooltip,
    required this.dangerColor,
    required this.textTheme,
    required this.colorScheme,
    required this.onTap,
    required this.onPlaySample,
  });

  @override
  Widget build(BuildContext context) {
    final primary = colorScheme.primary;
    final surface = colorScheme.surfaceContainerLow;
    final isDefault = choice.voice == null;

    return MyCard.bordered(
      color: isSelected
          ? Color.alphaBlend(primary.withValues(alpha: 0.08), surface)
          : surface,
      borderColor: isSelected
          ? primary.withValues(alpha: 0.4)
          : Colors.transparent,
      borderRadius: context.brXl,
      padding: context.insetsAllL,
      onTap: onTap,
      child: Directionality(
        textDirection: .ltr,
        child: Row(
          children: [
            Container(
              width: context.setSize(38),
              height: context.setSize(38),
              decoration: BoxDecoration(
                color: isSelected ? primary : primary.withValues(alpha: 0.12),
                borderRadius: context.brL,
              ),
              alignment: Alignment.center,
              child: MyIcon(
                icon: AppIcons.volume,
                size: context.iconS,
                color: isSelected ? colorScheme.onPrimary : primary,
              ),
            ),
            context.horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    choice.title,
                    textDirection: isDefault ? null : TextDirection.ltr,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isSelected ? primary : colorScheme.onSurface,
                    ),
                  ),
                  context.verticalSpace(2),
                  Text(
                    choice.subtitle,
                    textDirection: TextDirection.ltr,
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: primary.withValues(
                        alpha: isSelected ? 0.95 : 0.85,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            context.horizontalSpace(8),
            MyIconButton.ghost(
              icon: isPlaying ? AppIcons.stop : AppIcons.play,
              iconColor: isPlaying ? dangerColor : primary,
              tooltip: playTooltip,
              autoLoading: false,
              onPressed: onPlaySample,
            ),
          ],
        ),
      ),
    );
  }
}
