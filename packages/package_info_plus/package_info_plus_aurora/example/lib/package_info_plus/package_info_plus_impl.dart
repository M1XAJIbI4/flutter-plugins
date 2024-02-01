// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clausectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoPlusImpl {
  /// Return PackageInfo
  Future<PackageInfo> getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  /// Check for empty strings
  String _checkingStringProcess(String string) {
    return string.isEmpty ? '-' : string;
  }

  /// Check for null
  String? checkingForEmptyString(String? string) {
    if (string == null) return null;
    return _checkingStringProcess(string);
  }
}
