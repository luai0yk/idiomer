import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Saves rendered idiom card PNG bytes directly into `Downloads/Idiomer/`
/// without opening a system folder picker.
class IdiomImageSaver {
  IdiomImageSaver._();

  static const String subFolderName = 'Idiomer';
  static const MethodChannel _downloadsChannel = MethodChannel(
    'com.luai0yk.idiomer/downloads',
  );

  /// Builds a filesystem-safe PNG filename using the idiom text followed by
  /// the current date and time (e.g. `Break the ice_2026-11-25_22-16-05.png`).
  static String buildFileName(String idiomText, {DateTime? now}) {
    final timestamp = DateFormat(
      'yyyy-MM-dd_HH-mm-ss',
    ).format(now ?? DateTime.now());

    // Strip characters that are invalid on Windows, macOS, Linux, or Android.
    final sanitizedIdiom = idiomText
        .trim()
        .replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final baseName = sanitizedIdiom.isEmpty ? 'idiom' : sanitizedIdiom;
    final truncatedBase = baseName.length > 80
        ? baseName.substring(0, 80).trim()
        : baseName;

    return '${truncatedBase}_$timestamp.png';
  }

  /// Saves [bytes] directly to `Downloads/Idiomer/<fileName>` and returns the
  /// destination path.
  static Future<String> saveToDownloads({
    required Uint8List bytes,
    required String idiomText,
    DateTime? now,
    Future<Directory?> Function()? downloadsDirectoryProvider,
  }) async {
    final fileName = buildFileName(idiomText, now: now);

    if (downloadsDirectoryProvider == null && !kIsWeb && Platform.isAndroid) {
      try {
        final savedPath = await _downloadsChannel.invokeMethod<String>(
          'saveImageToDownloads',
          <String, dynamic>{
            'bytes': bytes,
            'fileName': fileName,
            'subFolder': subFolderName,
          },
        );
        if (savedPath != null && savedPath.isNotEmpty) {
          return savedPath;
        }
      } on MissingPluginException {
        // Fallback to direct file write when running without Android host.
      }
    }

    final baseDir = await _resolveBaseDirectory(downloadsDirectoryProvider);
    final targetDir = Directory(p.join(baseDir.path, subFolderName));
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final file = File(p.join(targetDir.path, fileName));
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  static Future<Directory> _resolveBaseDirectory(
    Future<Directory?> Function()? downloadsDirectoryProvider,
  ) async {
    if (downloadsDirectoryProvider != null) {
      final dir = await downloadsDirectoryProvider();
      if (dir != null) return dir;
    }

    try {
      final downloads = await getDownloadsDirectory();
      if (downloads != null) return downloads;
    } catch (_) {
      // Fall through to platform/documents fallback.
    }

    if (!kIsWeb && Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    }

    final docs = await getApplicationDocumentsDirectory();
    return Directory(p.join(docs.path, 'Downloads'));
  }
}
