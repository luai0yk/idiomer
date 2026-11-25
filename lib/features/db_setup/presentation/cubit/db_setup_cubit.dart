import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/features/db_setup/domain/entities/db_setup_progress.dart';
import 'package:idiomer/features/db_setup/domain/usecases/initialize_database_usecase.dart';

import 'db_setup_state.dart';

class DbSetupCubit extends Cubit<DbSetupState> {
  final InitializeDatabaseUseCase _initializeDatabase;
  StreamSubscription<DbSetupProgress>? _subscription;

  DbSetupCubit({required InitializeDatabaseUseCase initializeDatabase})
    : _initializeDatabase = initializeDatabase,
      super(const DbSetupState());

  Future<void> startSetup() async {
    await _subscription?.cancel();
    if (isClosed) return;
    emit(const DbSetupState(stage: DbSetupStage.checking));

    _subscription = _initializeDatabase().listen(
      (progress) {
        if (!isClosed) {
          emit(DbSetupState.fromProgress(progress));
        }
      },
      onError: (Object error) {
        if (!isClosed) {
          emit(
            DbSetupState(
              stage: DbSetupStage.error,
              errorType: DbSetupErrorType.unknown,
              errorDetail: error.toString(),
            ),
          );
        }
      },
    );
  }

  void retry() {
    startSetup();
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
