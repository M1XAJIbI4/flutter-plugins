# package_info_plus_aurora

The Aurora implementation of [`package_info_plus`](https://pub.dev/packages/package_info_plus).

## Usage

This package is not an _endorsed_ implementation of `package_info_plus`.
Therefore, you have to include `package_info_plus_aurora` alongside `package_info_plus` as dependencies in your `pubspec.yaml` file.

**pubspec.yaml**

```yaml
dependencies:
  package_info_plus: 3.1.2
  package_info_plus_aurora:
    git:
      url: https://gitlab.com/omprussia/flutter/flutter-plugins.git
      ref: master
      path: packages/package_info_plus/package_info_plus_aurora
```

***.dart**

```dart
import 'package:package_info_plus/package_info_plus.dart';

PackageInfo packageInfo = await PackageInfo.fromPlatform();

String appName = packageInfo.appName;
String packageName = packageInfo.packageName;
```
