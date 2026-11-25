import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:idiomer/core/constants/app_constants.dart';
import 'package:idiomer/features/db_setup/data/datasources/db_setup_local_datasource.dart';
import 'package:idiomer/features/db_setup/data/datasources/db_setup_remote_datasource.dart';
import 'package:idiomer/features/db_setup/domain/entities/db_setup_progress.dart';
import 'package:idiomer/features/db_setup/domain/repositories/db_setup_repository.dart';

class DbSetupRepositoryImpl implements DbSetupRepository {
  final DbSetupLocalDataSource _local;
  final DbSetupRemoteDataSource _remote;

  const DbSetupRepositoryImpl({
    required DbSetupLocalDataSource local,
    required DbSetupRemoteDataSource remote,
  }) : _local = local,
       _remote = remote;

  @override
  Stream<DbSetupProgress> initializeDatabase() {
    final controller = StreamController<DbSetupProgress>();
    final cancelToken = CancelToken();

    controller.onCancel = () {
      if (!cancelToken.isCancelled) {
        cancelToken.cancel('Setup cancelled');
      }
    };

    Future<void> run() async {
      try {
        controller.add(const DbSetupProgress.checking());

        if (await _local.isDatabaseValid()) {
          controller.add(const DbSetupProgress.ready());
          await controller.close();
          return;
        }

        if (!await _remote.hasInternetConnection()) {
          controller.add(
            const DbSetupProgress.error(errorType: DbSetupErrorType.noInternet),
          );
          await controller.close();
          return;
        }

        await _local.cleanupTempFiles();
        final tempArchiveFile = await _local.getTempArchiveFile();
        final archiveFile = await _local.getArchiveFile();

        controller.add(const DbSetupProgress.downloading(progress: 0));
        await _remote.downloadDatabase(
          url: AppConstants.dbLink,
          savePath: tempArchiveFile.path,
          cancelToken: cancelToken,
          onProgress: (received, total) {
            if (controller.isClosed) return;
            final progress = total > 0
                ? (received / total).clamp(0.0, 1.0)
                : null;
            controller.add(
              DbSetupProgress.downloading(
                progress: progress,
                receivedBytes: received,
                totalBytes: total,
              ),
            );
          },
        );

        if (await archiveFile.exists()) {
          await archiveFile.delete();
        }
        await tempArchiveFile.rename(archiveFile.path);

        if (controller.isClosed) return;
        controller.add(const DbSetupProgress.extracting(progress: 0));
        await _local.extractArchive(
          archiveFile,
          onProgress: (progress) {
            if (!controller.isClosed) {
              controller.add(DbSetupProgress.extracting(progress: progress));
            }
          },
        );

        if (controller.isClosed) return;
        controller.add(const DbSetupProgress.verifying());
        await _local.verifyDatabase();

        if (!controller.isClosed) {
          controller.add(const DbSetupProgress.ready());
        }
      } on DioException catch (e) {
        await _local.cleanupTempFiles();
        if (!controller.isClosed) {
          final isConnectionFailure =
              e.type == DioExceptionType.connectionError ||
              e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.sendTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.error is SocketException;
          controller.add(
            DbSetupProgress.error(
              errorType: isConnectionFailure
                  ? DbSetupErrorType.noInternet
                  : DbSetupErrorType.networkError,
              errorDetail: e.message,
            ),
          );
        }
      } on DbExtractionException catch (e) {
        await _local.cleanupTempFiles();
        if (!controller.isClosed) {
          controller.add(
            DbSetupProgress.error(
              errorType: DbSetupErrorType.extractionFailed,
              errorDetail: e.message,
            ),
          );
        }
      } on DbVerificationException catch (e) {
        await _local.cleanupTempFiles();
        if (!controller.isClosed) {
          controller.add(
            DbSetupProgress.error(
              errorType: DbSetupErrorType.verificationFailed,
              errorDetail: e.message,
            ),
          );
        }
      } catch (e) {
        await _local.cleanupTempFiles();
        if (!controller.isClosed) {
          controller.add(
            DbSetupProgress.error(
              errorType: DbSetupErrorType.unknown,
              errorDetail: e.toString(),
            ),
          );
        }
      } finally {
        if (!controller.isClosed) {
          await controller.close();
        }
      }
    }

    unawaited(run());
    return controller.stream;
  }
}
