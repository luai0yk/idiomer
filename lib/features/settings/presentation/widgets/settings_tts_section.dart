import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/app/di/injection.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/services/tts/tts_service.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/settings_helper.dart';
import 'package:idiomer/core/utils/helpers/ui/toast_helper.dart';
import 'package:idiomer/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:idiomer/features/settings/presentation/cubit/settings_state.dart';
import 'package:idiomer/features/settings/presentation/widgets/expandable_setting_card.dart';
import 'package:idiomer/features/settings/presentation/widgets/setting_icon_badge.dart';
import 'package:idiomer/features/settings/presentation/widgets/tts_speaker_picker_sheet.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/cards/my_section_card.dart';
import 'package:idiomer/shared/widgets/misc/my_toast.dart';
import 'package:idiomer/shared/widgets/tiles/my_list_tile.dart';

class SettingsTtsSection extends StatefulWidget {
  final TtsService? ttsService;

  const SettingsTtsSection({super.key, this.ttsService});

  @override
  State<SettingsTtsSection> createState() => _SettingsTtsSectionState();
}

class _SettingsTtsSectionState extends State<SettingsTtsSection>
    with WidgetsBindingObserver {
  static const String _sampleUtteranceId = 'settings_tts_sample';

  late final TtsService _ttsService;
  List<TtsVoiceOption> _voices = const [];
  TtsAccent? _loadedAccent;
  bool _pendingVoiceRefreshOnResume = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ttsService =
        widget.ttsService ??
        (sl.isRegistered<TtsService>() ? sl<TtsService>() : TtsService());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final accent = context.read<SettingsCubit>().state.ttsAccent;
    if (_loadedAccent != accent) {
      _loadVoices(accent);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _pendingVoiceRefreshOnResume) {
      _pendingVoiceRefreshOnResume = false;
      final accent = _loadedAccent;
      if (accent != null) {
        _loadVoices(accent);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_ttsService.activeUtteranceId.value == _sampleUtteranceId) {
      Future.microtask(_ttsService.stop);
    }
    super.dispose();
  }

  Future<List<TtsVoiceOption>> _loadVoices(TtsAccent accent) async {
    _loadedAccent = accent;
    final voices = await _ttsService.getAvailableEnglishVoices(accent: accent);
    if (!mounted || _loadedAccent != accent) return voices;
    setState(() => _voices = voices);
    return voices;
  }

  Future<void> _openDeviceTtsSettings(BuildContext context) async {
    final l10n = context.l10n;
    _pendingVoiceRefreshOnResume = true;
    final opened = await _ttsService.openDeviceTtsSettings();
    if (!opened) {
      _pendingVoiceRefreshOnResume = false;
      if (!context.mounted) return;
      ToastHelper.show(
        msg: l10n.deviceTtsSettingsUnavailable,
        status: ToastStatus.warning,
      );
    }
  }

  Future<void> _openSpeakerSheet(
    BuildContext context, {
    required TtsAccent accent,
    required String? voiceName,
    required String? voiceLocale,
  }) async {
    final cubit = context.read<SettingsCubit>();
    final voices = await _loadVoices(accent);
    if (!context.mounted) return;
    await TtsSpeakerPickerSheet.show(
      context: context,
      voices: voices,
      accent: accent,
      speechRate: cubit.state.ttsSpeechRate,
      ttsService: _ttsService,
      selectedVoiceName: voiceName,
      selectedVoiceLocale: voiceLocale,
      onSelectVoice: (voice) => cubit.changeTtsVoice(voice),
    );
    final activeId = _ttsService.activeUtteranceId.value;
    if (activeId != null &&
        activeId.startsWith(TtsSpeakerPickerSheet.utterancePrefix)) {
      await _ttsService.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final extendedColors = context.extendedColors;
    final textTheme = context.textTheme;

    return MySectionCard(
      title: l10n.ttsSettings,
      color: Colors.transparent,
      children: [
        BlocSelector<SettingsCubit, SettingsState, TtsAccent>(
          selector: (state) => state.ttsAccent,
          builder: (context, accent) {
            return ExpandableSettingCard<TtsAccent>(
              icon: AppIcons.globe,
              iconColor: colorScheme.primary,
              title: l10n.ttsAccent,
              selectedLabel: SettingsHelper.getTtsAccentName(context, accent),
              selectedValue: accent,
              options: [
                SettingOptionItem(
                  value: TtsAccent.us,
                  label: l10n.ttsAccentUs,
                  icon: AppIcons.globe,
                ),
                SettingOptionItem(
                  value: TtsAccent.uk,
                  label: l10n.ttsAccentUk,
                  icon: AppIcons.globe,
                ),
                SettingOptionItem(
                  value: TtsAccent.au,
                  label: l10n.ttsAccentAu,
                  icon: AppIcons.globe,
                ),
              ],
              onSelect: (value) async {
                await context.read<SettingsCubit>().changeTtsAccent(value);
                if (mounted) {
                  _loadVoices(value);
                }
              },
            );
          },
        ),
        context.verticalSpace(10),
        BlocSelector<
          SettingsCubit,
          SettingsState,
          ({TtsAccent accent, String? voiceName, String? voiceLocale})
        >(
          selector: (state) => (
            accent: state.ttsAccent,
            voiceName: state.ttsVoiceName,
            voiceLocale: state.ttsVoiceLocale,
          ),
          builder: (context, voiceState) {
            final matchedVoice = _voices
                .where(
                  (v) =>
                      v.name == voiceState.voiceName &&
                      v.locale == voiceState.voiceLocale,
                )
                .firstOrNull;
            final speakerSubtitle =
                matchedVoice?.displayName ??
                (voiceState.voiceName != null
                    ? voiceState.voiceName!
                    : l10n.ttsDefaultVoice);

            return MyCard.filled(
              borderRadius: context.brXl,
              padding: EdgeInsets.zero,
              child: MyListTile(
                leading: SettingIconBadge(
                  icon: AppIcons.voice,
                  color: colorScheme.tertiary,
                ),
                borderRadius: context.brXl,
                title: l10n.ttsVoice,
                subtitle: speakerSubtitle,
                subtitleColor: colorScheme.primary,
                trailingIcon: AppIcons.arrowForward(context),
                onTap: () => _openSpeakerSheet(
                  context,
                  accent: voiceState.accent,
                  voiceName: voiceState.voiceName,
                  voiceLocale: voiceState.voiceLocale,
                ),
              ),
            );
          },
        ),
        context.verticalSpace(10),
        BlocSelector<SettingsCubit, SettingsState, double>(
          selector: (state) => state.ttsSpeechRate,
          builder: (context, speechRate) {
            return MyCard.filled(
              borderRadius: context.brXl,
              padding: context.insetsAllM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      SettingIconBadge(
                        icon: AppIcons.speed,
                        color: extendedColors.warning.color,
                      ),
                      context.horizontalSpace(12),
                      Expanded(
                        child: Text(
                          l10n.ttsSpeed,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      MyCard.filled(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: context.brCircular,
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spaceM,
                          vertical: context.spaceXs,
                        ),
                        child: Text(
                          SettingsHelper.formatSpeechRate(speechRate),
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  context.verticalSpace(8),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: context.setSize(10),
                      trackShape: const RoundedRectSliderTrackShape(),
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: context.setSize(12),
                      ),
                      overlayShape: RoundSliderOverlayShape(
                        overlayRadius: context.setSize(10),
                      ),
                      activeTrackColor: colorScheme.primary,
                      inactiveTrackColor: colorScheme.surfaceContainerHighest,
                      activeTickMarkColor: colorScheme.onPrimary.withValues(
                        alpha: 0.45,
                      ),
                      inactiveTickMarkColor: colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.35),
                      thumbColor: colorScheme.primary,
                    ),
                    child: Slider(
                      value: speechRate.clamp(0.25, 1.0),
                      min: 0.25,
                      max: 1.0,
                      divisions: 15,
                      onChanged: (value) => context
                          .read<SettingsCubit>()
                          .changeTtsSpeechRate(value),
                    ),
                  ),
                  Padding(
                    padding: context.insetsHorizontalS,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '0.5x',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '1.0x',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '1.5x',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '2.0x',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        context.verticalSpace(10),
        ValueListenableBuilder<String?>(
          valueListenable: _ttsService.activeUtteranceId,
          builder: (context, activeId, _) {
            final isPlaying = activeId == _sampleUtteranceId;

            void toggleSample() {
              final state = context.read<SettingsCubit>().state;
              _ttsService.speak(
                l10n.ttsSampleSentence,
                utteranceId: _sampleUtteranceId,
                accent: state.ttsAccent,
                speechRate: state.ttsSpeechRate,
                voiceName: state.ttsVoiceName,
                voiceLocale: state.ttsVoiceLocale,
              );
            }

            return MyCard.filled(
              borderRadius: context.brXl,
              padding: context.insetsAllM,
              onTap: toggleSample,
              child: Row(
                children: [
                  SettingIconBadge(
                    icon: AppIcons.volume,
                    color: extendedColors.success.color,
                  ),
                  context.horizontalSpace(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.ttsSample,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        context.verticalSpace(2),
                        Text(
                          l10n.ttsSampleSentence,
                          textDirection: TextDirection.ltr,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  context.horizontalSpace(12),
                  MyIconButton.solid(
                    icon: isPlaying ? AppIcons.stop : AppIcons.play,
                    backgroundColor: isPlaying
                        ? extendedColors.danger.color
                        : colorScheme.primary,
                    iconColor: isPlaying
                        ? extendedColors.danger.onColor
                        : colorScheme.onPrimary,
                    tooltip: isPlaying ? l10n.stopSpeaking : l10n.ttsSample,
                    autoLoading: false,
                    onPressed: toggleSample,
                  ),
                ],
              ),
            );
          },
        ),
        context.verticalSpace(10),
        MyCard.filled(
          borderRadius: context.brXl,
          padding: EdgeInsets.zero,
          child: MyListTile(
            leading: SettingIconBadge(
              icon: AppIcons.settings,
              color: colorScheme.secondary,
            ),
            borderRadius: context.brXl,
            title: l10n.deviceTtsSettings,
            subtitle: l10n.deviceTtsSettingsSubtitle,
            trailingIcon: AppIcons.arrowForward(context),
            onTap: () => _openDeviceTtsSettings(context),
          ),
        ),
      ],
    );
  }
}
