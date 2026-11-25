import 'package:equatable/equatable.dart';

enum DbSetupStage { checking, downloading, extracting, verifying, ready, error }

enum DbSetupErrorType {
  noInternet,
  networkError,
  extractionFailed,
  verificationFailed,
  unknown,
}

class DbSetupProgress extends Equatable {
  final DbSetupStage stage;
  final double? progress;
  final int receivedBytes;
  final int totalBytes;
  final DbSetupErrorType? errorType;
  final String? errorDetail;

  const DbSetupProgress({
    required this.stage,
    this.progress,
    this.receivedBytes = 0,
    this.totalBytes = 0,
    this.errorType,
    this.errorDetail,
  });

  const DbSetupProgress.checking() : this(stage: DbSetupStage.checking);

  const DbSetupProgress.downloading({
    double? progress,
    int receivedBytes = 0,
    int totalBytes = 0,
  }) : this(
         stage: DbSetupStage.downloading,
         progress: progress,
         receivedBytes: receivedBytes,
         totalBytes: totalBytes,
       );

  const DbSetupProgress.extracting({double? progress})
    : this(stage: DbSetupStage.extracting, progress: progress);

  const DbSetupProgress.verifying() : this(stage: DbSetupStage.verifying);

  const DbSetupProgress.ready()
    : this(stage: DbSetupStage.ready, progress: 1.0);

  const DbSetupProgress.error({
    required DbSetupErrorType errorType,
    String? errorDetail,
  }) : this(
         stage: DbSetupStage.error,
         errorType: errorType,
         errorDetail: errorDetail,
       );

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
