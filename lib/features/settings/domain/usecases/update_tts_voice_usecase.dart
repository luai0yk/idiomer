import 'package:idiomer/core/services/tts/tts_service.dart';
import 'package:idiomer/features/settings/domain/repositories/settings_repository.dart';

class UpdateTtsVoiceUseCase {
  final SettingsRepository _repository;

  const UpdateTtsVoiceUseCase(this._repository);

  Future<void> call(TtsVoiceOption? voice) => _repository.saveTtsVoice(voice);
}
