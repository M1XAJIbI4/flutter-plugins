// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';

/// Main features of the plugin battery_plus
class PluginImpl {
  final Battery battery = Battery();

  /// Returns the current battery level in percent.
  Future<int> getBatteryLevel() async {
    return battery.batteryLevel;
  }

  /// Returns true if the device is on battery save mode
  Future<bool?> getIsInBatterySaveMode() {
    if (!kIsWeb) {
      return battery.isInBatterySaveMode;
    }
    return Future.value(null);
  }

  /// Returns the current battery state in percent.
  Future<BatteryState> getBatteryState() {
    return battery.batteryState;
  }

  /// Returns a Stream of BatteryState changes.
  Stream<BatteryState> getOnBatteryStateChanged() async* {
    yield await getBatteryState();
    await for (final state in battery.onBatteryStateChanged) {
      yield state;
    }
  }
}
