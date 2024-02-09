// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          title: Text('Google fonts'.toUpperCase()),
        ),
        body: ListSeparated(
          children: [
            const ListItemInfo("""
            A Flutter package to use fonts from fonts.google.com.
            """),
            TextBlock(
              color: InternalColors.orange,
              child: Text(
                'Example text using GoogleFonts styles.',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            TextBlock(
              color: InternalColors.green,
              child: Text(
                'Example text using GoogleFonts styles.',
                style: GoogleFonts.oswald(
                  textStyle: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            TextBlock(
              color: InternalColors.blue,
              child: Text(
                'Example text using GoogleFonts styles.',
                style: GoogleFonts.rubik(
                  textStyle: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            TextBlock(
              color: InternalColors.pink,
              child: Text(
                'Example text using GoogleFonts styles.',
                style: GoogleFonts.singleDay(
                  textStyle: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            TextBlock(
              color: InternalColors.grey,
              child: Text(
                'Example text using GoogleFonts styles.',
                style: GoogleFonts.quicksand(
                  textStyle: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextBlock extends StatelessWidget {
  const TextBlock({super.key, required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: color,
      child: SizedBox(
        width: double.infinity,
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}
