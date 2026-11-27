import 'package:idiomer/features/settings/domain/entities/app_settings.dart';
import 'package:idiomer/features/settings/domain/repositories/settings_repository.dart';

class UpdateDefaultTabUseCase {
  final SettingsRepository _repository;

  const UpdateDefaultTabUseCase(this._repository);

  Future<void> call(DefaultAppTab tab) => _repository.saveDefaultTab(tab);
}
