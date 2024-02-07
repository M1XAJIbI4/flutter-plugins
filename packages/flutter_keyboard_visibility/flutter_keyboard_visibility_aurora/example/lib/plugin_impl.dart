// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/foundation.dart' show kIsAurora;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_keyboard_visibility_aurora/flutter_keyboard_visibility_aurora.dart';

/// Main features of the plugin flutter_keyboard_visibility
class PluginImpl {
  final _keyboardVisibilityController = KeyboardVisibilityController();
  final _flutterKeyboardVisibilityAurora = FlutterKeyboardVisibilityAurora();

  /// Stream change visibility
  Stream<bool?> onChange() async* {
    try {
      yield _keyboardVisibilityController.isVisible;
      await for (final state in _keyboardVisibilityController.onChange) {
        yield state;
      }
    } catch (e) {
      yield null;
    }
  }

  /// Stream change height
  Stream<double?> onChangeHeight() async* {
    if (kIsAurora) {
      try {
        yield await _flutterKeyboardVisibilityAurora.height;
        await for (final state
            in _flutterKeyboardVisibilityAurora.onChangeHeight) {
          yield state;
        }
      } catch (e) {
        yield null;
      }
    } else {
      yield null;
    }
  }
}
