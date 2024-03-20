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
              InternalColors.pink,
              description: 'Sensor status display orientation',
              stream: _impl.orientation(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Accelerometer',
              InternalColors.orange,
              description: 'Sensor status display accelerometer',
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
              InternalColors.grey,
              description: 'Sensor status display ambient light',
              stream: _impl.als(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Approach Detector',
              InternalColors.royal,
              description: 'Sensor status display proximity',
              stream: _impl.proximity(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Magnetometer',
              InternalColors.midnight,
              description: 'Sensor status display magnetometer',
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
              InternalColors.blue,
              description: 'Sensor status display gyroscope',
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
              InternalColors.coal,
              description: 'Sensor status display rotation',
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
              InternalColors.purple,
              description: 'Sensor status display compass',
              stream: _impl.compass(),
              builder: (value) => value?.toString(),
            ),
            ListItemData(
              'Motion Detector',
              InternalColors.green,
              description: 'Sensor status display tapsensor',
              stream: _impl.tap(),
              builder: (value) => value?.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
