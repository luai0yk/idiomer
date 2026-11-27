import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/features/db_setup/data/datasources/db_setup_local_datasource.dart';
import 'package:idiomer/features/db_setup/data/datasources/db_setup_remote_datasource.dart';
import 'package:idiomer/features/db_setup/data/repositories/db_setup_repository_impl.dart';
import 'package:idiomer/features/db_setup/domain/entities/db_setup_progress.dart';
import 'package:idiomer/features/db_setup/domain/usecases/check_database_ready_usecase.dart';
import 'package:idiomer/features/db_setup/domain/usecases/initialize_database_usecase.dart';
import 'package:idiomer/features/db_setup/presentation/cubit/db_setup_cubit.dart';
import 'package:idiomer/features/db_setup/presentation/cubit/db_setup_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalDataSource extends Mock implements DbSetupLocalDataSource {}

class _MockRemoteDataSource extends Mock implements DbSetupRemoteDataSource {}

void main() {
  late _MockLocalDataSource local;
  late _MockRemoteDataSource remote;
  late DbSetupRepositoryImpl repository;
  late Directory tempDir;

  setUpAll(() {
    registerFallbackValue(File('fallback.7z'));
  });

  setUp(() async {
    local = _MockLocalDataSource();
    remote = _MockRemoteDataSource();
    repository = DbSetupRepositoryImpl(local: local, remote: remote);
    tempDir = await Directory.systemTemp.createTemp('idiomer_setup_test_');
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('isDatabaseReady delegates to local data source validity check', () async {
    final useCase = CheckDatabaseReadyUseCase(repository);

    when(() => local.isDatabaseValid()).thenAnswer((_) async => true);
    expect(await useCase(), isTrue);

    when(() => local.isDatabaseValid()).thenAnswer((_) async => false);
    expect(await useCase(), isFalse);
  });

  test('skips download when local database is already valid', () async {
    when(() => local.isDatabaseValid()).thenAnswer((_) async => true);

    final events = await repository.initializeDatabase().toList();

    expect(events, const [DbSetupProgress.checking(), DbSetupProgress.ready()]);
    verifyNever(() => remote.hasInternetConnection());
  });

  test('emits noInternet error when connectivity check fails', () async {
    when(() => local.isDatabaseValid()).thenAnswer((_) async => false);
    when(() => remote.hasInternetConnection()).thenAnswer((_) async => false);

    final events = await repository.initializeDatabase().toList();

    expect(events, const [
      DbSetupProgress.checking(),
      DbSetupProgress.error(errorType: DbSetupErrorType.noInternet),
    ]);
  });

  test(
    'downloads, extracts, and verifies database with progress updates',
    () async {
      final partFile = File('${tempDir.path}/english_idioms.7z.part');
      final archiveFile = File('${tempDir.path}/english_idioms.7z');

      when(() => local.isDatabaseValid()).thenAnswer((_) async => false);
      when(() => local.cleanupTempFiles()).thenAnswer((_) async {});
      when(() => local.getTempArchiveFile()).thenAnswer((_) async => partFile);
      when(() => local.getArchiveFile()).thenAnswer((_) async => archiveFile);
      when(() => remote.hasInternetConnection()).thenAnswer((_) async => true);
      when(
        () => remote.downloadDatabase(
          url: any(named: 'url'),
          savePath: any(named: 'savePath'),
          cancelToken: any(named: 'cancelToken'),
          onProgress: any(named: 'onProgress'),
        ),
      ).thenAnswer((invocation) async {
        final savePath = invocation.namedArguments[#savePath] as String;
        await File(savePath).writeAsBytes([1, 2, 3, 4]);
        final onProgress =
            invocation.namedArguments[#onProgress] as void Function(int, int);
        onProgress(50, 100);
        onProgress(100, 100);
      });
      when(
        () => local.extractArchive(any(), onProgress: any(named: 'onProgress')),
      ).thenAnswer((invocation) async {
        final onProgress =
            invocation.namedArguments[#onProgress] as void Function(double);
        onProgress(0.5);
        onProgress(1.0);
      });
      when(() => local.verifyDatabase()).thenAnswer((_) async {});

      final events = await repository.initializeDatabase().toList();

      expect(events.map((e) => e.stage).toList(), [
        DbSetupStage.checking,
        DbSetupStage.downloading,
        DbSetupStage.downloading,
        DbSetupStage.downloading,
        DbSetupStage.extracting,
        DbSetupStage.extracting,
        DbSetupStage.extracting,
        DbSetupStage.verifying,
        DbSetupStage.ready,
      ]);
    },
  );

  test('cleans up temp files and emits error when download fails', () async {
    final partFile = File('${tempDir.path}/english_idioms.7z.part');
    final archiveFile = File('${tempDir.path}/english_idioms.7z');

    when(() => local.isDatabaseValid()).thenAnswer((_) async => false);
    when(() => local.cleanupTempFiles()).thenAnswer((_) async {});
    when(() => local.getTempArchiveFile()).thenAnswer((_) async => partFile);
    when(() => local.getArchiveFile()).thenAnswer((_) async => archiveFile);
    when(() => remote.hasInternetConnection()).thenAnswer((_) async => true);
    when(
      () => remote.downloadDatabase(
        url: any(named: 'url'),
        savePath: any(named: 'savePath'),
        cancelToken: any(named: 'cancelToken'),
        onProgress: any(named: 'onProgress'),
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/english_idioms.7z'),
        type: DioExceptionType.connectionTimeout,
      ),
    );

    final events = await repository.initializeDatabase().toList();

    expect(events.last.stage, DbSetupStage.error);
    expect(events.last.errorType, DbSetupErrorType.noInternet);
    verify(() => local.cleanupTempFiles()).called(2);
  });

  blocTest<DbSetupCubit, DbSetupState>(
    'DbSetupCubit streams progress and supports retry',
    build: () {
      var attempts = 0;
      when(() => local.isDatabaseValid()).thenAnswer((_) async => false);
      when(() => remote.hasInternetConnection()).thenAnswer((_) async {
        attempts++;
        return attempts > 1;
      });
      when(() => local.cleanupTempFiles()).thenAnswer((_) async {});
      when(
        () => local.getTempArchiveFile(),
      ).thenAnswer((_) async => File('${tempDir.path}/english_idioms.7z.part'));
      when(
        () => local.getArchiveFile(),
      ).thenAnswer((_) async => File('${tempDir.path}/english_idioms.7z'));
      when(
        () => remote.downloadDatabase(
          url: any(named: 'url'),
          savePath: any(named: 'savePath'),
          cancelToken: any(named: 'cancelToken'),
          onProgress: any(named: 'onProgress'),
        ),
      ).thenAnswer((invocation) async {
        final savePath = invocation.namedArguments[#savePath] as String;
        await File(savePath).writeAsBytes([1, 2, 3]);
      });
      when(
        () => local.extractArchive(any(), onProgress: any(named: 'onProgress')),
      ).thenAnswer((_) async {});
      when(() => local.verifyDatabase()).thenAnswer((_) async {});

      return DbSetupCubit(
        initializeDatabase: InitializeDatabaseUseCase(repository),
      );
    },
    act: (cubit) async {
      await cubit.startSetup();
      await Future<void>.delayed(const Duration(milliseconds: 30));
      cubit.retry();
      await Future<void>.delayed(const Duration(milliseconds: 50));
    },
    expect: () => containsAllInOrder([
      const DbSetupState(stage: DbSetupStage.checking),
      const DbSetupState(
        stage: DbSetupStage.error,
        errorType: DbSetupErrorType.noInternet,
      ),
      const DbSetupState(stage: DbSetupStage.checking),
      const DbSetupState(stage: DbSetupStage.ready, progress: 1.0),
    ]),
  );
}
