// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wakelock_plus_aurora_example/common/list_button.dart';

import '../common/list_item_data.dart';
import '../common/list_item_info.dart';
import '../common/list_separated.dart';
import '../common/theme/colors.dart';
import 'wakelock_plus_impl.dart';

/// Body plugin layout
class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  final WakelockPlusImpl _impl = WakelockPlusImpl();

  bool _isEnable = false;

  @override
  void initState() {
    _init();
    super.initState();
  }

  /// Initialization of variables
  Future<void> _init() async {
    if (!mounted) return;
    setState(() async {
      _isEnable = await _impl.isEnable();
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
      // Info blocks
      ListItemData(
        localizations.itemTitle,
        localizations.itemDesc,
        AppColors.purple,
        widthData: widthData,
        value: _isEnable,
        builder: (value) => value?.toString().toUpperCase(),
      ),
      ListButton(localizations.itemButton, AppColors.green,
          onPressed: () async {
        await _impl.setStateWakelockPlus(!_isEnable);
        await _init();
      }),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.title.toUpperCase()),
      ),
      body: ListSeparated(list: list),
    );
  }
}
