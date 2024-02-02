// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../common/list_item_data.dart';
import '../common/list_item_info.dart';
import '../common/list_separated.dart';
import '../common/theme/colors.dart';
import 'flutter_keyboard_visibility_impl.dart';
import 'form_widget.dart';

/// Body plugin layout
class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  late Stream<bool?> _onChange;
  late Stream<double?> _onChangeHeight;
  final FlutterKeyboardVisibilityImpl _impl = FlutterKeyboardVisibilityImpl();

  @override
  void initState() {
    _init();
    super.initState();
  }

  /// Initialization of variables
  Future<void> _init() async {
    if (!mounted) return;
    setState(() {
      _onChange = _impl.onChange();
      _onChangeHeight = _impl.onChangeHeight();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get localizations
    final localizations = AppLocalizations.of(context)!;
    // Size block data
    const widthData = 140.0;
    // List data
    final list = <Widget>[
      // Info
      ListItemInfo(localizations.description),
      // Form
      const FormWidget(),
      // Info blocks
      ListItemData(
        localizations.item1OnChangeTitle,
        localizations.item1OnChangeDesc,
        AppColors.purple,
        widthData: widthData,
        stream: _onChange,
        builder: (value) => value?.toString().toUpperCase(),
      ),
      ListItemData(
        localizations.item2OnChangeHeightTitle,
        localizations.item2OnChangeHeightDesc,
        AppColors.royal,
        widthData: widthData,
        stream: _onChangeHeight,
        builder: (value) => value?.toInt().toString(),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.title.toUpperCase()),
      ),
      body: ListSeparated(list: list),
    );
  }
}
