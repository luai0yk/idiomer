import 'package:idiomer/features/settings/domain/entities/app_settings.dart';
import 'package:idiomer/features/settings/domain/repositories/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository _repository;

  const GetSettingsUseCase(this._repository);

  AppSettings call() => _repository.getSettings();
}
