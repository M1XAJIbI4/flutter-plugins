// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsAurora;

/// Main features of the plugin connectivity_plus
class PluginImpl {
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
