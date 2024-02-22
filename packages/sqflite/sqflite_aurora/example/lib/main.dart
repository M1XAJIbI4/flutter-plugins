// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:internal/list_item_info.dart';
import 'package:internal/list_separated.dart';
import 'package:internal/theme/theme.dart';
import 'package:sqflite_aurora_example/sqflite_impl.dart';

import 'form_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PluginImpl _pluginImpl = PluginImpl();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: internalTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sqflite',
          ),
        ),
        body: ListSeparated(
          children: [
            const ListItemInfo("SQLite plugin for Flutter. Supports IOS, Android, macOS and Aurora OS."),
            Divider(),
            Text(
              'Database status',
              style: TextStyle(fontSize: 20),
            ),
            ResultData(pluginImpl: _pluginImpl),
            FormInsertWidget(pluginImpl: _pluginImpl),
            FormUpdateWidget(pluginImpl: _pluginImpl),
            FormDeleteWidget(pluginImpl: _pluginImpl),
          ],
        ),
      ),
    );
  }
}
