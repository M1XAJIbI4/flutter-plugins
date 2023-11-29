# device_info_plus_aurora

The Aurora implementation of [`device_info_plus`](https://pub.dev/packages/device_info_plus).

Permission: `DeviceInfo`.

Information available:

- `id` - Target platform.
- `name` - Name OS.
- `version` - Versions OS.
- `prettyName` - Name and version OS.
- `hasGNSS` - The presence of GNSS in the device.
- `hasNFC` - The presence of NFC in the device.
- `hasBluetooth` - The presence of bluetooth in the device.
- `hasWlan` - The presence of wlan in the device.
- `maxCpuClockSpeed` - Max CPU clock speed.
- `numberCpuCores` - Number CPU cores.
- `batteryChargePercentage` - Device battery charge percentage.
- `mainCameraResolution` - Device main camera resolution.
- `frontalCameraResolution` - Device frontal camera resolution.
- `ramTotalSize` - Size total ram.
- `ramFreeSize` - Size free ram.
- `screenResolution` - Device screen resolution.
- `osVersion` - Name and version OS.
- `deviceModel` - Device name model.
- `internalStorage` - Map with information on internal storage.
- `internalStorage` - Map with information on internal storage.
- `simCards` - Array with information about SIM cards.

## Usage

This package is not an _endorsed_ implementation of `device_info_plus`.
Therefore, you have to include `device_info_plus_aurora` alongside `device_info_plus` as dependencies in your `pubspec.yaml` file.

**pubspec.yaml**

```yaml
dependencies:
  device_info_plus: ^8.2.2
  device_info_plus_aurora:
    git:
      url: https://gitlab.com/omprussia/flutter/flutter-plugins.git
      ref: master
      path: packages/device_info_plus/device_info_plus_aurora
```

***.dart**

```dart
import 'package:device_info_plus/device_info_plus.dart';

final deviceInfoPlugin = DeviceInfoPlugin();
final deviceInfo = await deviceInfoPlugin.linuxInfo as AuroraDeviceInfo;

debutPrint(deviceInfo.data);
```
