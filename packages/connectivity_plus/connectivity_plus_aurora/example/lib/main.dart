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
          title: const Text('Connectivity plus'),
        ),
        body: ListSeparated(
          children: [
            const ListItemInfo("""
            This plugin allows Flutter apps to discover network connectivity
            and configure themselves accordingly. It can distinguish between
            cellular vs WiFi connection.
            """),
            ListItemData(
              'Stream status',
              'Here the status of the stream is displayed, reacting to changes in connection type',
              InternalColors.pink,
              widthData: 140,
              stream: _impl.connectivityResult(),
              builder: (value) => value?.name.toUpperCase(),
            ),
          ],
        ),
      ),
    );
  }
}
