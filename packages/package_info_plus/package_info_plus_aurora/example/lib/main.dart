// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:internal/list_item_data.dart';
import 'package:internal/list_item_info.dart';
import 'package:internal/list_separated.dart';
import 'package:internal/theme/colors.dart';
import 'package:internal/theme/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

  late Future<PackageInfo> _packageInfo;

  @override
  void initState() {
    _init();
    super.initState();
  }

  /// The method should not change its name for standardization
  Future<void> _init() async {
    if (!mounted) return;
    setState(() {
      _packageInfo = _impl.getPackageInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: internalTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Package info plus'),
        ),
        body: ListSeparated(
          children: [
            const ListItemInfo("""
            This plugin provides an API for querying information about
            an application package.
            """),
            ListItemData(
              'App name',
              InternalColors.pink,
              description: 'Bundle Display Name',
              future: _packageInfo,
              builder: (value) => value?.appName,
            ),
            ListItemData(
              'Package name',
              InternalColors.orange,
              description: 'Here display bundle Identifier',
              future: _packageInfo,
              builder: (value) => value?.packageName,
            ),
          ],
        ),
      ),
    );
  }
}
