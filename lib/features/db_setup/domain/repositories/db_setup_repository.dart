import 'package:idiomer/features/db_setup/domain/entities/db_setup_progress.dart';

abstract class DbSetupRepository {
  Stream<DbSetupProgress> initializeDatabase();
}
