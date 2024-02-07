// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';

/// Item info about plugin
class ListItemInfo extends StatelessWidget {
  const ListItemInfo(
    this.text, {
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.replaceAll(RegExp(r"\s+"), ' ').replaceAll('\n', ' ').trim(),
      textAlign: TextAlign.left,
      style: const TextStyle(fontSize: 15),
    );
  }
}
