# flutter_cache_manager

Plugin support [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager).

The use of the `flutter_cache_manager` plugin in the Aurora OS ecosystem is supported.
The plugin depends on a platform-dependent plugin, that is, it itself is platform-dependent.
But implementation is not required.

## Usage

You have to include `path_provider` & `path_provider_aurora`
alongside `flutter_cache_manager` as dependencies in your `pubspec.yaml` file.

**pubspec.yaml**

```yaml
dependencies:
  flutter_cache_manager: ^3.3.1
  path_provider: ^2.0.15
  path_provider_aurora:
    git:
      url: https://gitlab.com/omprussia/flutter/flutter-plugins.git
      ref: path_provider_aurora-0.0.1
      path: packages/path_provider/path_provider_aurora
```

***.desktop**

```desktop
Permissions=UserDirs;Internet
```

***.dart**

```dart
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

var file = await DefaultCacheManager().getSingleFile(url);
```

