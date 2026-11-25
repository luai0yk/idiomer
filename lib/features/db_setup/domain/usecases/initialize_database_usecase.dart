import 'package:idiomer/features/db_setup/domain/entities/db_setup_progress.dart';
import 'package:idiomer/features/db_setup/domain/repositories/db_setup_repository.dart';

class InitializeDatabaseUseCase {
  final DbSetupRepository _repository;

  const InitializeDatabaseUseCase(this._repository);

  Stream<DbSetupProgress> call() => _repository.initializeDatabase();
}
