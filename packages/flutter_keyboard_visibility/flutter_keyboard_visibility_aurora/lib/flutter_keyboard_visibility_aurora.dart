// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter_keyboard_visibility_platform_interface/flutter_keyboard_visibility_platform_interface.dart';

import 'flutter_keyboard_visibility_aurora_platform_interface.dart';

class FlutterKeyboardVisibilityAurora
    extends FlutterKeyboardVisibilityPlatform {
  /// Factory method that initializes the FlutterKeyboardVisibility plugin
  /// platform with an instance of the plugin for Aurora OS.
  static void registerWith() {
    FlutterKeyboardVisibilityPlatform.instance =
        FlutterKeyboardVisibilityAurora();
  }

  /// Emits changes to keyboard visibility from the platform.
  @override
  Stream<bool> get onChange =>
      FlutterKeyboardVisibilityAuroraPlatform.instance.onChangeVisibility();

  /// Emits changes to keyboard height from the platform.
  Stream<double> get onChangeHeight =>
      FlutterKeyboardVisibilityAuroraPlatform.instance.onChangeHeight();

  /// Get keyboard height.
  Future<double> get height =>
      FlutterKeyboardVisibilityAuroraPlatform.instance.getKeyboardHeight();
}
