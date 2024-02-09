// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:shared_preferences_aurora_example/shared_preferences/form_shared.dart';

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
    // List data
    final list = <Widget>[
      // Info
      const ListItemInfo(
        "A lightweight data storage tool with the ability to write asynchronously to disk, but no guarantee of retention after a callback. Not suitable for mission-critical data.",
      ),
      const FormShared(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shared preferences example',
        ),
      ),
      body: ListSeparated(list: list),
    );
  }
}
