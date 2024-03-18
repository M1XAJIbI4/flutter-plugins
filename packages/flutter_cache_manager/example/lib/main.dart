// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
  final DefaultCacheManager _impl = DefaultCacheManager();
  final urlFile =
      'https://omprussia.gitlab.io/flutter/flutter/assets/images/preview.png';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: internalTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cache manager'),
        ),
        body: ListSeparated(
          children: [
            const ListItemInfo("""
            CacheManager v2 introduced some breaking changes when
            configuring a custom CacheManager.
            """),

            /// Show image
            ListItemData(
              'File',
              """
              The work of the flutter_cache_manager plugin, receiving
              the file and displaying its location.
              """,
              InternalColors.purple,
              loader: true,
              future: _impl.getSingleFile(urlFile),
              builder: (value) {
                if (value == null) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                } else {
                  return value.absolute.toString();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
