// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:internal/list_item_data.dart';
import 'package:internal/list_item_info.dart';
import 'package:internal/list_separated.dart';
import 'package:internal/theme/colors.dart';
import 'package:internal/theme/theme.dart';

import 'form_widget.dart';
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
          title: const Text('Keyboard visibility'),
        ),
        body: ListSeparated(
          children: [
            const ListItemInfo("""
            This plugin allows you to monitor the keyboard activity
            status and its height.
            """),
            const FormWidget(),
            ListItemData(
              'Keyboard status stream',
              'Displays the status of whether the keyboard is open or closed',
              InternalColors.purple,
              widthData: 140,
              stream: _impl.onChange(),
              builder: (value) => value?.toString().toUpperCase(),
            ),
            ListItemData(
              'Keyboard height stream',
              'Displays keyboard height changes',
              InternalColors.royal,
              widthData: 140,
              stream: _impl.onChangeHeight(),
              builder: (value) => value?.toInt().toString(),
            ),
          ],
        ),
      ),
    );
  }
}
