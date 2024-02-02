// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility_aurora/flutter_keyboard_visibility_aurora.dart';

/// List for body with separated items
class ListSeparated extends StatefulWidget {
  const ListSeparated({
    super.key,
    required this.list,
    this.scroll = true,
  });

  final List<Widget> list;
  final bool scroll;

  @override
  State<ListSeparated> createState() => _ListSeparatedState();
}

class _ListSeparatedState extends State<ListSeparated> {
  final _controllerAurora = FlutterKeyboardVisibilityAurora();

  StreamSubscription? _streamSub;
  double _keyboardHeight = 0;

  @override
  void initState() {
    if (kIsAurora) {
      _streamSub = _controllerAurora.onChangeHeight.listen((event) {
        setState(() {
          _keyboardHeight = event;
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSub?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: _keyboardHeight),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: widget.list
              .map((e) => Column(children: [
                    const SizedBox(height: 8),
                    e,
                    const SizedBox(height: 8),
                  ]))
              .toList(),
        ),
      ),
    );
  }
}
