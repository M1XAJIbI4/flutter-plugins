// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:internal/abb_bar_action.dart';
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

  late Future<int> _batteryLevel;
  late Future<bool?> _isInBatterySaveMode;
  late Stream<BatteryState> _onBatteryStateChanged;

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    if (!mounted) return;
    setState(() {
      _batteryLevel = _impl.getBatteryLevel();
      _isInBatterySaveMode = _impl.getIsInBatterySaveMode();
      _onBatteryStateChanged = _impl.getOnBatteryStateChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: internalTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Battery plus'),
          actions: [AppBarAction(onPressed: _init)],
        ),
        body: ListSeparated(
          children: [
            const ListItemInfo("""
            This plugin allows you to track the current battery status,
            battery charge level and battery saving mode.
            """),
            ListItemData(
              'Battery Level',
              InternalColors.orange,
              description: 'Returns the current battery level as a percentage.',
              widthData: 140,
              future: _batteryLevel,
              builder: (value) => '$value%',
            ),
            ListItemData(
              'Battery Status',
              InternalColors.purple,
              description: 'Returns true if the device is in battery saving mode.',
              widthData: 140,
              future: _isInBatterySaveMode,
              builder: (value) => value.toString().toUpperCase(),
            ),
            ListItemData(
              'Battery State',
              InternalColors.green,
              description: 'Returns a stream that updates when the battery state changes.',
              widthData: 140,
              stream: _onBatteryStateChanged,
              builder: (value) => value?.name.toUpperCase(),
            ),
          ],
        ),
      ),
    );
  }
}
