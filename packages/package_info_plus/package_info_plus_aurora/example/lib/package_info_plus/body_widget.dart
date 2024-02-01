// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:package_info_plus_aurora_example/common/list_item_data.dart';

import '../common/list_item_info.dart';
import '../common/theme/colors.dart';
import 'package_info_plus_impl.dart';

/// Body plugin layout
class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  late Future<PackageInfo> _packageInfo;
  final PackageInfoPlusImpl _impl = PackageInfoPlusImpl();

  @override
  void initState() {
    _init();
    super.initState();
  }

  /// Initialization of variables
  Future<void> _init() async {
    if (!mounted) return;
    setState(() {
      _packageInfo = _impl.getPackageInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get localizations
    final localizations = AppLocalizations.of(context)!;
    // Size block data
    const widthData = 160.0;

    // List data
    final list = <Widget>[
      ListItemInfo(localizations.description),
      ListItemData(
        localizations.item1PackageInfoTitle,
        localizations.item1PackageInfoDesc,
        AppColors.pink,
        widthData: widthData,
        future: _packageInfo,
        builder: (value) => _impl.checkingForEmptyString(value?.appName),
      ),
      ListItemData(
        localizations.item2PackageInfoTitle,
        localizations.item2PackageInfoDesc,
        AppColors.orange,
        widthData: widthData,
        future: _packageInfo,
        builder: (value) => _impl.checkingForEmptyString(value?.packageName),
      ),
      ListItemData(
        localizations.item3PackageInfoTitle,
        localizations.item3PackageInfoDesc,
        AppColors.purple,
        widthData: widthData,
        future: _packageInfo,
        builder: (value) => _impl.checkingForEmptyString(value?.version),
      ),
      ListItemData(
        localizations.item4PackageInfoTitle,
        localizations.item4PackageInfDesc,
        AppColors.green,
        widthData: widthData,
        future: _packageInfo,
        builder: (value) => _impl.checkingForEmptyString(value?.buildNumber),
      ),
      ListItemData(
        localizations.item5PackageInfoTitle,
        localizations.item5PackageInfoDesc,
        AppColors.grey,
        widthData: widthData,
        future: _packageInfo,
        builder: (value) => _impl.checkingForEmptyString(value?.buildSignature),
      ),
      ListItemData(
        localizations.item6PackageInfoTitle,
        localizations.item6PackageInfoDesc,
        AppColors.coal,
        widthData: widthData,
        future: _packageInfo,
        builder: (value) => _impl.checkingForEmptyString(value?.installerStore),
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
