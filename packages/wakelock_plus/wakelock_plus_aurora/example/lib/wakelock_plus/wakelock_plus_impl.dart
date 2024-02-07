// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:async';

import 'package:wakelock_plus/wakelock_plus.dart';

/// Main features of the plugin WakelockPlus
class WakelockPlusImpl {
  /// Check is enable Wakelock
  Future<bool> isEnable() {
    return WakelockPlus.enabled;
  }

  /// Set state Wakelock
  Future<void> setStateWakelockPlus(bool enable) {
    return WakelockPlus.toggle(enable: enable);
  }
}
