import 'package:idiomer/core/services/tts/tts_service.dart';
import 'package:idiomer/features/settings/domain/repositories/settings_repository.dart';

class UpdateTtsAccentUseCase {
  final SettingsRepository _repository;

  const UpdateTtsAccentUseCase(this._repository);

  Future<void> call(TtsAccent accent) => _repository.saveTtsAccent(accent);
}
