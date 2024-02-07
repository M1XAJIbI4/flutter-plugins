// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:internal/abb_bar_action_refresh.dart';
import 'package:internal/list_button.dart';
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

  bool _isEnable = false;

  @override
  void initState() {
    _init();
    super.initState();
  }

  /// The method should not change its name for standardization
  Future<void> _init() async {
    if (!mounted) return;
    setState(() async {
      _isEnable = await _impl.isEnable();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: internalTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wakelock plus'),
          actions: [AppBarActionRefresh(onPressed: _init)],
        ),
        body: ListSeparated(
          children: [
            const ListItemInfo("""
            Plugin that allows you to keep the device screen awake,
            i.e. prevent the screen from sleeping.
            """),
            ListItemData(
              'State Wakelock',
              'Displays the sleep lock status of the device',
              InternalColors.purple,
              widthData: 140,
              value: _isEnable,
              builder: (value) => value?.toString().toUpperCase(),
            ),
            ListButton(
              'Toggle',
              InternalColors.green,
              onPressed: () async {
                await _impl.setStateWakelockPlus(!_isEnable);
                await _init();
              },
            ),
          ],
        ),
      ),
    );
  }
}
