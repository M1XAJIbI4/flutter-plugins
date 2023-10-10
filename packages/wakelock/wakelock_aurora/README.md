# wakelock_aurora

The Aurora implementation of [`wakelock`](https://pub.dev/packages/wakelock).

## Usage
This package is not an _endorsed_ implementation of `wakelock`. 
Therefore, you have to include `wakelock_aurora` alongside `wakelock` as dependencies in your `pubspec.yaml` file.

**pubspec.yaml**

```yaml
dependencies:
  wakelock: ^0.6.2
  wakelock_aurora:
    git:
      url: https://gitlab.com/omprussia/flutter/flutter-plugins.git
      ref: flutter-aurora-3.3.10
      path: packages/wakelock/wakelock_aurora
```

***.dart**

```dart
import 'package:wakelock/wakelock.dart';

// The following line will enable wakelock.
Wakelock.enable();

// The next line disables the wakelock again.
Wakelock.disable();
```
