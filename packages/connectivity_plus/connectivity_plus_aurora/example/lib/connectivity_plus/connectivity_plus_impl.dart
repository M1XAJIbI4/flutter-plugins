// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clausectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Main features of the plugin Connectivity
class ConnectivityPlusImpl {
  final connectivityPlusPlugin = Connectivity();

  /// Returns the connectivity check status
  Stream<ConnectivityResult>? connectivityResult() {
    try {
      return connectivityPlusPlugin.onConnectivityChanged;
    } catch (e) {
      return null;
    }
  }
}
