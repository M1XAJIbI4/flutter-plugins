// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:package_info_plus/package_info_plus.dart';

/// Main features of the plugin package_info_plus
class PluginImpl {
  /// Return PackageInfo
  Future<PackageInfo> getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  /// Format value output
  String? formatValue(String? value) {
    if (value == null) {
      return null;
    }
    return value.isEmpty ? '-' : value;
  }
}
