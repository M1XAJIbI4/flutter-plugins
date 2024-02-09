// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/services.dart';

import 'flutter_keyboard_visibility_aurora_platform_interface.dart';

/// An implementation of [FlutterKeyboardVisibilityAuroraPlatform] that uses method channels.
class MethodChannelFlutterKeyboardVisibilityAurora
    extends FlutterKeyboardVisibilityAuroraPlatform {
  final methodChannel =
      const MethodChannel('flutter_keyboard_visibility_aurora');

  Stream<bool>? _onChangeVisibility;
  Stream<double>? _onChangeHeight;

  @override
  Future<double> getKeyboardHeight() async {
    return await methodChannel.invokeMethod<double>('getKeyboardHeight') ?? 0.0;
  }

  @override
  Stream<bool> onChangeVisibility() {
    _onChangeVisibility ??=
        const EventChannel('flutter_keyboard_visibility_aurora_state')
            .receiveBroadcastStream()
            .map((event) => event == true);
    return _onChangeVisibility!;
  }

  @override
  Stream<double> onChangeHeight() {
    _onChangeHeight ??=
        const EventChannel('flutter_keyboard_visibility_aurora_height')
            .receiveBroadcastStream()
            .map((event) => event as double);
    return _onChangeHeight!;
  }
}
