import 'dart:io';

import 'package:path/path.dart';

void convertAssets(String path) async {
  final directory = Directory(path);
  if (!await directory.exists()) {
    throw FileSystemException(
      "This path provided is not a directory",
    );
  }
  final files = directory.listSync(
    recursive: false,
    followLinks: false,
  );
  for (var e in files) {
    if (e is Directory) {
      convertAssets(e.path);
      continue;
    }
    if (e is! File || !extension(e.path).endsWith('.svg')) {
      continue;
    }
    await handleAsset(directory, e);
  }
}

Future<void> handleAsset(Directory directory, File file) async {
  if (File('${file.path}.vec').existsSync()) {
    file.deleteSync();
    return;
  }
  var process = await Process.run(
    'dart',
    ['run', 'vector_graphics_compiler', '-i', file.path, '-o', '${file.path}.vec'],
  );
  file.deleteSync();
}
