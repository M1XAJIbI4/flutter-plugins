// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts_example/common/theme/colors.dart';

import '../common/list_item_info.dart';
import '../common/list_separated.dart';

/// Body plugin layout
class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  @override
  Widget build(BuildContext context) {
    // Get localizations
    final localizations = AppLocalizations.of(context)!;
    // List data
    final list = <Widget>[
      // Info
      ListItemInfo(localizations.description),
      // Texts
      _textBlock(
        color: AppColors.orange,
        child: Text(
          localizations.exampleText,
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
      _textBlock(
        color: AppColors.green,
        child: Text(
          localizations.exampleText,
          style: GoogleFonts.oswald(
            textStyle: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
      _textBlock(
        color: AppColors.blue,
        child: Text(
          localizations.exampleText,
          style: GoogleFonts.rubik(
            textStyle: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
      _textBlock(
        color: AppColors.pink,
        child: Text(
          localizations.exampleText,
          style: GoogleFonts.singleDay(
            textStyle: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
      _textBlock(
        color: AppColors.grey,
        child: Text(
          localizations.exampleText,
          style: GoogleFonts.quicksand(
            textStyle: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.title.toUpperCase()),
      ),
      body: ListSeparated(list: list),
    );
  }

  Widget _textBlock({required Widget child, required Color color}) {
    return Card(
      surfaceTintColor: color,
      child: SizedBox(
        width: double.infinity,
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}
