import 'package:idiomer/features/settings/domain/repositories/settings_repository.dart';

class UpdateTtsSpeechRateUseCase {
  final SettingsRepository _repository;

  const UpdateTtsSpeechRateUseCase(this._repository);

  Future<void> call(double speechRate) =>
      _repository.saveTtsSpeechRate(speechRate);
}
