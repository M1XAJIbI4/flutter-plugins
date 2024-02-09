// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:math';

import 'package:flutter/foundation.dart' show kIsAurora;

/// Main features of the plugin <PluginName>
class PluginImpl {
  /// The method returns the stream for demonstration
  /// Checks the OS and signals whether the current one is Aurora OS
  Stream<bool> onIsAurora() async* {
    yield kIsAurora;
  }

  /// The method returns random number for demonstration
  Future<int> getNumber() async {
    return Future.value(Random().nextInt(100));
  }
}
