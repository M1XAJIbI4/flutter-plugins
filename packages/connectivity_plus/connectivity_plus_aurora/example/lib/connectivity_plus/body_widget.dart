// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../common/list_item_data.dart';
import '../common/list_item_info.dart';
import '../common/theme/colors.dart';
import 'connectivity_plus_impl.dart';

/// Body plugin layout
class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  late Stream<ConnectivityResult>? _connectivityResult;
  final ConnectivityPlusImpl _impl = ConnectivityPlusImpl();

  @override
  void initState() {
    _init();
    super.initState();
  }

  /// Initialization of variables
  Future<void> _init() async {
    if (!mounted) return;
    setState(() {
      _connectivityResult = _impl.connectivityResult();
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
        localizations.item1IConnectivityTitle,
        localizations.item1ConnectivityDesc,
        AppColors.pink,
        widthData: widthData,
        stream: _connectivityResult,
        builder: (value) => value?.name.toUpperCase(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.title.toUpperCase()),
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
