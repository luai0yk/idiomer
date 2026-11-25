import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Resolves file locations inside the application's documents directory
/// for the downloaded archive and extracted SQLite database.
class DatabasePaths {
  const DatabasePaths({Future<Directory> Function()? directoryProvider})
    : _directoryProvider =
          directoryProvider ?? getApplicationDocumentsDirectory;

  static const String databaseFileName = 'english_idioms.db';
  static const String archiveFileName = 'english_idioms.7z';

  final Future<Directory> Function() _directoryProvider;

  Future<Directory> getDirectory() => _directoryProvider();

  Future<File> getDatabaseFile() async {
    final dir = await getDirectory();
    return File(p.join(dir.path, databaseFileName));
  }

  Future<File> getTempDatabaseFile() async {
    final dir = await getDirectory();
    return File(p.join(dir.path, '$databaseFileName.tmp'));
  }

  Future<File> getArchiveFile() async {
    final dir = await getDirectory();
    return File(p.join(dir.path, archiveFileName));
  }

  Future<File> getTempArchiveFile() async {
    final dir = await getDirectory();
    return File(p.join(dir.path, '$archiveFileName.part'));
  }
}
