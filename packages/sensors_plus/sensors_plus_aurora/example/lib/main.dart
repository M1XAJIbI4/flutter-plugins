// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:internal/list_item_data.dart';
import 'package:internal/list_item_info.dart';
import 'package:internal/list_separated.dart';
import 'package:internal/theme/colors.dart';
import 'package:internal/theme/theme.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:sensors_plus_aurora/events/rotation_event.dart';

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
          title: const Text('Sensors plus'),
        ),
        body: ListSeparated(
          children: [
            const ListItemInfo("""
            A Flutter plugin for accessing accelerometer,
            gyroscope, magnetometer, etc.
            """),
            ListItemData(
              'Orientation',
              'Key for the orientation sensor',
              InternalColors.pink,
              stream: _impl.orientation(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Accelerometer',
              'Key for the accelerometer sensor',
              InternalColors.orange,
              stream: _impl.accelerometer(),
              builder: (value) => value == null
                  ? null
                  : AccelerometerEvent(
                      double.parse(value.x.toStringAsFixed(6)),
                      double.parse(value.y.toStringAsFixed(6)),
                      double.parse(value.z.toStringAsFixed(6)),
                    ).toString(),
            ),
            ListItemData(
              'Compass',
              'Key for the compass sensor',
              InternalColors.purple,
              stream: _impl.compass(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Motion Detector',
              'Key for the tapsensor',
              InternalColors.green,
              stream: _impl.tap(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'ALS',
              'Key for the als sensor',
              InternalColors.grey,
              stream: _impl.als(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Approach Detector',
              'Key for the proximity sensor',
              InternalColors.royal,
              stream: _impl.proximity(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Rotation',
              'Key for the rotationsensor',
              InternalColors.coal,
              stream: _impl.rotation(),
              builder: (value) => value == null
                  ? null
                  : RotationEvent(
                      double.parse(value.x.toStringAsFixed(6)),
                      double.parse(value.y.toStringAsFixed(6)),
                      double.parse(value.z.toStringAsFixed(6)),
                    ).toString(),
            ),
            ListItemData(
              'Magnetometer',
              'Key for the magnetometersensor',
              InternalColors.midnight,
              stream: _impl.magnetometer(),
              builder: (value) => value == null
                  ? null
                  : MagnetometerEvent(
                      double.parse(value.x.toStringAsFixed(6)),
                      double.parse(value.y.toStringAsFixed(6)),
                      double.parse(value.z.toStringAsFixed(6)),
                    ).toString(),
            ),
            ListItemData(
              'Gyroscope',
              'Key for the gyroscopesensor',
              InternalColors.blue,
              stream: _impl.gyroscope(),
              builder: (value) => value == null
                  ? null
                  : GyroscopeEvent(
                      double.parse(value.x.toStringAsFixed(6)),
                      double.parse(value.y.toStringAsFixed(6)),
                      double.parse(value.z.toStringAsFixed(6)),
                    ).toString(),
            ),
          ],
        ),
      ),
    );
  }
}
