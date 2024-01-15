// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause

import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';

class ConnectivityPlusAurora extends ConnectivityPlatform {
  static void registerWith() {
    ConnectivityPlatform.instance = ConnectivityPlusAurora();
  }

  /// Checks the connection status of the device.
  @override
  Future<ConnectivityResult> checkConnectivity() {
    return ConnectivityPlatform.instance.checkConnectivity();
  }

  /// Returns a Stream of ConnectivityResults changes.
  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return ConnectivityPlatform.instance.onConnectivityChanged;
  }
}
