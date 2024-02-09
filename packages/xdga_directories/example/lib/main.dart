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
          title: const Text('Xdga directories'),
        ),
        body: ListSeparated(
          children: [
            const ListItemInfo("""
            Dart package for reading XDG catalog configuration information
            on Aurora OS.
            """),
            ListItemData(
              'App Data Location',
              'Location of the directory where persistent application data can be stored',
              InternalColors.pink,
              value: _impl.getCacheLocation(),
            ),
            ListItemData(
              'Cache Location',
              'Location of the directory where secondary (cached) user data should be written',
              InternalColors.orange,
              value: _impl.getAppDataLocation(),
            ),
            ListItemData(
              'Documents Location',
              'Directory containing the user\'s document files',
              InternalColors.purple,
              value: _impl.getDocumentsLocation(),
            ),
            ListItemData(
              'Download Location',
              'Directory for user-downloaded files',
              InternalColors.green,
              value: _impl.getDownloadLocation(),
            ),
            ListItemData(
              'Music Location',
              'Directory containing the user\'s music or other audio files',
              InternalColors.grey,
              value: _impl.getMusicLocation(),
            ),
            ListItemData(
              'Pictures Location',
              'Directory containing the user\'s images or photographs',
              InternalColors.royal,
              value: _impl.getPicturesLocation(),
            ),
            ListItemData(
              'Generic Data Location',
              'Location of the directory where persistent data shared by applications may be stored',
              InternalColors.coal,
              value: _impl.getGenericDataLocation(),
            ),
            ListItemData(
              'Movies Location',
              'Directory containing the user\'s movies and video',
              InternalColors.midnight,
              value: _impl.getMoviesLocation(),
            ),
          ],
        ),
      ),
    );
  }
}
