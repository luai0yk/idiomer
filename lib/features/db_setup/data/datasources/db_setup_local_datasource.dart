import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:idiomer/core/database/app_database.dart';
import 'package:idiomer/core/database/database_paths.dart';
import 'package:koni_archive/io.dart';
import 'package:path/path.dart' as p;

class DbExtractionException implements Exception {
  final String message;

  const DbExtractionException(this.message);

  @override
  String toString() => 'DbExtractionException: $message';
}

class DbVerificationException implements Exception {
  final String message;

  const DbVerificationException(this.message);

  @override
  String toString() => 'DbVerificationException: $message';
}

abstract class DbSetupLocalDataSource {
  Future<bool> isDatabaseValid();
  Future<File> getArchiveFile();
  Future<File> getTempArchiveFile();
  Future<void> extractArchive(
    File archiveFile, {
    required void Function(double progress) onProgress,
  });
  Future<void> verifyDatabase();
  Future<void> cleanupTempFiles();
}

class DbSetupLocalDataSourceImpl implements DbSetupLocalDataSource {
  final DatabasePaths _paths;
  final AppDatabase _database;

  DbSetupLocalDataSourceImpl({
    required DatabasePaths paths,
    required AppDatabase database,
  }) : _paths = paths,
       _database = database;

  @override
  Future<bool> isDatabaseValid() async {
    final dbFile = await _paths.getDatabaseFile();
    if (!await dbFile.exists() || await dbFile.length() == 0) {
      return false;
    }

    final isReady = await _database.verifyReady();
    if (!isReady) {
      // Remove incomplete or corrupted database file so setup can redownload.
      await dbFile.delete();
      return false;
    }

    return true;
  }

  @override
  Future<File> getArchiveFile() => _paths.getArchiveFile();

  @override
  Future<File> getTempArchiveFile() => _paths.getTempArchiveFile();

  @override
  Future<void> extractArchive(
    File archiveFile, {
    required void Function(double progress) onProgress,
  }) async {
    if (!await archiveFile.exists() || await archiveFile.length() == 0) {
      throw const DbExtractionException('Downloaded archive file is missing.');
    }

    final targetDbFile = await _paths.getDatabaseFile();
    final tempDbFile = await _paths.getTempDatabaseFile();
    await targetDbFile.parent.create(recursive: true);

    if (await tempDbFile.exists()) {
      await tempDbFile.delete();
    }

    await _extractInBackground(
      archivePath: archiveFile.path,
      targetPath: tempDbFile.path,
      onProgress: onProgress,
    );

    if (!await tempDbFile.exists() || await tempDbFile.length() == 0) {
      throw const DbExtractionException(
        'Extracted database file is missing or empty.',
      );
    }

    if (await targetDbFile.exists()) {
      await targetDbFile.delete();
    }
    await tempDbFile.rename(targetDbFile.path);

    if (await archiveFile.exists()) {
      await archiveFile.delete();
    }
  }

  @override
  Future<void> verifyDatabase() async {
    final ready = await _database.verifyReady();
    if (!ready) {
      final dbFile = await _paths.getDatabaseFile();
      if (await dbFile.exists()) {
        await dbFile.delete();
      }
      throw const DbVerificationException(
        'Extracted database failed integrity verification.',
      );
    }
  }

  @override
  Future<void> cleanupTempFiles() async {
    for (final file in [
      await _paths.getTempArchiveFile(),
      await _paths.getArchiveFile(),
      await _paths.getTempDatabaseFile(),
    ]) {
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  Future<void> _extractInBackground({
    required String archivePath,
    required String targetPath,
    required void Function(double progress) onProgress,
  }) async {
    final receivePort = ReceivePort();
    final errorPort = ReceivePort();
    final completer = Completer<void>();

    late final StreamSubscription<dynamic> sub;
    late final StreamSubscription<dynamic> errSub;

    sub = receivePort.listen((message) {
      if (message is double) {
        onProgress(message);
      } else if (message == 'done') {
        if (!completer.isCompleted) completer.complete();
      } else if (message is String && message.startsWith('error:')) {
        if (!completer.isCompleted) {
          completer.completeError(
            DbExtractionException(message.substring('error:'.length)),
          );
        }
      }
    });

    errSub = errorPort.listen((err) {
      if (!completer.isCompleted) {
        completer.completeError(DbExtractionException(err.toString()));
      }
    });

    await Isolate.spawn(
      _extractWorker,
      _ExtractParams(
        archivePath: archivePath,
        targetPath: targetPath,
        sendPort: receivePort.sendPort,
      ),
      onError: errorPort.sendPort,
    );

    try {
      await completer.future;
    } finally {
      await sub.cancel();
      await errSub.cancel();
      receivePort.close();
      errorPort.close();
    }
  }
}

class _ExtractParams {
  final String archivePath;
  final String targetPath;
  final SendPort sendPort;

  const _ExtractParams({
    required this.archivePath,
    required this.targetPath,
    required this.sendPort,
  });
}

Future<void> _extractWorker(_ExtractParams params) async {
  try {
    final archive = await openArchiveFile(params.archivePath);
    try {
      ArchiveEntry? dbEntry;
      for (final entry in archive.entries) {
        if (entry.isFile && p.extension(entry.path).toLowerCase() == '.db') {
          dbEntry = entry;
          break;
        }
      }
      dbEntry ??= archive.entries.where((e) => e.isFile).firstOrNull;

      if (dbEntry == null) {
        params.sendPort.send(
          'error:No database file found inside the 7z archive.',
        );
        return;
      }

      final totalBytes = dbEntry.uncompressedSize;
      var writtenBytes = 0;
      var lastReportedPercent = -1;

      final outFile = File(params.targetPath);
      final sink = outFile.openWrite();
      try {
        await for (final chunk in archive.openRead(dbEntry)) {
          sink.add(chunk);
          writtenBytes += chunk.length;
          if (totalBytes > 0) {
            final ratio = (writtenBytes / totalBytes).clamp(0.0, 1.0);
            final percent = (ratio * 100).floor();
            if (percent != lastReportedPercent) {
              lastReportedPercent = percent;
              params.sendPort.send(ratio);
            }
          }
        }
        await sink.flush();
      } finally {
        await sink.close();
      }

      params.sendPort.send(1.0);
      params.sendPort.send('done');
    } finally {
      await archive.close();
    }
  } catch (e) {
    params.sendPort.send('error:$e');
  }
}
