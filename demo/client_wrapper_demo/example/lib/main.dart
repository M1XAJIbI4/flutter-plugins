// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
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
              'Demo Texture',
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
          ],
        ),
      ),
    );
  }
}
