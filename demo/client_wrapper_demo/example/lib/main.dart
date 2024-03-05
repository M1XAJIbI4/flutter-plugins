// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:async';

import 'package:client_wrapper_demo/client_wrapper_demo.dart';
import 'package:flutter/material.dart';
import 'package:internal/list_item_data.dart';
import 'package:internal/list_item_info.dart';
import 'package:internal/list_separated.dart';
import 'package:internal/theme/colors.dart';
import 'package:internal/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ClientWrapperDemo _plugin = ClientWrapperDemo();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _asyncMethod();
  //   });
  // }

  // void _asyncMethod() async {
  //   Timer.periodic(const Duration(seconds: 3), (Timer t) async {
  //     await _plugin.encodable();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: internalTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Client Wrapper'),
        ),
        body: ListSeparated(
          children: [
            const ListItemInfo("""
            This is a demo plugin if the main goal is to demonstrate working
            with Flutter Embedder through the common client_wrapper.
            """),
            ListItemData(
              'Texture Registar',
              """
              The image is drawn using the GPU, textures and pixel buffer
              through the common client_wrapper.
              """,
              InternalColors.pink,
              widthData: 100,
              future: _plugin.createTexture(),
              builder: (value) {
                if (value != null) {
                  return SizedBox(
                    width: 84,
                    height: 84,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Texture(textureId: value),
                      ),
                    ),
                  );
                }
              },
            ),
            ListItemData(
              'Binary Messenger',
              """
              Implementing an event using the BinaryMessenger client_wrapper
              to obtain the screen orientation angle.
              """,
              InternalColors.green,
              widthData: 100,
              stream: _plugin.eventBinaryMessage(),
              builder: (value) => value == null ? null : '$value°',
            ),
            ListItemData(
              'Encodable Value',
              """
              Example of using EncodableValue to transfer data from
              flutter platform channels to dart.
              """,
              InternalColors.purple,
              future: _plugin.encodable({
                'int': 1,
                'bool': true,
                'string': 'text',
                'vector_int': [1, 2],
                'vector_double': [1.0, 2.0],
                'map': {'key': 'value'}
              }),
              builder: (value) {
                if (value != null) {
                  final List<DataRow> rows = [];
                  if (value is List) {
                    for (final item in value) {
                      rows.add(
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text(
                              item.runtimeType
                                  .toString()
                                  .replaceAll('_', '')
                                  .replaceAll('View', '')
                                  .replaceAll('Unmodifiable', '')
                                  .replaceAll('<Object?, Object?>', ''),
                            )),
                            DataCell(Text(item.toString())),
                          ],
                        ),
                      );
                    }
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: Card(
                      child: DataTable(
                        horizontalMargin: 16,
                        columnSpacing: 6,
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Type',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Value',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ],
                        rows: rows,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
