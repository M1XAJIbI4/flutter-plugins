# battery_plus_aurora

The Aurora implementation of [`battery_plus`](https://pub.dev/packages/battery_plus).

A Flutter plugin to access various information about the battery of the device the app is running on.

## Usage

This package is not an _endorsed_ implementation of `battery_plus`.
Therefore, you have to include `battery_plus_aurora`
alongside `battery_plus` as dependencies in your `pubspec.yaml` file.

**pubspec.yaml**

 ```yaml
dependencies:
  battery_plus: ^4.0.1
  battery_plus_aurora:
    git:
      url: https://gitlab.com/omprussia/flutter/flutter-plugins.git
      ref: battery_plus_aurora-0.0.1
      path: packages/battery_plus/battery_plus_aurora
 ```

***.dart**

```dart
// Import package
import 'package:battery_plus/battery_plus.dart';

// Instantiate it
var battery = Battery();

// Get current battery level
final batteryLevel = await battery.batteryLevel;
// Get current battery state
final batteryState = await battery.batteryState;
// Check is enable SaveMode
final isInBatterySaveMode = await battery.isInBatterySaveMode;

// Be informed when the state (full, charging, discharging) changes
battery.onBatteryStateChanged.listen((BatteryState state) {
  debugPrint(state.toString());
});
 ```
