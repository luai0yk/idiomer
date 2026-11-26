import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/core/utils/helpers/misc/idiom_image_saver.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory tempDownloadsDir;

  setUp(() async {
    tempDownloadsDir = await Directory.systemTemp.createTemp('idiomer_dl_');
  });

  tearDown(() async {
    if (await tempDownloadsDir.exists()) {
      await tempDownloadsDir.delete(recursive: true);
    }
  });

  test('buildFileName uses sanitized idiom text followed by date and time', () {
    final now = DateTime(2026, 11, 25, 22, 16, 5);
    final fileName = IdiomImageSaver.buildFileName(
      'Break the ice: / Test?',
      now: now,
    );

    expect(fileName, 'Break the ice Test_2026-11-25_22-16-05.png');
  });

  test('saveToDownloads saves directly inside Downloads/Idiomer/', () async {
    final bytes = Uint8List.fromList([137, 80, 78, 71]);
    final now = DateTime(2026, 11, 25, 22, 16, 5);

    final savedPath = await IdiomImageSaver.saveToDownloads(
      bytes: bytes,
      idiomText: 'Break the ice',
      now: now,
      downloadsDirectoryProvider: () async => tempDownloadsDir,
    );

    final expectedPath = p.join(
      tempDownloadsDir.path,
      'Idiomer',
      'Break the ice_2026-11-25_22-16-05.png',
    );
    expect(savedPath, expectedPath);
    expect(await File(savedPath).exists(), isTrue);
    expect(await File(savedPath).readAsBytes(), bytes);
  });
}
