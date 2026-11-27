import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:idiomer/shared/widgets/texts/highlighted_markup_text.dart';

enum TtsAccent {
  us,
  uk,
  au;

  String get localeCode => switch (this) {
    TtsAccent.us => 'en-US',
    TtsAccent.uk => 'en-GB',
    TtsAccent.au => 'en-AU',
  };
}

class TtsVoiceOption extends Equatable {
  final String name;
  final String locale;

  const TtsVoiceOption({required this.name, required this.locale});

  String get titleLabel {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('-x-')) {
      final parts = name.split('-');
      final code = parts.length >= 4 ? parts[3].toUpperCase() : name;
      return 'Voice $code';
    }
    return name;
  }

  String get subtitleLabel {
    final normalizedLocale = locale.replaceAll('_', '-');
    final lowerName = name.toLowerCase();
    if (lowerName.contains('-x-')) {
      final quality = lowerName.contains('network') ? 'Online' : 'Offline';
      return '$normalizedLocale • $quality';
    }
    return normalizedLocale;
  }

  String get displayName => '$titleLabel ($subtitleLabel)';

  @override
  List<Object?> get props => [name, locale];
}

/// Shared wrapper around [FlutterTts] for configuring accent, voice, speed,
/// and tracking the currently playing utterance across screens.
class TtsService {
  static const MethodChannel _ttsSettingsChannel = MethodChannel(
    'com.luai0yk.idiomer/tts_settings',
  );

  final FlutterTts? _injectedTts;
  final Future<bool> Function()? _openDeviceTtsSettingsHandler;
  FlutterTts? _tts;
  bool _handlersBound = false;

  final ValueNotifier<String?> _activeUtteranceId = ValueNotifier<String?>(
    null,
  );

  TtsService({
    FlutterTts? flutterTts,
    Future<bool> Function()? openDeviceTtsSettingsHandler,
  }) : _injectedTts = flutterTts,
       _openDeviceTtsSettingsHandler = openDeviceTtsSettingsHandler;

  ValueListenable<String?> get activeUtteranceId => _activeUtteranceId;

  FlutterTts _ensureTts() {
    final instance = _tts ??= _injectedTts ?? FlutterTts();
    if (!_handlersBound) {
      _handlersBound = true;
      instance.setCompletionHandler(() {
        _activeUtteranceId.value = null;
      });
      instance.setCancelHandler(() {
        _activeUtteranceId.value = null;
      });
      instance.setErrorHandler((_) {
        _activeUtteranceId.value = null;
      });
    }
    return instance;
  }

  /// Returns installed English voices, preferring those matching [accent].
  /// Falls back to all English voices if the installed engine has no voices
  /// for the requested regional accent.
  Future<List<TtsVoiceOption>> getAvailableEnglishVoices({
    TtsAccent? accent,
  }) async {
    try {
      final tts = _ensureTts();
      final rawVoices = await tts.getVoices;
      if (rawVoices is! List) return const [];

      final englishVoices = <TtsVoiceOption>[];
      final seen = <String>{};

      for (final item in rawVoices) {
        if (item is! Map) continue;
        final name = item['name']?.toString().trim() ?? '';
        final locale = item['locale']?.toString().trim() ?? '';
        if (name.isEmpty || locale.isEmpty) continue;

        final normalizedLocale = locale.replaceAll('_', '-').toLowerCase();
        if (!normalizedLocale.startsWith('en')) continue;

        final key = '$name|$normalizedLocale';
        if (seen.add(key)) {
          englishVoices.add(TtsVoiceOption(name: name, locale: locale));
        }
      }

      englishVoices.sort(
        (a, b) =>
            a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()),
      );

      if (accent == null) return englishVoices;

      final targetPrefix = accent.localeCode.toLowerCase();
      final accentMatches = englishVoices
          .where(
            (v) => v.locale.replaceAll('_', '-').toLowerCase() == targetPrefix,
          )
          .toList();

      return accentMatches.isNotEmpty ? accentMatches : englishVoices;
    } on MissingPluginException {
      return const [];
    } catch (_) {
      return const [];
    }
  }

  Future<bool> speak(
    String text, {
    required String utteranceId,
    TtsAccent accent = TtsAccent.us,
    double speechRate = 0.5,
    String? voiceName,
    String? voiceLocale,
  }) async {
    final cleanText = HighlightedMarkupText.stripMarkers(text).trim();
    if (cleanText.isEmpty) return false;

    if (_activeUtteranceId.value == utteranceId) {
      await stop();
      return false;
    }

    try {
      final tts = _ensureTts();
      await tts.stop();

      _activeUtteranceId.value = utteranceId;
      await tts.setLanguage(accent.localeCode);

      if (voiceName != null &&
          voiceName.isNotEmpty &&
          voiceLocale != null &&
          voiceLocale.isNotEmpty) {
        await tts.setVoice({'name': voiceName, 'locale': voiceLocale});
      } else {
        await tts.clearVoice();
      }

      await tts.setSpeechRate(speechRate.clamp(0.25, 1.0));
      await tts.speak(cleanText);
      return true;
    } on MissingPluginException {
      _activeUtteranceId.value = null;
      return false;
    } catch (_) {
      _activeUtteranceId.value = null;
      return false;
    }
  }

  Future<bool> openDeviceTtsSettings() async {
    if (_openDeviceTtsSettingsHandler != null) {
      return _openDeviceTtsSettingsHandler();
    }
    try {
      final opened = await _ttsSettingsChannel.invokeMethod<bool>(
        'openDeviceTtsSettings',
      );
      return opened ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  Future<void> stop() async {
    _activeUtteranceId.value = null;
    try {
      await _tts?.stop();
    } on MissingPluginException {
      // Ignore on unsupported test platforms.
    } catch (_) {
      // Ignore cleanup errors.
    }
  }

  Future<void> dispose() async {
    await stop();
    _activeUtteranceId.dispose();
  }
}
