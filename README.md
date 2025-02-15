# SVG to Vector Converter

## Overview
This package provides a utility for converting SVG assets into vector graphics format (`.svg.vec`) and updating Dart files to use the new format. It helps optimize SVG handling in Flutter applications by using `vector_graphics` for better performance.

## Features
- Converts SVG files to `.vec` format for efficient rendering.
- Updates Dart files to replace `SvgPicture.asset` with `AssetBytesLoader`.
- Supports processing both code and asset files.
- Configurable options for converting only code files, only asset files, or both.

## Installation
Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  svg_to_vec_converter:
    git:
      url: https://github.com/your-repo/svg_to_vec_converter
```

Run:
```sh
flutter pub get
```

## Usage
Run the conversion tool with the following command:

```sh
dart run svg_to_vec_converter [options]
```

### Options:
- `--code-input` (default: `lib/`): Directory containing Dart files to update.
- `--assets-input` (default: `assets/`): Directory containing SVG files to convert.
- `--mode` (default: `both`): Choose conversion mode.
    - `code-only`: Convert only Dart files.
    - `assets-only`: Convert only asset files.
    - `both`: Convert both Dart and asset files.

### Example Usage:
```sh
dart run svg_to_vec_converter --code-input=lib/ --assets-input=assets/ --mode=both
```

## How It Works
1. **Asset Conversion**
    - Recursively scans the provided assets directory for `.svg` files.
    - Converts each SVG file to `.vec` format using `vector_graphics_compiler`.
    - Deletes the original `.svg` file after conversion.

2. **Dart File Conversion**
    - Scans the provided code directory for Dart files containing `SvgPicture.asset`.
    - Replaces occurrences of `SvgPicture.asset('path/to/file.svg')` with `SvgPicture(AssetBytesLoader('path/to/file.svg.vec'))`.
    - Ensures `vector_graphics` is imported in the Dart file if needed.

## Dependencies
- `vector_graphics_compiler` (for SVG to `.vec` conversion)
- `vector_graphics` (for loading vector graphics in Flutter)
- `args` (for parsing command-line arguments)

## Notes
- Ensure that `vector_graphics_compiler` is installed:
  ```sh
  dart pub global activate vector_graphics_compiler
  ```
- The tool removes original `.svg` files after conversion. Make sure you have backups if needed.
- Generated `.vec` files must be included in your app's assets.

## License
This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

