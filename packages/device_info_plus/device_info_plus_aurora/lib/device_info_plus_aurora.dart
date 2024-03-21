// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:dbus/dbus.dart';
import 'package:device_info_plus_aurora/ru_omp_deviceinfo_features.dart';
import 'package:device_info_plus_aurora/ru_omp_deviceinfo_sim.dart';
import 'package:device_info_plus_aurora/ru_omp_deviceinfo_storages.dart';
import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';

import 'aurora_device_info.dart';

class DeviceInfoPlusAurora extends DeviceInfoPlatform {
  /// Register this dart class as the platform implementation for aurora
  static void registerWith() {
    DeviceInfoPlatform.instance = DeviceInfoPlusAurora();
  }

  /// Get client with check connect session bus
  Future<DBusClient> _getClient() async {
    final session = DBusClient.session();
    try {
      await RuOmpDeviceinfoFeatures(
        session,
        'ru.omp.deviceinfo',
        DBusObjectPath('/ru/omp/deviceinfo/Features'),
      ).callgetOsVersion();
      return session;
    } on Exception {
      return DBusClient.system();
    }
  }

  @override
  Future<BaseDeviceInfo> deviceInfo() async {
    final client = await _getClient();

    // Features
    final features = RuOmpDeviceinfoFeatures(
      client,
      'ru.omp.deviceinfo',
      DBusObjectPath('/ru/omp/deviceinfo/Features'),
    );

    final hasGNSS = await features.callhasGNSS();
    final hasNFC = await features.callhasNFC();
    final hasBluetooth = await features.callhasBluetooth();
    final hasWlan = await features.callhasWlan();
    final maxCpuClockSpeed = await features.callgetMaxCpuClockSpeed();
    final numberCpuCores = await features.callgetNumberCpuCores();
    final batteryChargePercentage =
        await features.callgetBatteryChargePercentage();
    final mainCameraResolution = await features.callgetMainCameraResolution();
    final frontalCameraResolution =
        await features.callgetFrontalCameraResolution();
    final ramTotalSize = await features.callgetRamTotalSize();
    final ramFreeSize = await features.callgetRamFreeSize();
    final screenResolution = await features.callgetScreenResolution();
    final osVersion = await features.callgetOsVersion();
    final deviceModel = await features.callgetDeviceModel();

    // Storages
    final storages = RuOmpDeviceinfoStorages(client, 'ru.omp.deviceinfo',
        DBusObjectPath('/ru/omp/deviceinfo/Storages'));

    final Map<String, dynamic> internalStorage = {};
    (await storages.callgetInternalStorageInfo()).forEach((key, value) {
      internalStorage[key] = value.toNative();
    });

    final Map<String, dynamic> externalStorage = {};
    (await storages.callgetExternalStorageInfo()).forEach((key, value) {
      externalStorage[key] = value.toNative();
    });

    // SIM
    final infoSIM = RuOmpDeviceinfoSIM(
        client, 'ru.omp.deviceinfo', DBusObjectPath('/ru/omp/deviceinfo/SIM'));

    final List<Map<String, dynamic>> simCards = [];
    for (var element in await infoSIM.callgetSimCardsInfo()) {
      final Map<String, dynamic> simCard = {};
      element.forEach((key, value) {
        simCard[key] = value.toNative();
      });
      simCards.add(simCard);
    }

    await client.close();

    return AuroraDeviceInfo(
      hasGNSS: hasGNSS,
      hasNFC: hasNFC,
      hasBluetooth: hasBluetooth,
      hasWlan: hasWlan,
      maxCpuClockSpeed: maxCpuClockSpeed,
      numberCpuCores: numberCpuCores,
      batteryChargePercentage: batteryChargePercentage,
      mainCameraResolution: mainCameraResolution,
      frontalCameraResolution: frontalCameraResolution,
      ramTotalSize: ramTotalSize,
      ramFreeSize: ramFreeSize,
      screenResolution: screenResolution,
      osVersion: osVersion,
      deviceModel: deviceModel,
      externalStorage: externalStorage,
      internalStorage: internalStorage,
      simCards: simCards,
    ) as BaseDeviceInfo;
  }
}
