import 'package:idiomer/features/settings/domain/entities/app_settings.dart';
import 'package:idiomer/features/settings/domain/repositories/settings_repository.dart';

class UpdateIdiomTapActionUseCase {
  final SettingsRepository _repository;

  const UpdateIdiomTapActionUseCase(this._repository);

  Future<void> call(IdiomTapAction action) =>
      _repository.saveIdiomTapAction(action);
}
