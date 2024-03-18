// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:cached_network_image/cached_network_image.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: internalTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cached network image'),
        ),
        body: ListSeparated(
          children: [
            const ListItemInfo("""
            A Flutter package to use cached network image.
            """),

            /// Show image
            ListItemData(
              'Image',
              """
              Receiving and displaying images from the network or,
              if there is a cache, from the cache.
              """,
              InternalColors.purple,
              value:
                  'https://omprussia.gitlab.io/flutter/flutter/assets/images/preview.png',
              builder: (value) {
                if (value == null) {
                  return const SizedBox.shrink();
                }
                return SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: value,
                        placeholder: (context, url) => Padding(
                          padding: EdgeInsets.all(16),
                          child: const Icon(
                            Icons.sync,
                            color: Colors.black,
                          ),
                        ),
                        errorWidget: (context, url, error) => Padding(
                          padding: EdgeInsets.all(16),
                          child: const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
