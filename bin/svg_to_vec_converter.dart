import 'package:svg_to_vec_converter/convert_dart_assets.dart';
import 'package:svg_to_vec_converter/convert_dart_files.dart';
import 'package:svg_to_vec_converter/parser.dart';

void main(List<String> args) {
  final argResults = setupParser(args);
  // if (argResults.flag('help')) {
  //   printHelp();
  //   return;
  // }
  final option = argResults.option('mode')!;
  if (option == 'both') {
    convertDartFiles(argResults.option('code-input')!);
    convertAssets(argResults.option('assets-input')!);
    return;
  }
  if (option == 'code-only') {
    convertDartFiles(argResults.option('code-input')!);
  }
  if (option == 'assets-only') {
    convertAssets(argResults.option('assets-input')!);
  }
}
