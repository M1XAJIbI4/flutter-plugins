// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:internal/abb_bar_action.dart';
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
  // All functionality is included in the *impl class
  // and the methods have a description.
  final PluginImpl _impl = PluginImpl();

  // Future data with for demonstration refresh logic
  late Future<int> _randomNumber;

  @override
  void initState() {
    _init();
    super.initState();
  }

  /// The method should not change its name for standardization
  Future<void> _init() async {
    if (!mounted) return;
    setState(() {
      _randomNumber = _impl.getNumber();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Common theme for examples
      theme: internalTheme,
      home: Scaffold(
        appBar: AppBar(
          // Title
          title: const Text('Internal'),
          // Add button for refresh data.
          actions: [AppBarAction(onPressed: _init)],
        ),
        // Custom list for widgets with separated.
        body: ListSeparated(
          children: [
            // The plugin must have a description in the example.
            const ListItemInfo("""
            This is an example implementation of the example for the plugin.
            """),

            // We have a data block in which we can display
            // information in the formats: stream, future, value.
            ListItemData(
              'Check Aurora OS',
              'Displays whether the current system is Aurora OS',
              InternalColors.purple,
              widthData: 140,
              stream: _impl.onIsAurora(),
              builder: (value) => value?.toString().toUpperCase(),
            ),

            // We will demonstrate how the refresh feature works
            ListItemData(
              'Random number',
              'This random number should be updated after the refresh',
              InternalColors.coal,
              // If you do not specify the size, the data block will be displayed as a list
              widthData: null,
              future: _randomNumber,
              builder: (value) => value?.toString().toUpperCase(),
            ),

            // Button in common style for example
            ListButton('Refresh data', InternalColors.green, onPressed: _init)
          ],
        ),
      ),
    );
  }
}
