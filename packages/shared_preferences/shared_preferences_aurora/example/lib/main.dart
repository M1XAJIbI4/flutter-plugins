// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:internal/list_item_info.dart';
import 'package:internal/list_separated.dart';
import 'package:internal/theme/theme.dart';
import 'package:shared_preferences_aurora_example/form_shared.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: internalTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Shared preferences example',
          ),
        ),
        body: const ListSeparated(
          children: [
            ListItemInfo(
              "A lightweight data storage tool with the ability to write asynchronously to disk, but no guarantee of retention after a callback. Not suitable for mission-critical data.",
            ),
            FormShared(),
          ],
        ),
      ),
    );
  }
}
