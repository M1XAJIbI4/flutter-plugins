// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause

import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_info_plus_aurora/aurora_device_info.dart';

/// Main features of the plugin device_info_plus
class PluginImpl {
  final _deviceInfoPlugin = DeviceInfoPlugin();

  /// Get Aurora info
  Future<AuroraDeviceInfo> get _deviceInfo async =>
      await _deviceInfoPlugin.linuxInfo as AuroraDeviceInfo;

  /// Get ID name device
  Future<String?> getID() async {
    return (await _deviceInfo).id;
  }

  /// Device name
  Future<String?> getName() async {
    return (await _deviceInfo).name;
  }

  /// Version
  Future<String?> getVersion() async {
    return (await _deviceInfo).version;
  }

  /// Device full name
  Future<String?> getPrettyName() async {
    return (await _deviceInfo).prettyName;
  }

  /// Check has GNSS
  Future<bool?> hasGNSS() async {
    return (await _deviceInfo).hasGNSS;
  }

  /// Check has NFC
  Future<bool?> hasNFC() async {
    return (await _deviceInfo).hasNFC;
  }

  /// Check has Bluetooth
  Future<bool?> hasBluetooth() async {
    return (await _deviceInfo).hasBluetooth;
  }

  /// Check has Wlan
  Future<bool?> hasWlan() async {
    return (await _deviceInfo).hasWlan;
  }

  /// Max CPU clock speed
  Future<int?> getMaxCpuClockSpeed() async {
    return (await _deviceInfo).maxCpuClockSpeed;
  }

  /// Number CPU cores
  Future<int?> getNumberCpuCores() async {
    return (await _deviceInfo).numberCpuCores;
  }

  /// Get battery level in percent 0-100
  Future<int?> getBatteryChargePercentage() async {
    return (await _deviceInfo).batteryChargePercentage;
  }

  /// Camera resolution
  Future<double?> getMainCameraResolution() async {
    return (await _deviceInfo).mainCameraResolution;
  }

  /// Frontal camera resolution
  Future<double?> getFrontalCameraResolution() async {
    return (await _deviceInfo).frontalCameraResolution;
  }

  /// RAM total size
  Future<int?> getRamTotalSize() async {
    return (await _deviceInfo).ramTotalSize;
  }

  /// RAM free size
  Future<int?> getRamFreeSize() async {
    return (await _deviceInfo).ramFreeSize;
  }

  /// Screen resolution
  Future<String?> getScreenResolution() async {
    return (await _deviceInfo).screenResolution;
  }

  /// Version
  Future<String?> getOsVersion() async {
    return (await _deviceInfo).osVersion;
  }

  /// Device model
  Future<String?> getDeviceModel() async {
    return (await _deviceInfo).deviceModel;
  }

  /// Get map with info about external storage
  Future<Map<String, dynamic>?> getExternalStorage() async {
    return (await _deviceInfo).externalStorage;
  }

  /// Get map with info about internal storage
  Future<Map<String, dynamic>?> getInternalStorage() async {
    return (await _deviceInfo).internalStorage;
  }

  /// Get map with info about SIM cards
  Future<List<Map<String, dynamic>>?> getSimCards() async {
    return (await _deviceInfo).simCards;
  }
}
