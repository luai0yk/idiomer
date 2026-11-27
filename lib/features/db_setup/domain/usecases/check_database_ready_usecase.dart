import 'package:idiomer/features/db_setup/domain/repositories/db_setup_repository.dart';

class CheckDatabaseReadyUseCase {
  final DbSetupRepository _repository;

  const CheckDatabaseReadyUseCase(this._repository);

  Future<bool> call() => _repository.isDatabaseReady();
}
