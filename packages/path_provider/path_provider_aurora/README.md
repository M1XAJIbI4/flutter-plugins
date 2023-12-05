# path_provider_aurora

The Aurora OS implementation of [`path_provider`](https://pub.dev/packages/path_provider).
Documentation for setting permissions can be found [here](https://developer.auroraos.ru/doc/software_development/reference/user_data).

## Usage

This package is not an _endorsed_ implementation of `path_provider`.
Therefore, you have to include `path_provider_aurora` alongside `path_provider` as dependencies in your `pubspec.yaml` file.

**pubspec.yaml**

```yaml
dependencies:
  path_provider: ^2.1.1
  path_provider_aurora:
    git:
      url: https://gitlab.com/omprussia/flutter/flutter-plugins.git
      ref: master
      path: packages/path_provider/path_provider_aurora
```

***.dart**

```dart
import 'package:path_provider/path_provider.dart';

final Directory tempDir = await getTemporaryDirectory();

final Directory appDocumentsDir = await getApplicationDocumentsDirectory();

final Directory? downloadsDir = await getDownloadsDirectory();
```

## Supported APIs

- [x] `getTemporaryDirectory` - Directory location where user-specific non-essential (cached) data should be written
- [x] `getApplicationSupportDirectory` - Directory where the application may place application support files.
- [ ] `getLibraryDirectory`
- [x] `getApplicationDocumentsDirectory` - Directory containing user document files.
- [ ] `getExternalStorageDirectory`
- [ ] `getExternalCacheDirectories`
- [x] `getExternalStorageDirectories` - There is no concept of External in Aurora OS, but this interface allows you to get the pictures/music/movies directory
- [x] `getDownloadsDirectory`- Directory for user's downloaded files.
