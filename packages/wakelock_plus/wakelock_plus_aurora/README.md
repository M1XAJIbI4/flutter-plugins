# wakelock_plus_aurora

The Aurora implementation of [`wakelock_plus`](https://pub.dev/packages/wakelock_plus).

## Usage
This package is not an _endorsed_ implementation of `wakelock_plus`.
Therefore, you have to include `wakelock_plus_aurora` alongside `wakelock_plus` as dependencies in your `pubspec.yaml` file.

**pubspec.yaml**

```yaml
dependencies:
  wakelock_plus: ^1.1.1
  wakelock_plus_aurora:
    git:
      url: https://gitlab.com/omprussia/flutter/flutter-plugins.git
      ref: master
      path: packages/wakelock_plus/wakelock_plus_aurora
```

***.dart**

```dart
import 'package:wakelock_plus/wakelock_plus.dart';
// ...

// The following line will enable the Android and iOS wakelock.
WakelockPlus.enable();

// The next line disables the wakelock again.
WakelockPlus.disable();
```
