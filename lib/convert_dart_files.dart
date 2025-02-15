import 'dart:io';

import 'package:path/path.dart';

void convertDartFiles(String path) async {
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
      convertDartFiles(e.path);
      continue;
    }
    if (e is! File || !extension(e.path).contains('dart')) {
      print(extension(e.path));
      print(e.runtimeType);
      print('skipping ${basename(e.path)} as it\'s not a dart file');
      continue;
    }
    handleFile(e);
  }
}

void handleFile(File file) {
  String fileContent = file.readAsStringSync();
  final matches = RegExp(r'SvgPicture.asset\([\s\S]*?\),').allMatches(
    fileContent,
  );

  if (matches.isEmpty) {
    print(
      'skipping ${basename(file.path)} as it does not contain any svg pictures',
    );
    return;
  }
  for (var e in matches) {
    final string = e.group(0)!;
    print('string ${string}');
    final pattern = RegExp(r'''('|")[\s\S]+?(('|")+?[\s\S]*)*('|")''');
    print(pattern.allMatches(string).map(
          (e) => e.group(0),
        ));
    var firstMatch = pattern.firstMatch(string)!;
    var assetString = firstMatch.group(0)!;
    print('assetString $assetString');
    String newAssetString = assetString.replaceAll(".svg", ".svg.vec");
    print(newAssetString);
    fileContent = fileContent.replaceFirst(
      assetString,
      'AssetBytesLoader($newAssetString)',
      e.start,
    );
  }
  fileContent = fileContent.replaceAll('SvgPicture.asset', 'SvgPicture');
  final containsImport = fileContent.contains(
    "import 'package:vector_graphics/vector_graphics.dart';",
  );
  if (!containsImport) {
    fileContent =
        "import 'package:vector_graphics/vector_graphics.dart';\n$fileContent";
  }
  file.writeAsStringSync(fileContent);
}
