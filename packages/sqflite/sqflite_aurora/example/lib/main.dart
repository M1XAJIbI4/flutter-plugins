// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internal/list_button.dart';
import 'package:internal/list_item_data.dart';
import 'package:internal/list_item_form_success.dart';
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
  ScrollController _scroll = ScrollController();
  bool? _dataIsEmpty = null;
  bool? _showSuccess = null;

  @override
  void initState() {
    super.initState();
    _impl.isEmptyStream().listen((event) {
      // Update data is empty
      setState(() => _dataIsEmpty = event);
      // Check is not init show success
      if (_showSuccess != null) {
        setState(() {
          _showSuccess = true;
          _scroll.animateTo(
            _scroll.position.minScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 500),
          );
          Future.delayed(const Duration(seconds: 2),
              () => setState(() => _showSuccess = false));
        });
      } else {
        _showSuccess = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: internalTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sqflite'),
        ),
        body: ListSeparated(
          controller: _scroll,
          children: [
            const ListItemInfo("""
            SQLite plugin for Flutter. Supports iOS, Android, MacOS
            and Aurora OS.
            """),

            /// Success update data
            if (_showSuccess == true)
              ListItemFormSuccess('Data updated successfully!'),

            /// Button for clear Sqflite
            if (_dataIsEmpty == false && _showSuccess != true)
              ListButton(
                'Clear data',
                InternalColors.coal,
                onPressed: () async => await _impl.clear(),
              ),

            /// Show list date Sqflite
            ListItemData(
              'Save Data',
              InternalColors.purple,
              description: 'Data saved via form in Sqflite.',
              future: _impl.getValues(),
              builder: (value) {
                if (value == null) {
                  return 'EMPTY';
                }
                return SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: DataTable(
                      horizontalMargin: 16,
                      columnSpacing: 6,
                      columns: ['Name', 'Value']
                          .map((name) => DataColumn(
                                label: Expanded(
                                  child: Text(name,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic)),
                                ),
                              ))
                          .toList(),
                      rows: [
                        for (final key in value.keys)
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text(key.name)),
                              DataCell(Text(value[key].toString())),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            /// Insert form
            if (_dataIsEmpty == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: ListItemInfo('Insert data via Sqflite plugin.'),
                  ),
                  FormWidget(impl: _impl, type: FormTypeKeys.insert),
                ],
              ),

            if (_dataIsEmpty == false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: ListItemInfo('Update data via Sqflite plugin.'),
                  ),
                  FormWidget(impl: _impl, type: FormTypeKeys.update),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
