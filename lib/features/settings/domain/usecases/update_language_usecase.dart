import 'package:idiomer/app/l10n/app_locales.dart';
import 'package:idiomer/features/settings/domain/repositories/settings_repository.dart';

class UpdateLanguageUseCase {
  final SettingsRepository _repository;

  const UpdateLanguageUseCase(this._repository);

  Future<void> call(LangCode langCode) => _repository.saveLanguage(langCode);
}
