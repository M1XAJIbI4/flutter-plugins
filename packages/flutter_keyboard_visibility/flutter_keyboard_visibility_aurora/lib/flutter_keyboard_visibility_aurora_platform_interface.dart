// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_keyboard_visibility_aurora_method_channel.dart';

abstract class FlutterKeyboardVisibilityAuroraPlatform
    extends PlatformInterface {
  /// Constructs a FlutterKeyboardVisibilityAuroraPlatform.
  FlutterKeyboardVisibilityAuroraPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterKeyboardVisibilityAuroraPlatform _instance =
      MethodChannelFlutterKeyboardVisibilityAurora();

  /// The default instance of [FlutterKeyboardVisibilityAuroraPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterKeyboardVisibilityAurora].
  static FlutterKeyboardVisibilityAuroraPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterKeyboardVisibilityAuroraPlatform] when
  /// they register themselves.
  static set instance(FlutterKeyboardVisibilityAuroraPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<double> getKeyboardHeight() {
    throw UnimplementedError('getKeyboardHeight() has not been implemented.');
  }

  Stream<bool> onChangeVisibility() {
    throw UnimplementedError('onChangeVisibility() has not been implemented.');
  }

  Stream<double> onChangeHeight() {
    throw UnimplementedError('onChangeHeight() has not been implemented.');
  }
}
