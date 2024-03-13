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
              'Sensor status display orientation',
              InternalColors.pink,
              stream: _impl.orientation(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Accelerometer',
              'Sensor status display accelerometer',
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
              'ALS',
              'Sensor status display ambient light',
              InternalColors.grey,
              stream: _impl.als(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Approach Detector',
              'Sensor status display proximity',
              InternalColors.royal,
              stream: _impl.proximity(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Magnetometer',
              'Sensor status display magnetometer',
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
              'Sensor status display gyroscope',
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
            ListItemData(
              'Rotation',
              'Sensor status display rotation',
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
              'Compass',
              'Sensor status display compass',
              InternalColors.purple,
              stream: _impl.compass(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Motion Detector',
              'Sensor status display tapsensor',
              InternalColors.green,
              stream: _impl.tap(),
              builder: (value) => value?.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
