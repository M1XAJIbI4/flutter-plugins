// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'client_wrapper_demo_channel.dart';

abstract class ClientWrapperDemoPlatform extends PlatformInterface {
  /// Constructs a ClientWrapperDemoPlatform.
  ClientWrapperDemoPlatform() : super(token: _token);

  static final Object _token = Object();

  static ClientWrapperDemoPlatform _instance = MethodChannelClientWrapperDemo();

  /// The default instance of [ClientWrapperDemoPlatform] to use.
  ///
  /// Defaults to [MethodChannelCameraAurora].
  static ClientWrapperDemoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ClientWrapperDemoPlatform] when
  /// they register themselves.
  static set instance(ClientWrapperDemoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Create texture with default image
  /// Return texture ID
  Future<int?> createTexture();

  /// EncodableValue to transfer data from
  /// flutter platform channels to dart
  Future<dynamic> encodable();

  // /// Scream screen orientation angle
  // Stream<int?> eventBinaryMessage();
}
