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
      // Common theme for examples
      theme: internalTheme,
      home: Scaffold(
        appBar: AppBar(
          // Title
          title: const Text('Path provider'),
        ),
        // Custom list for widgets with separated.
        body: ListSeparated(
          children: [
            // The plugin must have a description in the example.
            const ListItemInfo("""
            Flutter plugin for searching frequently used places in the file 
            system. Supports Android, iOS, Linux, macOS, Windows, and Aurora OS.
            Not all methods are supported on all platforms.
            """),
            ListItemData(
              'Support Applications',
              InternalColors.pink,
              description: 'Directory where the application can place support application files',
              future: _impl.getApplicationSupportDirectory(),
              builder: (value) => value?.path.toString(),
            ),
            ListItemData(
              'Temporary',
              InternalColors.orange,
              description: 'Location of the directory where user data should be written',
              future: _impl.getTemporaryDirectory(),
              builder: (value) => value?.path.toString(),
            ),
            ListItemData(
              'Documents',
              InternalColors.purple,
              description: 'Directory containing user document files',
              future: _impl.getApplicationDocumentsDirectory(),
              builder: (value) => value?.path.toString(),
            ),
            ListItemData(
              'Download',
              InternalColors.green,
              description: 'Directory for user downloaded files',
              future: _impl.getDownloadsDirectory(),
              builder: (value) => value?.path.toString(),
            ),
            ListItemData(
              'Image',
              InternalColors.grey,
              description: 'Allows obtaining the StorageDirectory.pictures directory',
              future: _impl.getExternalStorageDirectoriesPictures(),
              builder: (value) => value?.path.toString(),
            ),
            ListItemData(
              'Music',
              InternalColors.royal,
              description: 'Allows obtaining the StorageDirectory.music directory',
              future: _impl.getExternalStorageDirectoriesMusic(),
              builder: (value) => value?.path.toString(),
            ),
            ListItemData(
              'Movies',
              InternalColors.coal,
              description: 'Allows obtaining the StorageDirectory.movies directory',
              future: _impl.getExternalStorageDirectoriesMovies(),
              builder: (value) => value?.path.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
