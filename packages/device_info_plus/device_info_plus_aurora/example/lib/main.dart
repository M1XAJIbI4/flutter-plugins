// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:internal/list_item_data.dart';
import 'package:internal/list_item_info.dart';
import 'package:internal/list_separated.dart';
import 'package:internal/theme/colors.dart';
import 'package:internal/theme/theme.dart';

import 'plugin_impl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PluginImpl _impl = PluginImpl();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: internalTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Device info plus'),
        ),
        body: ListSeparated(
          children: [
            const ListItemInfo("""
            Get current device information from within the Flutter application.
            """),
            ListItemData(
              'ID name device',
              InternalColors.midnight,
              future: _impl.getID(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Device name',
              InternalColors.coal,
              future: _impl.getName(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Device full name',
              InternalColors.royal,
              future: _impl.getPrettyName(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Check has GNSS',
              InternalColors.grey,
              future: _impl.hasGNSS(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Check has NFC',
              InternalColors.green,
              future: _impl.hasNFC(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Check has Bluetooth',
              InternalColors.pink,
              future: _impl.hasBluetooth(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Check has Wlan',
              InternalColors.purple,
              future: _impl.hasWlan(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Max CPU clock speed',
              InternalColors.orange,
              future: _impl.getMaxCpuClockSpeed(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Number CPU cores',
              InternalColors.blue,
              future: _impl.getNumberCpuCores(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Get battery level in percent 0-100',
              InternalColors.midnight,
              future: _impl.getBatteryChargePercentage(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Camera resolution',
              InternalColors.coal,
              future: _impl.getMainCameraResolution(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Frontal camera resolution',
              InternalColors.royal,
              future: _impl.getFrontalCameraResolution(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'RAM total size',
              InternalColors.grey,
              future: _impl.getRamTotalSize(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'RAM free size',
              InternalColors.green,
              future: _impl.getRamFreeSize(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Screen resolution',
              InternalColors.pink,
              future: _impl.getScreenResolution(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Version',
              InternalColors.purple,
              future: _impl.getOsVersion(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Device model',
              InternalColors.orange,
              future: _impl.getDeviceModel(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Get map with info about external storage',
              InternalColors.blue,
              future: _impl.getExternalStorage(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Get map with info about internal storage',
              InternalColors.midnight,
              future: _impl.getInternalStorage(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Get map with info about SIM cards',
              InternalColors.coal,
              future: _impl.getSimCards(),
              builder: (value) => value?.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
