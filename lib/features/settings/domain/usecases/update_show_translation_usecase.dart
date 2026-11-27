import 'package:idiomer/features/settings/domain/repositories/settings_repository.dart';

class UpdateShowTranslationUseCase {
  final SettingsRepository _repository;

  const UpdateShowTranslationUseCase(this._repository);

  Future<void> call(bool showTranslation) =>
      _repository.saveShowTranslation(showTranslation);
}
