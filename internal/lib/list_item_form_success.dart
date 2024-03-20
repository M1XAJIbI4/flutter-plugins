// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:internal/theme/colors.dart';

/// Item for show success change form
class ListItemFormSuccess extends StatelessWidget {
  const ListItemFormSuccess(
    this.text, {
    super.key,
    this.replace = true,
  });

  final String text;
  final bool replace;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: InternalColors.green,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            replace
                ? text
                    .replaceAll(RegExp(r"\s+"), ' ')
                    .replaceAll('\n', ' ')
                    .trim()
                : text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
