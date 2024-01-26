// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../common/abb_bar_action_refresh.dart';
import '../common/list_item_data.dart';
import '../common/list_item_info.dart';
import '../common/theme/colors.dart';
import 'battery_plus_impl.dart';

/// Body plugin layout
class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  BatteryPlusImpl impl = BatteryPlusImpl();

  late Future<int> batteryLevel;
  late Future<bool?> isInBatterySaveMode;
  late Stream<BatteryState> onBatteryStateChanged;

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  void _refresh() {
    setState(() {
      batteryLevel = impl.getBatteryLevel();
      isInBatterySaveMode = impl.getIsInBatterySaveMode();
      onBatteryStateChanged = impl.getOnBatteryStateChanged();
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
      ListItemInfo(localizations.description),
      ListItemData(
        localizations.item1BatteryLevel,
        localizations.item1BatteryLevelDesc,
        AppColors.orange,
        widthData: widthData,
        future: batteryLevel,
        builder: (value) => '$value%',
      ),
      ListItemData(
        localizations.item2IsInBatterySaveMode,
        localizations.item2IsInBatterySaveModeDesc,
        AppColors.purple,
        widthData: widthData,
        future: isInBatterySaveMode,
        builder: (value) => value.toString().toUpperCase(),
      ),
      ListItemData<BatteryState>(
        localizations.item3OnBatteryStateChanged,
        localizations.item3OnBatteryStateChangedDesc,
        AppColors.green,
        widthData: widthData,
        stream: onBatteryStateChanged,
        builder: (value) => value?.name.toUpperCase(),
      ),
    ];
    // Widget
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.title.toUpperCase()),
        actions: [AppBarActionRefresh(onPressed: _refresh)],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => list[index],
      ),
    );
  }
}
