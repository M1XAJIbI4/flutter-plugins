# xdga_directories

A Dart package for reading directory path on Aurora OS.
Documentation for setting permissions can be found [here](https://developer.auroraos.ru/doc/software_development/reference/user_data).

To use this package, the basic XDG values for the following are available via a Dart API:

- `getAppDataLocation` - Returns a directory location where persistent application data can be stored.
- `getCacheLocation` - Returns a directory location where user-specific non-essential (cached) data should be written.
- `getDocumentsLocation` - Returns the directory containing user document files.
- `getDownloadLocation` - Returns a directory for user's downloaded files.
- `getMusicLocation` - Returns the directory containing the user's music or other audio files.
- `getPicturesLocation` - Returns the directory containing the user's pictures or photos.
- `getGenericDataLocation` - Returns a directory location where persistent data shared across applications can be stored.
- `getMoviesLocation` - Returns the directory containing the user's movies and videos.

## Usage

**pubspec.yaml**

```yaml
dependencies:
  xdga_directories:
    git:
      url: https://gitlab.com/omprussia/flutter/flutter-plugins.git
      ref: xdga_directories-0.0.1
      path: packages/xdga_directories
```

***.desktop**

```desktop
Permissions=UserDirs 
```

***.dart**

```dart
import 'package:xdga_directories/xdga_directories.dart' as xdga;

final appDataLocation = xdga.getAppDataLocation();
final cacheLocation = xdga.getCacheLocation();
final documentsLocation = xdga.getDocumentsLocation();
final downloadLocation = xdga.getDownloadLocation();
final musicLocation = xdga.getMusicLocation();
final picturesLocation = xdga.getPicturesLocation();
final genericDataLocation = xdga.getGenericDataLocation();
final moviesLocation = xdga.getMoviesLocation();
```
