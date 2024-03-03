// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
          title: Text('Cached network image'.toUpperCase()),
        ),
        body: ListSeparated(children: [
          const ListItemInfo("""
            A Flutter package to use cached network image.
            """),
          ImageBlock(
            color: InternalColors.grey,
            height: 350,
            child: CachedNetworkImage(
              imageUrl: "https://static.tildacdn.com/tild3531-3361-4438-b333-323661366430/_.PNG",
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ]),
      ),
    );
  }
}

class ImageBlock extends StatelessWidget {
  const ImageBlock({super.key, required this.color, required this.child, required this.height});

  final Color color;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}
