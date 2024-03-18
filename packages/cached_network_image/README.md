# cached_network_image

Plugin support [cached_network_image](https://pub.dev/packages/cached_network_image).

The use of the `cached_network_image` plugin in the Aurora OS ecosystem is supported.
The plugin depends on a platform-dependent plugin, that is, it itself is platform-dependent.
But implementation is not required.

## Usage

You have to include `path_provider` & `path_provider_aurora`
alongside `cached_network_image` as dependencies in your `pubspec.yaml` file.

**pubspec.yaml**

```yaml
dependencies:
  cached_network_image: ^3.3.1
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
/// Import cached_network_image
import 'package:cached_network_image/cached_network_image.dart';
```

