# sqflite_aurora

The Aurora OS implementation of [`sqflite`](https://pub.dev/packages/sqflite).

## Usage

This package is not an endorsed implementation of `sqflite`.
Therefore, you have to include `sqflite_aurora` alongside `sqflite` as dependencies in your `pubspec.yaml` file.

**pubspec.yaml**

```yaml
dependencies:
  sqflite: ^2.3.0
  sqflite_aurora:
    git:
      url: https://gitlab.com/omprussia/flutter/flutter-plugins.git
      ref: sqflite_aurora-0.0.1
      path: packages/sqflite/sqflite_aurora
```
***.desktop**

```desktop
Permissions=UserDirs
```

***.spec**

```spec
BuildRequires: pkgconfig(sqlite3)
```

***.dart**

```dart
import 'package:sqflite/sqflite.dart';
```

