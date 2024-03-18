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
  String? _data = null;
  bool? _showSuccess = null;

  @override
  void initState() {
    super.initState();
    _impl.getValueStream().listen((event) {
      // Update data is empty
      setState(() => _data = event);
      // Check is not init show success
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: internalTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Secure storage'),
        ),
        body: ListSeparated(
          controller: _scroll,
          children: [
            const ListItemInfo("""
            Flutter Secure Storage provides an API for storing data in secure
            storage.
            """),

            /// Success update data
            if (_showSuccess == true)
              ListItemFormSuccess('Data updated successfully!'),

            /// Show list date SecureStorage
            ListItemData(
              'Secure Storage data',
              """
              The value that is stored in SecureStorage encrypted with your
              password.
              """,
              InternalColors.purple,
              value: _data,
              builder: (value) {
                if (value == null) {
                  return 'EMPTY';
                }
                return SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: Text(value.toString()),
                      ),
                    ),
                  ),
                );
              },
            ),

            /// Button for clear SecureStorage
            if (_data != null && _showSuccess != true)
              ListButton(
                'Clear data',
                InternalColors.coal,
                onPressed: () async => await _impl.clear(),
              ),

            Divider(),

            const ListItemInfo("""
            Save your value in SecureStorage.
            """),

            /// For SecureStorage
            FormWidget(impl: _impl),
          ],
        ),
      ),
    );
  }
}
