import 'package:equatable/equatable.dart';
import 'package:idiomer/features/db_setup/domain/entities/db_setup_progress.dart';

class DbSetupState extends Equatable {
  final DbSetupStage stage;
  final double? progress;
  final int receivedBytes;
  final int totalBytes;
  final DbSetupErrorType? errorType;
  final String? errorDetail;

  const DbSetupState({
    this.stage = DbSetupStage.checking,
    this.progress,
    this.receivedBytes = 0,
    this.totalBytes = 0,
    this.errorType,
    this.errorDetail,
  });

  factory DbSetupState.fromProgress(DbSetupProgress data) {
    return DbSetupState(
      stage: data.stage,
      progress: data.progress,
      receivedBytes: data.receivedBytes,
      totalBytes: data.totalBytes,
      errorType: data.errorType,
      errorDetail: data.errorDetail,
    );
  }

  @override
  List<Object?> get props => [
    stage,
    progress,
    receivedBytes,
    totalBytes,
    errorType,
    errorDetail,
  ];
}
