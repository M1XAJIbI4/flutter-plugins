// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage_aurora_example/secure_storage_impl.dart';
import 'package:internal/list_item_info.dart';
import 'package:internal/list_separated.dart';
import 'package:internal/theme/theme.dart';

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
            'Flutter secure storage aurora',
          ),
        ),
        body: ListSeparated(
          children: [
            ListItemInfo("Flutter Secure Storage provides an API for storing data in secure storage."),
            FormWidget(pluginImpl: _pluginImpl),
            FormGetWidget(pluginImpl: _pluginImpl),
            ResultData(pluginImpl: _pluginImpl),
          ],
        ),
      ),
    );
  }
}
